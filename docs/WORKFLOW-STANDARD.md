# GitHub Actions workflow standard

Every workflow in a Gray-Ghost-Data-Consultants-LLC repository follows these
rules. They exist because every hosted minute on a private repository is billed,
and because runs that are cancelled, skipped, duplicated, bot-triggered or hung
cost the same as useful ones.

The rules are enforced by `scripts/check-workflow-standard.sh` and
`.github/workflows/workflow-lint.yml` in this repository (see
[Enforcement](#enforcement)). The starter files in `workflow-templates/` already
comply. Start new workflows from them.

## Required

These fail the lint gate.

### 1. `concurrency` on every workflow

A newer run on the same pull request cancels the older one. Runs on the default
branch queue instead of cancelling, so every commit on the default branch still
gets a result.

```yaml
concurrency:
  group: ${{ github.workflow }}-${{ github.event.pull_request.number || github.ref }}
  cancel-in-progress: ${{ github.event_name == 'pull_request' }}
```

A workflow whose **only** trigger is `workflow_call` is exempt: the caller owns
concurrency. A reusable workflow that sets its own group anyway must give the
group a unique prefix, as `reusable-security.yml` does. Inside a called workflow,
`github.workflow` is the **caller's** name. If the callee uses the same
expression as the caller, the two share a group and GitHub cancels the run as a
deadlock.

### 2. `timeout-minutes` on every job

The platform default is 360 minutes, so a hung job bills six hours. Use these
values:

| Job kind | timeout-minutes |
|---|---|
| lint, type-check, board and label automation | 5–10 |
| build, unit tests, security scans | 15–30 |
| end-to-end / browser tests | 45 |

A job that calls a reusable workflow (`uses:` at the job level) **cannot** set
`timeout-minutes`. The timeout belongs to the jobs inside the reusable workflow,
and the org reusable workflows expose it as a `timeout-minutes` input.

### 3. Least-privilege `permissions`

Set a top-level default of `contents: read`. Grant anything more on the job that
needs it, with a comment saying why.

```yaml
permissions:
  contents: read

jobs:
  scan:
    permissions:
      contents: read
      security-events: write   # SARIF upload
```

A reusable workflow can only narrow what its caller grants. If a called job asks
for a scope the caller did not grant, the run fails at startup. When you call an
org reusable workflow, grant exactly the scopes its header comment lists.

## Expected

The lint gate reports these as warnings. `--strict` turns them into failures.

### 4. `push` runs on the default branch only

```yaml
on:
  push:
    branches: [main]      # $default-branch in templates
  pull_request:
```

A push to a feature branch that has an open pull request otherwise runs every
workflow twice. Tags may be added (`tags: ['v*']`) for release workflows.

### 5. `paths` / `paths-ignore` filters

A documentation-only change should not run a build. Add `paths-ignore:
["**.md", "docs/**"]`, or a positive `paths:` list for a workflow that only
concerns part of the repository.

### 6. No bare `issue_comment` or `labeled` triggers

These events fire constantly, and each one is a billed run even when the job
immediately decides it has nothing to do. Use them only when the job has an
early job-level `if:` that filters on the comment body or the label name, so the
job is skipped rather than started:

```yaml
jobs:
  deploy-preview:
    if: ${{ github.event.label.name == 'deploy-preview' }}
```

Do not list `labeled`, `assigned`, `review_requested` or `synchronize` "just in
case". Each one multiplies run count.

### 7. Skip bot actors in automation workflows

Automation that reacts to issues and pull requests (board sync, labelling,
triage) skips runs whose actor is a bot:

```yaml
if: ${{ !endsWith(github.actor, '[bot]') }}
```

Bot-triggered `pull_request` runs (for example Dependabot) receive no secrets
and a read-only token, so this kind of automation cannot succeed for them anyway.

### 8. Third-party actions are pinned to a commit SHA

```yaml
- uses: aquasecurity/trivy-action@57a97c7e7821a5776cebc9bb87c984fa69cba8f1 # v0.35.0
```

- Keep the version comment so update tooling can move the pin.
- Pin to the SHA the tag resolves to **today**. Do not jump versions in the same
  change.
- Actions from `actions/*` and `github/*`, and this organization's own reusable
  workflows (`Gray-Ghost-Data-Consultants-LLC/.github/...@main`), may use a tag
  or branch.
- Tools downloaded in a `run:` step are pinned to a version **and** verified
  against a SHA-256 recorded in the workflow (see the gitleaks and actionlint
  installs in this repository).

### 9. `setup-*` steps use their built-in cache

```yaml
- uses: actions/setup-node@v4
  with:
    node-version: "20"
    cache: npm            # or pnpm
- uses: actions/setup-python@v5
  with:
    python-version: "3.12"
    cache: pip            # uv: use astral-sh/setup-uv with enable-cache: true
```

`setup-python` with `cache: pip` fails when the repository has no
`requirements*.txt` or `pyproject.toml`, which is why the reusable workflow's
`python-cache` input defaults to empty.

### 10. Draft pull requests skip heavy jobs

Builds, test suites, E2E, image builds and full scans do not run while a pull
request is a draft. Add `ready_for_review` to the trigger so they run once when
it leaves draft:

```yaml
on:
  pull_request:
    types: [opened, synchronize, reopened, ready_for_review]
jobs:
  build:
    if: ${{ github.event.pull_request.draft != true }}
```

Use `!= true`, not `== false`. On a `push` there is no `pull_request` object,
and `null == false` evaluates true in expressions (both coerce to 0), which
would skip the job on every push. Cheap checks such as lint may still run on
drafts.

## `pull_request_target`

`pull_request_target` runs with a write token and repository secrets, even for
pull requests from forks. Use it only for jobs that act on pull request
**metadata**: labelling, auto-merge of dependency updates, triage comments.

- **Never** check out or execute pull request code in it. That means no
  `actions/checkout` with `ref: ${{ github.event.pull_request.head.sha }}`,
  `github.head_ref` or `refs/pull/*`, and no build, install or test step. The
  lint gate warns on these checkouts.
- Set explicit, minimal `permissions` on the job.
- Guard the job with an `if:` on the actor or the label.
- Never interpolate pull request titles, bodies or branch names into `run:`.
  Pass them through `env:` and quote them.

## Secret-scan baselines

`reusable-security.yml` accepts `gitleaks-baseline`: a gitleaks **JSON** report
of findings that should no longer fail the scan. New findings still fail. A
baseline hides real history, so the following conditions apply.

- **Every finding in the baseline has been triaged by a person.** Each one is a
  confirmed false positive or a real secret.
- **Every real secret has been rotated and the old value revoked** before its
  finding enters the baseline. Rewriting history does not count as remediation.
  A baseline is never a substitute for rotation.
- **The baseline file is added in its own pull request with a human reviewer.**
  The PR description lists each finding (rule, file, commit) and its triage
  outcome.
- **In repositories under HIPAA, COPPA or FERPA obligations, compliance sign-off**
  is also required before that pull request merges.
- **Never generate a baseline just to make a red scan green.** A repository with
  untriaged findings keeps `run-gitleaks-cli` failing, or leaves it off, until a
  person has done the triage.

Generate the file with the same pinned gitleaks version the workflow uses:

```
gitleaks git --redact --report-format json --report-path .gitleaks-baseline.json .
```

Then review every entry before committing it. `--redact` keeps secret values
out of the file.

## Runners

GitHub-hosted `ubuntu-latest` is the default for every job.

Self-hosted macOS runners exist for work that needs them. Target them **only**
with these labels:

| Label | Use |
|---|---|
| `ggdc` | general self-hosted work that must run on org hardware |
| `sp001-ci` | the one project pipeline that is routed to its own runner |
| `unity` | Unity builds |

- Do not invent new labels. A job with an unknown label waits in the queue for a
  runner that never comes. `actionlint` rejects any self-hosted label that is
  not declared under `self-hosted-runner.labels` in the repository's
  `.github/actionlint.yaml`, so declare the three above there.
- Do not move `pnpm` or `actions/setup-python` jobs onto the self-hosted Macs.
  Both are known to fail on those hosts. Keep them on GitHub-hosted runners.

## Reusable workflows and templates

| Need | Use |
|---|---|
| Node.js lint / type-check / build / test | `workflow-templates/ci-node.yml` → `reusable-ci.yml` |
| Python ruff + pytest | `workflow-templates/ci-python.yml` → `reusable-ci.yml` |
| Secret scan, dependency audit, Trivy, SBOM, licences (npm / pnpm / yarn, pip / uv, any subdirectory) | `workflow-templates/security.yml` → `reusable-security.yml` |
| Org project board sync | `workflow-templates/project-sync.yml` → `reusable-project-board.yml` |
| Workflow lint | `.github/workflows/workflow-lint.yml` (callable) |

Prefer calling a reusable workflow over copying its steps. A fix made in this
repository then reaches every caller at once.

Changes to a reusable workflow must stay **backward compatible**:

- New inputs are optional, with defaults that reproduce current behaviour.
- A called job's permissions may only shrink. Any permission added to a called
  job breaks every caller that does not grant it.
- Record any deliberate default change in the pull request description, with
  the callers it affects.

## Enforcement

`workflow-lint.yml` runs `actionlint` (a pinned, checksum-verified binary) and
then `scripts/check-workflow-standard.sh`.

It runs on this repository's own pull requests. Any org repository can reuse it:

```yaml
name: Workflow lint
on:
  pull_request:
    paths: [".github/workflows/**", ".github/actionlint.yaml", ".github/workflow-standard-exceptions.txt"]
concurrency:
  group: ${{ github.workflow }}-${{ github.event.pull_request.number }}
  cancel-in-progress: true
permissions:
  contents: read
jobs:
  lint:
    uses: Gray-Ghost-Data-Consultants-LLC/.github/.github/workflows/workflow-lint.yml@main
    # with:
    #   strict: true          # fail on warnings too
```

Run it locally with `bash scripts/check-workflow-standard.sh [--strict]
[--exceptions FILE] [PATH ...]`. It needs mikefarah `yq` v4.

**Waivers.** An existing workflow that cannot comply yet is listed in
`.github/workflow-standard-exceptions.txt` as `<path> <rule>` with a reason.

- A waiver records debt. Delete the line in the pull request that fixes it.
- New workflows never get one.

Until branch protection can require status checks, this gate is advisory: it
reports on the pull request but cannot block the merge.
