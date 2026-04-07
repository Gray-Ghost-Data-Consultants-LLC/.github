# Copilot Instructions — .github Org Repository

## What This Repo Does
This is the organization-level `.github` repository containing reusable GitHub Actions workflows for CI, security scanning, and deployment (GCP Cloud Run, Vercel). All client repos call these workflows via `workflow_call` with `@main`.

## Security Rules
- After the March 2026 aquasecurity/trivy-action supply chain attack, always pin third-party security actions to specific patch versions (e.g., `@v0.35.0`), not just major tags.
- Never use `@latest` or `@main` for action version references.
- Never hardcode secrets, API keys, GCP project IDs, or credentials in workflow files. Use `secrets:` and `inputs:` instead.
- Do not remove `continue-on-error: true` from vulnerability scan steps without explicit approval.

## Editing Workflows
- All workflow files are in `.github/workflows/` and use the `reusable-` prefix.
- These are `workflow_call` workflows — do not add `workflow_dispatch` triggers to them.
- Validate changes with `actionlint` before committing.
- Use 2-space YAML indentation, double-quoted strings in `with:` blocks.
- When upgrading action versions, update all instances across all workflow files for consistency.

## Breaking Changes
- Removing or renaming a workflow `input` is a breaking change — it will fail in every consumer repo.
- Removing a `secret` declaration is a breaking change.
- Adding a new required input or secret requires updating all consumer repos.
- Prefer adding optional inputs with sensible defaults over required ones.

## Workflow Templates
The `workflow-templates/` directory contains ready-to-copy caller workflows for repos missing coverage. Each subdirectory matches a repo name. See `workflow-templates/README.md` for the gap analysis.

## Commit Style
Use Conventional Commits: `fix:`, `feat:`, `ci:`, `docs:` prefixes. Keep messages concise (1-2 sentences) focused on why, not what.
