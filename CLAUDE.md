# github-org-defaults

## Overview
- **Category:** internal (clients | internal | learning | ideas | trainings)
- **Status:** active
- **Stack:** GitHub Actions, YAML, Markdown
- **Owner:** GrayGhostData / Gray-Ghost-Data-Consultants-LLC

## What this project is
Central source of truth for Gray-Ghost-Data-Consultants-LLC organization-level defaults, reusable GitHub Actions workflows (CI, Security scanning, Vercel deployment, GCP Cloud Run deployment), and public organization profile documentation.

## Layout
```
.github/
  workflows/
    reusable-ci.yml             # Reusable CI workflow (Node.js & Python test, lint, typecheck, build)
    reusable-security.yml       # Reusable Security scan (gitleaks, dependency audit, trivy-fs, SBOM, license check)
    reusable-deploy-vercel.yml  # Reusable Vercel frontend deployment with smoke tests & Sentry releases
    reusable-deploy-gcp.yml     # Reusable GCP Cloud Run Docker deployment with canary evaluation
    reusable-project-board.yml  # Reusable org project board sync (skips bot actors)
    workflow-lint.yml           # actionlint + workflow standard check (also workflow_call)
    project-sync.yml            # This repo's own board sync caller
  actionlint.yaml               # Scoped actionlint ignores
  workflow-standard-exceptions.txt  # Waivers (debt) for the standard check
docs/
  WORKFLOW-STANDARD.md          # The org GitHub Actions workflow standard
scripts/
  check-workflow-standard.sh    # Standard checker (needs mikefarah yq v4)
workflow-templates/             # Org starter workflows: ci-node, ci-python, security, project-sync
profile/
  README.md                   # Public GitHub organization profile README
README.md                     # Organization defaults documentation
```

## Conventions
- Workflows must use `workflow_call` triggers to enable reuse across all organization repositories.
- Keep secret inputs minimal and inherit standard secrets (`secrets: inherit`).
- Deployments require health checks and automated rollback on failure.
- Every workflow follows docs/WORKFLOW-STANDARD.md; run `bash scripts/check-workflow-standard.sh --exceptions .github/workflow-standard-exceptions.txt .github/workflows workflow-templates` and `actionlint .github/workflows/*.yml workflow-templates/*.yml` before pushing.
- Reusable-workflow changes must be backward compatible: new inputs optional with current-behaviour defaults, and called-job permissions may only shrink.
- This repository is PUBLIC: no secrets, internal hostnames or client names in files.

## Usage
Refer to reusable workflows from caller repositories:
```yaml
jobs:
  ci:
    uses: Gray-Ghost-Data-Consultants-LLC/.github/.github/workflows/reusable-ci.yml@main
    with:
      node-version: '20'
    secrets: inherit
```

