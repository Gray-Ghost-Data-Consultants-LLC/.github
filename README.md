# .github

Org-level defaults, reusable CI/CD workflows, and labeling governance for Gray Ghost Data Consultants LLC.

## Reusable Workflows
- `reusable-ci.yml`: Multi-language linting, typechecking, and test suite execution.
- `reusable-security.yml`: Gitleaks, SBOM, dependency audits, and Trivy filesystem scanning.
- `reusable-deploy-vercel.yml`: Vercel deployments with post-deploy smoke testing.
- `reusable-deploy-gcp.yml`: Artifact Registry container builds and canary deployments to GCP Cloud Run.
- `reusable-project-board.yml`: Adds issues and pull requests to the org board of record.
- `workflow-lint.yml`: actionlint plus the org workflow standard check; also callable from any repo.

## Workflow Standard
Every workflow follows [`docs/WORKFLOW-STANDARD.md`](docs/WORKFLOW-STANDARD.md): concurrency, job timeouts, least-privilege permissions, default-branch-only push, SHA-pinned third-party actions, cached setup steps and draft-PR skips. Start new workflows from the templates in [`workflow-templates/`](workflow-templates/) (`ci-node`, `ci-python`, `security`, `project-sync`), which appear under **Actions → New workflow** in every org repository.

## Universal Labeling Taxonomy
All repositories in `Gray-Ghost-Data-Consultants-LLC` adhere to the 25-label standardized taxonomy:
- **`type:*`**: `type:bug`, `type:feature`, `type:docs`, `type:refactor`, `type:performance`, `type:security`, `type:infra`, `type:chore`, `type:test`
- **`priority:*`**: `priority:critical`, `priority:high`, `priority:medium`, `priority:low`
- **`status:*`**: `status:needs-triage`, `status:in-progress`, `status:blocked`, `status:review-needed`
- **`area:*`**: `area:backend`, `area:frontend`, `area:database`, `area:devops`, `area:compliance`
- **`agent:*`**: `agent:assigned`, `agent:review-requested`, `agent:automated`

Sync using `sync-github-labels.sh` or `python3 ~/scripts/automations/sync-github-labels.py`.

