# Gray Ghost Data Consultants LLC

Full-stack software consultancy specializing in web applications, managed security (MSSP), and cloud infrastructure.

## Active Projects

| Project | Stack | Description |
|---------|-------|-------------|
| **Ghost-Platform** | Next.js, TypeScript, PostgreSQL, Cloud Run | Enterprise client management platform |
| **SP001** | FastAPI, React, Cloud Run | K-12 EdTech platform |
| **DiningByUpscale** | FastAPI, Next.js, Cloud Run | Corporate dining management |
| **SmileDental** | FastAPI, Next.js, Cloud Run | Dental practice management |
| **MidwayCleaning** | Next.js, Vercel | Cleaning service website |
| **LusciousDrops** | Next.js, Supabase, Vercel | E-commerce storefront |
| **AfterTheStorm** | WordPress | MSSP incident response consulting |

## Tech Stack

**Frontend:** Next.js, React, TypeScript, Mantine UI, Shadcn/ui, Tailwind CSS
**Backend:** FastAPI (Python), Node.js/Express, TypeScript
**Infrastructure:** GCP Cloud Run, Vercel, Cloudflare, Podman
**Data:** PostgreSQL, Supabase, Redis
**CI/CD:** GitHub Actions with reusable workflows, Dependabot
**Auth:** Clerk, JWT
**Monitoring:** Prometheus, Grafana, Loki, Jaeger

## Reusable Workflows

This org provides shared CI/CD workflows in the [`.github`](https://github.com/Gray-Ghost-Data-Consultants-LLC/.github) repo:

- `reusable-ci.yml` — Lint, test, and build
- `reusable-security.yml` — npm audit, Gitleaks, SBOM, Trivy, license check
- `reusable-deploy-gcp.yml` — Build and deploy to GCP Cloud Run
- `reusable-deploy-vercel.yml` — Build and deploy to Vercel
