# Workflow Templates — Repo Sync Guide

Caller workflow templates for each repository to adopt the org's reusable workflows
from `Gray-Ghost-Data-Consultants-LLC/.github`.

## How to Use

1. Navigate to the folder matching your repo name below
2. Copy each `.yml` file into your repo's `.github/workflows/` directory
3. Update any `TODO` comments in the files with repo-specific values
4. Commit and push

> **Cross-Org Constraint:** Repos under the `grayghostdev` personal account cannot
> directly call `Gray-Ghost-Data-Consultants-LLC/.github` reusable workflows (GitHub
> requires the same owner for `workflow_call`). These repos must be **transferred to
> the org** first, or the reusable workflows must be forked into the personal account.
> Tier 1-3 repos below (from `grayghostdev`) are candidates for org transfer.

---

## Gap Analysis (as of 2026-04-07)

### Legend
- **Has** = workflow exists and calls the org reusable workflow
- **MISSING** = workflow needs to be added (template provided)
- **N/A** = not applicable for this repo type

### Org Repos (Gray-Ghost-Data-Consultants-LLC)

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

### Tier 1 — Client Projects (grayghostdev, transfer to org)

| Repository | Type | `ci.yml` | `security.yml` | `deploy-gcp.yml` | `deploy-vercel.yml` |
|------------|------|----------|-----------------|-------------------|---------------------|
| **Midway_Cleaning_app** | TypeScript | **MISSING** | **MISSING** | **MISSING** | N/A |
| **Luscious-Drops** | TypeScript | **MISSING** | **MISSING** | N/A | **MISSING** |
| **client-roofing** | Python | **MISSING** | **MISSING** | **MISSING** | N/A |
| **MouldenLaw** | TypeScript | **MISSING** | **MISSING** | N/A | **MISSING** |
| **client-onboarding** | TypeScript | **MISSING** | **MISSING** | **MISSING** | N/A |

### Tier 2 — Internal Tools (grayghostdev, transfer to org)

| Repository | Type | `ci.yml` | `security.yml` | `deploy-gcp.yml` | `deploy-vercel.yml` |
|------------|------|----------|-----------------|-------------------|---------------------|
| **Ghost** | Python | **MISSING** | **MISSING** | **MISSING** | N/A |
| **DataClasses** | Python | **MISSING** | **MISSING** | N/A | N/A |
| **webssh-service** | Python | **MISSING** | **MISSING** | **MISSING** | N/A |
| **security-lab** | Python | **MISSING** | **MISSING** | N/A | N/A |
| **ch001-cyber-forensics** | Python | **MISSING** | **MISSING** | N/A | N/A |
| **GrayGhostDataBusiness** | TypeScript | **MISSING** | **MISSING** | N/A | **MISSING** |
| **ToolboxAI-Dashboard** | TypeScript | **MISSING** | **MISSING** | N/A | **MISSING** |

### Tier 3 — Utilities (grayghostdev, lower priority)

| Repository | Type | `ci.yml` | `security.yml` | `deploy-gcp.yml` | `deploy-vercel.yml` |
|------------|------|----------|-----------------|-------------------|---------------------|
| **Snapps** | JavaScript | **MISSING** | **MISSING** | N/A | N/A |
| **social_Media_automations** | Python | N/A | **MISSING** | N/A | N/A |
| **n8n-custom** | Config | N/A | **MISSING** | N/A | N/A |
| **grayghost-business-automation** | Config | N/A | **MISSING** | N/A | N/A |
| **ggd-dashboard** | Mixed | N/A | **MISSING** | N/A | N/A |

### Tier 4 — Archive / Low Priority (no templates)

The following `grayghostdev` repos are candidates for archival or do not need workflow coverage:
- Web scrapers (multiple), crypto projects, tutorial forks, placeholder repos
- Consider archiving inactive repos to reduce attack surface

---

## Priority Order

### Org Repos
1. **the-system** — Missing security scanning and deployment (active TypeScript monorepo with 9 open issues)
2. **Structured-Project001** — Missing CI (has deploy + security but no lint/test gate)
3. **DiningByUpscale** — Missing Vercel deploy (Next.js frontend should use the reusable Vercel workflow)
4. **ggdc-infrastructure** — Missing security scanning (IaC repo should at minimum have secret + Trivy scanning)
5. **business-goals** — Missing secret scanning (low priority, docs only)
6. **after-the-storm** — Missing secret scanning (low priority, new repo)

### grayghostdev Repos (requires org transfer first)
7. **Midway_Cleaning_app** — Active client project, needs full CI/CD pipeline
8. **Luscious-Drops** — Client project, needs CI + Vercel deploy
9. **client-roofing** — Client project, needs full Python CI/CD
10. **MouldenLaw** — Client project, needs CI + Vercel deploy
11. **client-onboarding** — Client project, needs full CI/CD
12. **Ghost** — Internal tool, needs Python CI/CD
13. **GrayGhostDataBusiness** — Business site, needs CI + Vercel deploy
14. **ToolboxAI-Dashboard** — Internal dashboard, needs CI + Vercel deploy
15. **webssh-service** — Internal tool, needs Python CI/CD
16. **DataClasses** — Library, needs CI + security
17. **security-lab** — Research, needs CI + security
18. **ch001-cyber-forensics** — Research, needs CI + security
19. **Snapps** — Utility, needs CI + security
20. **social_Media_automations** — Utility, security-only
21. **n8n-custom** — Config, security-only
22. **grayghost-business-automation** — Config, security-only
23. **ggd-dashboard** — Dashboard, security-only

### Additional Notes

- **nomics_edu_AI** has an inline `ci.yml` (not calling the reusable CI workflow). Consider migrating to the reusable workflow for consistency. The inline CI includes custom Docker build steps and a dashboard build that may need to remain separate.
- **SmileDental** is fully synced — no changes needed.
- All `security.yml` templates include a weekly Monday 6 AM UTC schedule (`cron: '0 6 * * 1'`) matching the existing pattern in `nomics_edu_AI`.

---

## Template Directory Structure

```
workflow-templates/
├── README.md
│
│   # Org repos (Gray-Ghost-Data-Consultants-LLC)
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
├── after-the-storm/
│   └── security.yml         # Secret scanning only
│
│   # Tier 1 — Client Projects (grayghostdev)
├── Midway_Cleaning_app/
│   ├── ci.yml              # TypeScript CI
│   ├── security.yml         # Full security suite (Node)
│   └── deploy-gcp.yml       # GCP Cloud Run deploy
├── Luscious-Drops/
│   ├── ci.yml              # TypeScript CI
│   ├── security.yml         # Full security suite (Node)
│   └── deploy-vercel.yml    # Vercel deploy
├── client-roofing/
│   ├── ci.yml              # Python CI
│   ├── security.yml         # Full security suite (Python)
│   └── deploy-gcp.yml       # GCP Cloud Run deploy
├── MouldenLaw/
│   ├── ci.yml              # TypeScript CI
│   ├── security.yml         # Full security suite (Node)
│   └── deploy-vercel.yml    # Vercel deploy
├── client-onboarding/
│   ├── ci.yml              # TypeScript CI
│   ├── security.yml         # Full security suite (Node)
│   └── deploy-gcp.yml       # GCP Cloud Run deploy
│
│   # Tier 2 — Internal Tools (grayghostdev)
├── Ghost/
│   ├── ci.yml              # Python CI
│   ├── security.yml         # Full security suite (Python)
│   └── deploy-gcp.yml       # GCP Cloud Run deploy
├── DataClasses/
│   ├── ci.yml              # Python CI
│   └── security.yml         # Full security suite (Python)
├── webssh-service/
│   ├── ci.yml              # Python CI
│   ├── security.yml         # Full security suite (Python)
│   └── deploy-gcp.yml       # GCP Cloud Run deploy
├── security-lab/
│   ├── ci.yml              # Python CI
│   └── security.yml         # Full security suite (Python)
├── ch001-cyber-forensics/
│   ├── ci.yml              # Python CI
│   └── security.yml         # Full security suite (Python)
├── GrayGhostDataBusiness/
│   ├── ci.yml              # TypeScript CI
│   ├── security.yml         # Full security suite (Node)
│   └── deploy-vercel.yml    # Vercel deploy
├── ToolboxAI-Dashboard/
│   ├── ci.yml              # TypeScript CI
│   ├── security.yml         # Full security suite (Node)
│   └── deploy-vercel.yml    # Vercel deploy
│
│   # Tier 3 — Utilities (grayghostdev)
├── Snapps/
│   ├── ci.yml              # JavaScript CI (no typecheck)
│   └── security.yml         # Dependency audit + secret scan + Trivy
├── social_Media_automations/
│   └── security.yml         # Secret scanning only
├── n8n-custom/
│   └── security.yml         # Secret scanning only
├── grayghost-business-automation/
│   └── security.yml         # Secret scanning only
└── ggd-dashboard/
    └── security.yml         # Secret scanning only
```

## Required Secrets Per Workflow

| Workflow | Required Secrets |
|----------|-----------------|
| `ci.yml` | `NPM_TOKEN` (optional), `CLERK_PUBLISHABLE_KEY` (optional) |
| `security.yml` | `GITLEAKS_LICENSE` (optional, free for personal repos) |
| `deploy-gcp.yml` | `GCP_WORKLOAD_IDENTITY_PROVIDER`, `GCP_SERVICE_ACCOUNT` |
| `deploy-vercel.yml` | `VERCEL_TOKEN`, `VERCEL_ORG_ID`, `VERCEL_PROJECT_ID` |
