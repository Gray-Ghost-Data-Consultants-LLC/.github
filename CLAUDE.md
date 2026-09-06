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
profile/
  README.md                   # Public GitHub organization profile README
README.md                     # Organization defaults documentation
```

## Conventions
- Workflows must use `workflow_call` triggers to enable reuse across all organization repositories.
- Keep secret inputs minimal and inherit standard secrets (`secrets: inherit`).
- Deployments require health checks and automated rollback on failure.

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

