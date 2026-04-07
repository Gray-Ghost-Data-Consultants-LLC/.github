# AGENTS.md — Gray Ghost Data Consultants LLC

## Commands

```bash
# Validate all workflow YAML files
actionlint .github/workflows/*.yml

# Lint YAML formatting
yamllint .github/workflows/

# Check for secrets in the repo
gitleaks detect --source . --verbose
```

## Project Overview

This is the **organization-level `.github` repository** for Gray Ghost Data Consultants LLC. It provides four reusable GitHub Actions workflows consumed by all active repositories in the org via `workflow_call`. Changes here propagate automatically to every consumer repo referencing `@main`.

## Repository Structure

```
.github/
├── AGENTS.md                          # AI agent instructions (this file)
├── CODEOWNERS                         # Require platform-team review on workflow changes
├── README.md                          # Org-level description
├── .github/
│   ├── copilot-instructions.md        # Copilot-specific repo instructions
│   ├── dependabot.yml                 # Automated action version updates (weekly)
│   └── workflows/
│       ├── copilot-setup-steps.yml    # Copilot coding agent environment setup
│       ├── reusable-ci.yml            # CI: lint, typecheck, build, test (Node + Python)
│       ├── reusable-deploy-gcp.yml    # Deploy: Docker → GCP Cloud Run (canary)
│       ├── reusable-deploy-vercel.yml # Deploy: Next.js → Vercel + Sentry
│       └── reusable-security.yml      # Security: audit, secrets, SBOM, licenses, Trivy
└── workflow-templates/
    ├── README.md                      # Gap analysis and sync guide
    ├── the-system/                    # Missing: security.yml, deploy-gcp.yml
    ├── Structured-Project001/         # Missing: ci.yml (Python)
    ├── DiningByUpscale/               # Missing: deploy-vercel.yml
    ├── ggdc-infrastructure/           # Missing: security.yml
    ├── business-goals/                # Missing: security.yml
    ├── after-the-storm/               # Missing: security.yml
    │   # Tier 1 — Client Projects (grayghostdev → org transfer)
    ├── Midway_Cleaning_app/           # ci, security, deploy-gcp
    ├── Luscious-Drops/                # ci, security, deploy-vercel
    ├── client-roofing/                # ci (Python), security, deploy-gcp
    ├── MouldenLaw/                    # ci, security, deploy-vercel
    ├── client-onboarding/             # ci, security, deploy-gcp
    │   # Tier 2 — Internal Tools (grayghostdev → org transfer)
    ├── Ghost/                         # ci (Python), security, deploy-gcp
    ├── DataClasses/                   # ci (Python), security
    ├── webssh-service/                # ci (Python), security, deploy-gcp
    ├── security-lab/                  # ci (Python), security
    ├── ch001-cyber-forensics/         # ci (Python), security
    ├── GrayGhostDataBusiness/         # ci, security, deploy-vercel
    ├── ToolboxAI-Dashboard/           # ci, security, deploy-vercel
    │   # Tier 3 — Utilities (grayghostdev)
    ├── Snapps/                        # ci (JS), security
    ├── social_Media_automations/      # security only
    ├── n8n-custom/                    # security only
    ├── grayghost-business-automation/ # security only
    └── ggd-dashboard/                 # security only
```

## Reusable Workflow Reference

### reusable-ci.yml
- **Purpose:** Lint, typecheck, build, and test for Node.js and Python projects
- **Key inputs:** `node-version`, `python-version`, `turbo-filter`, `run-lint`, `run-typecheck`, `run-build`, `run-test`, `run-python-lint`, `run-python-test`
- **Secrets:** `NPM_TOKEN` (optional), `CLERK_PUBLISHABLE_KEY` (optional)
- **Caller example:**
```yaml
jobs:
  ci:
    uses: Gray-Ghost-Data-Consultants-LLC/.github/.github/workflows/reusable-ci.yml@main
    with:
      node-version: "20"
      run-lint: true
      run-typecheck: true
      run-build: true
    secrets: inherit
```

### reusable-deploy-gcp.yml
- **Purpose:** Build Docker image, push to Artifact Registry, canary deploy to Cloud Run with error-rate monitoring and rollback
- **Key inputs:** `service` (required), `gcp-project-id`, `gcp-region`, `memory`, `cpu`, `max-instances`, `canary-observe-minutes`, `error-rate-threshold`, `set-secrets`, `set-env-vars`, `run-alembic-migration`
- **Secrets:** `GCP_WORKLOAD_IDENTITY_PROVIDER` (required), `GCP_SERVICE_ACCOUNT` (required)

### reusable-deploy-vercel.yml
- **Purpose:** Build and deploy Next.js/frontend projects to Vercel with smoke tests and Sentry releases
- **Key inputs:** `node-version`, `turbo-filter`, `production`, `production-url`, `smoke-test-paths`
- **Secrets:** `VERCEL_TOKEN`, `VERCEL_ORG_ID`, `VERCEL_PROJECT_ID` (all required)

### reusable-security.yml
- **Purpose:** npm audit, pip-audit, Gitleaks secret detection, Trivy filesystem scan, SBOM generation (CycloneDX + SPDX), license compliance
- **Key inputs:** `run-dependency-audit`, `run-secret-scan`, `run-sbom`, `run-license-check`, `run-pip-audit`, `run-trivy-fs`, `audit-level`, `allowed-licenses`
- **Secrets:** `GITLEAKS_LICENSE` (optional), `NPM_TOKEN` (optional)

## Workflow Changes Log (2026-04-07)

### CRITICAL: Trivy Supply Chain Fix
`aquasecurity/trivy-action` was compromised on 2026-03-19 — a threat actor hijacked 76 of 77 version tags to inject credential-stealing malware. Both usages upgraded from `@0.31.0`/`@v0.31.0` to `@v0.35.0` (verified safe post-incident release).

### Action Version Upgrades

| Action | Before | After | File |
|--------|--------|-------|------|
| `aquasecurity/trivy-action` | `@0.31.0` / `@v0.31.0` | `@v0.35.0` | reusable-security.yml, reusable-deploy-gcp.yml |
| `amondnet/vercel-action` | `@v25` | `@v41` | reusable-deploy-vercel.yml |
| `getsentry/action-release` | `@v1` | `@v3` | reusable-deploy-vercel.yml |
| `google-github-actions/auth` | `@v2` | `@v3` | reusable-deploy-gcp.yml |
| `google-github-actions/setup-gcloud` | `@v2` | `@v3` | reusable-deploy-gcp.yml |

### Bug Fixes
- **GCP deploy environment hardcoded:** Changed `name: production` to `name: ${{ inputs.environment }}` in reusable-deploy-gcp.yml

### Performance
- **Pip caching:** Added `cache: "pip"` to `actions/setup-python@v5` in both `python-lint` and `python-test` jobs in reusable-ci.yml

### Infrastructure Added
- **dependabot.yml:** Weekly automated GitHub Actions version update PRs
- **CODEOWNERS:** Requires `@Gray-Ghost-Data-Consultants-LLC/platform-team` review for all workflow changes
- **workflow-templates/:** Ready-to-copy caller workflows for 6 repos with gap analysis

### Actions Confirmed Current (No Changes Needed)
`actions/checkout@v4`, `actions/setup-node@v4`, `actions/setup-python@v5`, `actions/upload-artifact@v4`, `github/codeql-action/upload-sarif@v3`, `gitleaks/gitleaks-action@v2`

## Org Repo Sync Status

> **Cross-Org Note:** Repos under `grayghostdev` (Tiers 1-3) cannot call org reusable
> workflows until transferred to `Gray-Ghost-Data-Consultants-LLC`. Templates are
> pre-built and ready to activate after transfer.

### Gray-Ghost-Data-Consultants-LLC (Org Repos)

| Repository | Type | ci | security | deploy-gcp | deploy-vercel | Status |
|------------|------|:--:|:--------:|:----------:|:-------------:|--------|
| the-system | TypeScript | Y | **N** | **N** | N/A | Template ready |
| DiningByUpscale | Next.js+FastAPI | Y | Y | Y | **N** | Template ready |
| nomics_edu_AI | Python | Y (inline) | Y | Y | N/A | Inline CI — consider migrating |
| SmileDental | TypeScript | Y | Y | Y | N/A | Fully synced |
| Structured-Project001 | Python | **N** | Y | Y | N/A | Template ready |
| ggdc-infrastructure | Shell/IaC | N/A | **N** | N/A | N/A | Template ready |
| business-goals | Docs | N/A | **N** | N/A | N/A | Template ready |
| after-the-storm | New | N/A | **N** | N/A | N/A | Template ready |

### Tier 1 — Client Projects (grayghostdev → org transfer)

| Repository | Type | ci | security | deploy-gcp | deploy-vercel | Status |
|------------|------|:--:|:--------:|:----------:|:-------------:|--------|
| Midway_Cleaning_app | TypeScript | **N** | **N** | **N** | N/A | Template ready — transfer to org |
| Luscious-Drops | TypeScript | **N** | **N** | N/A | **N** | Template ready — transfer to org |
| client-roofing | Python | **N** | **N** | **N** | N/A | Template ready — transfer to org |
| MouldenLaw | TypeScript | **N** | **N** | N/A | **N** | Template ready — transfer to org |
| client-onboarding | TypeScript | **N** | **N** | **N** | N/A | Template ready — transfer to org |

### Tier 2 — Internal Tools (grayghostdev → org transfer)

| Repository | Type | ci | security | deploy-gcp | deploy-vercel | Status |
|------------|------|:--:|:--------:|:----------:|:-------------:|--------|
| Ghost | Python | **N** | **N** | **N** | N/A | Template ready — transfer to org |
| DataClasses | Python | **N** | **N** | N/A | N/A | Template ready — transfer to org |
| webssh-service | Python | **N** | **N** | **N** | N/A | Template ready — transfer to org |
| security-lab | Python | **N** | **N** | N/A | N/A | Template ready — transfer to org |
| ch001-cyber-forensics | Python | **N** | **N** | N/A | N/A | Template ready — transfer to org |
| GrayGhostDataBusiness | TypeScript | **N** | **N** | N/A | **N** | Template ready — transfer to org |
| ToolboxAI-Dashboard | TypeScript | **N** | **N** | N/A | **N** | Template ready — transfer to org |

### Tier 3 — Utilities (grayghostdev, lower priority)

| Repository | Type | ci | security | deploy-gcp | deploy-vercel | Status |
|------------|------|:--:|:--------:|:----------:|:-------------:|--------|
| Snapps | JavaScript | **N** | **N** | N/A | N/A | Template ready — transfer to org |
| social_Media_automations | Python | N/A | **N** | N/A | N/A | Template ready — security only |
| n8n-custom | Config | N/A | **N** | N/A | N/A | Template ready — security only |
| grayghost-business-automation | Config | N/A | **N** | N/A | N/A | Template ready — security only |
| ggd-dashboard | Mixed | N/A | **N** | N/A | N/A | Template ready — security only |

### Lifecycle Flags

> See [REPO-LIFECYCLE.md](REPO-LIFECYCLE.md) for the full repository assessment,
> consolidation opportunities, and quarterly review policy.

| Repository | Flag | Action |
|------------|------|--------|
| social_Media_automations | Stale | Archive — superseded by Social-auto-workflows |
| Structured-Project001 | Under Review | Confirm purpose within 30 days |
| toolbox-production-final | Stale | Archive — superseded by ToolboxAI-Dashboard |
| robloxMVP_001 | Stale | Archive — org version already archived |

**30+ additional grayghostdev repos** are recommended for archival or deletion.
See REPO-LIFECYCLE.md for the complete list and phased action plan.

## Code Style and Conventions

### YAML Formatting
- 2-space indentation, no tabs
- Use double quotes for string values in `with:` blocks
- One blank line between jobs, no trailing whitespace

### Action Version Pinning Policy
- **Official GitHub actions** (`actions/*`): Use major version tags (`@v4`)
- **Google actions** (`google-github-actions/*`): Use major version tags (`@v3`)
- **Third-party security actions** (`aquasecurity/trivy-action`): Pin to specific version (`@v0.35.0`) due to March 2026 supply chain incident
- **Never** use `@latest` or `@main` for action references
- Dependabot handles version drift via weekly PRs

### Naming Conventions
- Reusable workflows: `reusable-{purpose}.yml` (e.g., `reusable-ci.yml`)
- Caller workflows in client repos: `{purpose}.yml` (e.g., `ci.yml`, `deploy-gcp.yml`, `security.yml`)
- Workflow names use Title Case (e.g., `name: Reusable CI`)
- Job IDs use kebab-case (e.g., `type-check`, `python-lint`)

## Git Workflow

- **Branch naming:** `claude/{description}` or `feature/{description}`
- **Commit messages:** Conventional Commits format — `fix:`, `feat:`, `ci:`, `docs:`
- **PRs:** All workflow changes require CODEOWNERS review
- **Merges:** Squash merge to `main`

## Boundaries

### Safe to Modify
- Workflow YAML files (add inputs, upgrade actions, fix bugs)
- workflow-templates/ (add new templates, update existing)
- Documentation (README.md, AGENTS.md, copilot-instructions.md)
- dependabot.yml (adjust schedule, add ecosystems)
- CODEOWNERS (update team references)

### Requires Human Approval
- Changing required secrets (may break consumer repos)
- Removing or renaming workflow inputs (breaking change for callers)
- Modifying the GCP project ID default (`sylvan-flight-476922-m7`)
- Any changes to deployment targets (regions, registries)

### Never Modify
- Do not hardcode secrets, API keys, or credentials in any file
- Do not add `workflow_dispatch` triggers to reusable workflows (they only use `workflow_call`)
- Do not remove `continue-on-error: true` from Trivy scan steps without team discussion

## Copilot Autonomous Integration

### How It Works
GitHub Copilot's coding agent runs inside GitHub Actions. When you assign an issue to Copilot, it spins up an ephemeral environment, explores the repo, writes code, runs validation, and opens a PR for review.

### Setup for This Repo
Three files enable Copilot coding agent integration:

1. **`AGENTS.md`** (this file) — Provides project context, commands, conventions, and boundaries to any AI coding agent (Copilot, Claude Code, Cursor)

2. **`.github/copilot-instructions.md`** — Copilot-specific instructions that supplement AGENTS.md with security policies and workflow editing rules

3. **`.github/workflows/copilot-setup-steps.yml`** — Pre-installs `actionlint` and `yamllint` so Copilot can validate workflow changes before committing

### Enabling Copilot Agent for the Org

**Step 1: Enable the coding agent in org settings**
- Go to Organization Settings > Copilot > Policies
- Enable "Copilot coding agent" for the organization
- Optionally set a default runner via org-level runner controls

**Step 2: Configure each repo**
Copy `.github/workflows/copilot-setup-steps.yml` from this repo into each client repo, then customize the setup steps for that repo's language/toolchain:

```yaml
# Example for a Node.js repo
- uses: actions/setup-node@v4
  with:
    node-version: "20"
    cache: "npm"
- run: npm ci --legacy-peer-deps

# Example for a Python repo
- uses: actions/setup-python@v5
  with:
    python-version: "3.12"
    cache: "pip"
- run: pip install -e ".[dev]"
```

**Step 3: Assign issues to Copilot**
- Open any GitHub issue
- Click "Assignees" > select "Copilot"
- Optionally add guidance in the prompt field (e.g., "Use the reusable CI workflow from .github repo")
- Copilot will create a draft PR, push commits, run tests, and request review

**Step 4: Add AGENTS.md to client repos**
Each client repo should have its own `AGENTS.md` with project-specific commands, test instructions, and conventions. This repo's `AGENTS.md` serves as a template for the pattern.

### Agentic Workflows (GitHub Actions Integration)
GitHub Agentic Workflows allow Copilot to be triggered automatically by GitHub Actions events (e.g., new issues, failed CI). This is in technical preview as of 2026. To prepare:

- Ensure all repos have `copilot-setup-steps.yml` configured
- Keep `AGENTS.md` updated with current commands and conventions
- Structure issues with clear acceptance criteria so Copilot can plan effectively
- Use labels (e.g., `copilot-eligible`) to identify issues suitable for autonomous resolution
