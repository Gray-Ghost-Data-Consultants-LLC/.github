# Workflow Templates — Repo Sync Guide

Caller workflow templates for each repository to adopt the org's reusable workflows
from `Gray-Ghost-Data-Consultants-LLC/.github`.

## How to Use

1. Navigate to the folder matching your repo name below
2. Copy each `.yml` file into your repo's `.github/workflows/` directory
3. Update any `TODO` comments in the files with repo-specific values
4. Commit and push

---

## Gap Analysis (as of 2026-04-07)

### Legend
- **Has** = workflow exists and calls the org reusable workflow
- **MISSING** = workflow needs to be added (template provided)
- **N/A** = not applicable for this repo type

| Repository | Type | `ci.yml` | `security.yml` | `deploy-gcp.yml` | `deploy-vercel.yml` |
|------------|------|----------|-----------------|-------------------|---------------------|
| **the-system** | TypeScript | Has | **MISSING** | **MISSING** | N/A |
| **DiningByUpscale** | Next.js + FastAPI | Has | Has | Has | **MISSING** |
| **nomics_edu_AI** | Python | Has (inline) | Has | Has | N/A |
| **SmileDental** | TypeScript | Has | Has | Has | N/A |
| **Structured-Project001** | Python | **MISSING** | Has | Has | N/A |
| **ggdc-infrastructure** | Shell/IaC | N/A | **MISSING** | N/A | N/A |
| **business-goals** | Docs/Mermaid | N/A | **MISSING** | N/A | N/A |
| **after-the-storm** | New/TBD | N/A | **MISSING** | N/A | N/A |

### Priority Order

1. **the-system** — Missing security scanning and deployment (active TypeScript monorepo with 9 open issues)
2. **Structured-Project001** — Missing CI (has deploy + security but no lint/test gate)
3. **DiningByUpscale** — Missing Vercel deploy (Next.js frontend should use the reusable Vercel workflow)
4. **ggdc-infrastructure** — Missing security scanning (IaC repo should at minimum have secret + Trivy scanning)
5. **business-goals** — Missing secret scanning (low priority, docs only)
6. **after-the-storm** — Missing secret scanning (low priority, new repo)

### Additional Notes

- **nomics_edu_AI** has an inline `ci.yml` (not calling the reusable CI workflow). Consider migrating to the reusable workflow for consistency. The inline CI includes custom Docker build steps and a dashboard build that may need to remain separate.
- **SmileDental** is fully synced — no changes needed.
- All `security.yml` templates include a weekly Monday 6 AM UTC schedule (`cron: '0 6 * * 1'`) matching the existing pattern in `nomics_edu_AI`.

---

## Template Directory Structure

```
workflow-templates/
├── the-system/
│   ├── ci.yml              # TypeScript CI (lint, typecheck, build, test)
│   ├── security.yml         # Full security suite
│   └── deploy-gcp.yml       # GCP Cloud Run canary deploy
├── Structured-Project001/
│   └── ci.yml              # Python CI (ruff lint, pytest)
├── DiningByUpscale/
│   ├── deploy-vercel.yml    # Vercel production deploy + smoke tests
│   └── security.yml         # Full security suite (Node + Python)
├── ggdc-infrastructure/
│   └── security.yml         # Secret scan + Trivy IaC scanning
├── business-goals/
│   └── security.yml         # Secret scanning only
└── after-the-storm/
    └── security.yml         # Secret scanning only
```

## Required Secrets Per Workflow

| Workflow | Required Secrets |
|----------|-----------------|
| `ci.yml` | `NPM_TOKEN` (optional), `CLERK_PUBLISHABLE_KEY` (optional) |
| `security.yml` | `GITLEAKS_LICENSE` (optional, free for personal repos) |
| `deploy-gcp.yml` | `GCP_WORKLOAD_IDENTITY_PROVIDER`, `GCP_SERVICE_ACCOUNT` |
| `deploy-vercel.yml` | `VERCEL_TOKEN`, `VERCEL_ORG_ID`, `VERCEL_PROJECT_ID` |
