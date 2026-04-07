# Repository Lifecycle Assessment

> **Assessed:** 2026-04-07 | **Next review:** 2026-07-07 (quarterly)
>
> Covers: Gray-Ghost-Data-Consultants-LLC (12 repos) and grayghostdev (~106 repos)

---

## Classification Criteria

| Status | Definition | Criteria | Default Action |
|--------|-----------|----------|----------------|
| **Active** | Under active development | Pushed within 6 months, serves current business purpose | Keep; ensure CI/CD coverage |
| **Maintenance** | Stable, occasional updates | Pushed within 12 months, functional, deployed or in use | Keep; security scans only |
| **Stale** | Unclear if still needed | No push in 6-12 months, not clearly abandoned | Review with owner; decide within 30 days |
| **Archive** | Should be archived | No push in 12+ months, OR unmodified fork, OR superseded duplicate | Archive (read-only, preserves history) |
| **Delete** | Should be deleted | Empty placeholder, tutorial fork with zero original content, or test repo | Delete after confirming no unique content |

---

## Org Repos — Gray-Ghost-Data-Consultants-LLC

### Already Archived (3) — No Action Required

| Repository | Language | Visibility | Archived Date | Notes |
|------------|----------|------------|---------------|-------|
| robolox_ai_agent | Python | Private | — | Superseded |
| ai_webscraper_demo | — | Public | — | Demo, no longer maintained |
| ai_webscraper | — | Private | — | Superseded by scraper consolidation |

### Active (5) — Keep

| Repository | Language | Last Push | Open Issues | Recommendation |
|------------|----------|-----------|-------------|----------------|
| .github | YAML | Apr 7, 2026 | 1 | Keep — org defaults and reusable workflows (this repo) |
| nomics_edu_AI | Python | Mar 16, 2026 | 12 | Keep — active development, 12 PRs |
| the-system | TypeScript | Recent | 9 | Keep — core monorepo, highest priority |
| DiningByUpscale | TypeScript | Recent | — | Keep — active client project |
| SmileDental | TypeScript | Recent | — | Keep — active client project |

### Under Review (4)

| Repository | Language | Last Push | Open Issues | Recommendation |
|------------|----------|-----------|-------------|----------------|
| Structured-Project001 | Python | Unknown | 8 | **Stale** — 8 open issues but unclear recent activity. Confirm purpose within 30 days or archive |
| ggdc-infrastructure | Shell | Recent | — | Keep — newly created, IaC repo |
| after-the-storm | — | Recent | — | Keep — newly created |
| business-goals | Mermaid | Unknown | — | **Maintenance** — planning docs, low-touch. Keep as reference |

---

## Personal Repos — grayghostdev

### Active (9 repos, pushed 2026) — Keep / Transfer to Org

| Repository | Language | Last Push | Description | Recommendation |
|------------|----------|-----------|-------------|----------------|
| Ghost | Python | Apr 6, 2026 | Enterprise backend framework (FastAPI) | Transfer to org (Tier 2) |
| Midway_Cleaning_app | TypeScript | Apr 6, 2026 | Client project | Transfer to org (Tier 1) |
| client-roofing | Python | Mar 30, 2026 | Client project (iSwitch Roofs) | Transfer to org (Tier 1) |
| Vintage-Jeans-Marketplace | Python | Mar 29, 2026 | FastAPI + React marketplace | Keep; evaluate for org transfer |
| Snapps | JavaScript | Mar 21, 2026 | Utility app | Transfer to org (Tier 3) |
| Social-auto-workflows | TypeScript | Mar 21, 2026 | Social media automation | Keep; replaces social_Media_automations |
| ghostdata-link-app | HTML | Feb 25, 2026 | Data exchange app | Keep |
| grayghostdata-website | TypeScript | Jan 22, 2026 | Company website | Keep or transfer to org |
| mintlify-docs | MDX | Jan 5, 2026 | Documentation site | Keep |

### Stale (20 repos, pushed 2025) — Review Required

| Repository | Language | Last Push | Recommendation |
|------------|----------|-----------|----------------|
| Accounts_Receivable | — | Sep 2025 | Archive unless business need confirmed |
| toolbox-production-final | TypeScript | Sep 2025 | Archive — superseded by ToolboxAI-Dashboard |
| email-sig | HTML | Jul 2025 | Archive — static asset, unlikely to change |
| test-rust-app | Rust | Jul 2025 | **Delete** — test/learning repo |
| social_Media_automations | JavaScript | Jun 2025 | Archive — superseded by Social-auto-workflows |
| green_info | HTML | Jun 2025 | Archive |
| real-leadgen-app | — | May 2025 | Archive — consolidate with lead_generator if needed |
| lead_generator | Python | May 2025 | Archive — consolidate with real-leadgen-app if needed |
| robloxMVP_001 | Python | Apr 2025 | Archive — org version already archived |
| ccarecodes | Python | Mar 2025 | Archive unless active client |
| incubizo-website | TypeScript | Mar 2025 | Archive unless active client |
| SOC | — | Mar 2025 | Archive |
| botpress | TypeScript | Mar 2025 | Archive — unmodified fork |
| MaySue2 | HTML | Mar 2025 | Archive — duplicate of maysue |
| fullcycleservice_site | HTML | Mar 2025 | Archive unless active client |
| maysue | HTML | Mar 2025 | Keep if client is active; archive MaySue2 |
| investor | Python | Feb 2025 | Archive |
| superScraper_app | TypeScript | Feb 2025 | Archive — scraper consolidation |
| RWA_Loandisk_Chainlink | TypeScript | Jan 2025 | Archive — crypto consolidation |
| grsfib | Python | Jan 2025 | Archive |

### Archive Candidates (22 repos, pushed 2024 or older)

| Repository | Language | Last Push | Reason |
|------------|----------|-----------|--------|
| fuzzylogic-possibilityLogic | Jupyter | Dec 2024 | Fork — no original content |
| TargetMarketData | — | Dec 2024 | Abandoned |
| business-location-search | Python | Dec 2024 | Abandoned |
| docs (Codecademy) | TypeScript | Dec 2024 | Fork — no original content |
| Scrapegraph-ai | Python | Nov 2024 | Fork — scraper consolidation |
| SamsScraper | — | Nov 2024 | Scraper consolidation |
| SuperScraper2 | Python | Nov 2024 | Scraper consolidation |
| super_web_scraper | Python | Nov 2024 | Scraper consolidation |
| FinalScraper | Python | Nov 2024 | Scraper consolidation |
| web_scraper | Python | Oct 2024 | Scraper consolidation |
| wholesale-crypto-app | — | Oct 2024 | Crypto consolidation |
| grayghostsite | HTML | Jul 2024 | Superseded by grayghostdata-website |
| ghostdata-application | — | Jun 2024 | Abandoned |
| Crypto-Applications-pacmandata | — | May 2024 | Crypto consolidation |
| GrayGhost-Crypto-Application | — | May 2024 | Crypto consolidation |
| DockerPHP | — | Mar 2024 | Abandoned learning repo |
| smartContract | TypeScript | Mar 2024 | Abandoned |
| MultiCurrencyWallet | TypeScript | Feb 2024 | Fork — crypto consolidation |
| WallArt | Swift | Feb 2024 | Abandoned — Swift/VisionOS prototype |
| TrendingFaves | Swift | Feb 2024 | Abandoned — Swift prototype |
| add-automated-tests-off-platform-project | Python | Aug 2023 | Tutorial fork |
| try-github-CLI-off-platform-project | Python | Aug 2023 | Tutorial fork |

### Delete Candidates (6 repos)

These contain zero original content (tutorial forks or test repos):

| Repository | Reason |
|------------|--------|
| add-automated-tests-off-platform-project | Codecademy tutorial fork |
| try-github-CLI-off-platform-project | Codecademy tutorial fork |
| docs (Codecademy) | Codecademy documentation fork |
| fuzzylogic-possibilityLogic | Forked Jupyter notebook |
| hello-world-docker-action | GitHub tutorial — no original content |
| test-rust-app | Test/learning repo — no business value |

---

## Consolidation Opportunities

### Scraper Repos (9 repos → 0)

| Repository | Status | Action |
|------------|--------|--------|
| SamsScraper | Archive | — |
| SuperScraper2 | Archive | — |
| super_web_scraper | Archive | — |
| FinalScraper | Archive | — |
| web_scraper | Archive | — |
| superScraper_app | Archive | — |
| Scrapegraph-ai | Archive | Fork, no original work |
| ai_webscraper | Already archived | — |
| ai_webscraper_demo | Already archived | — |

**Recommendation:** Archive all. If web scraping is still a business capability, extract
reusable patterns into the `Ghost` backend framework or a single `scraper-toolkit` repo.

### Crypto/Blockchain Repos (5 repos → 0)

| Repository | Status | Action |
|------------|--------|--------|
| wholesale-crypto-app | Archive | — |
| Crypto-Applications-pacmandata | Archive | — |
| GrayGhost-Crypto-Application | Archive | — |
| RWA_Loandisk_Chainlink | Archive | — |
| MultiCurrencyWallet | Archive | Fork, no original work |

**Recommendation:** Archive all unless blockchain is a current service offering.

### Client Site Duplicates (3 repos → 1)

- `MaySue2` + `maysue` — keep whichever has the most complete code, archive the other
- `fullcycleservice_site` — archive if client engagement is over

### Lead Generation (2 repos → 0-1)

- `real-leadgen-app` + `lead_generator` — archive both or consolidate if lead-gen is active

### Social Media (2 repos → 1)

- `social_Media_automations` (Jun 2025, stale) → superseded by `Social-auto-workflows` (Mar 2026, active)
- Archive `social_Media_automations`

---

## Recommended Action Plan

### Phase 1 — Immediate (This Week)

**Delete** 6 tutorial/test repos (zero original content):
- [ ] `add-automated-tests-off-platform-project`
- [ ] `try-github-CLI-off-platform-project`
- [ ] `docs` (Codecademy fork)
- [ ] `fuzzylogic-possibilityLogic`
- [ ] `hello-world-docker-action`
- [ ] `test-rust-app`

**Archive** scraper cluster (7 repos):
- [ ] `SamsScraper`
- [ ] `SuperScraper2`
- [ ] `super_web_scraper`
- [ ] `FinalScraper`
- [ ] `web_scraper`
- [ ] `superScraper_app`
- [ ] `Scrapegraph-ai`

**Archive** crypto cluster (4 repos):
- [ ] `wholesale-crypto-app`
- [ ] `Crypto-Applications-pacmandata`
- [ ] `GrayGhost-Crypto-Application`
- [ ] `MultiCurrencyWallet`

**Total Phase 1:** 6 deletes + 11 archives = 17 repos cleaned up

### Phase 2 — Near-Term (Weeks 2-3)

After owner confirmation on stale repos:

- [ ] Archive `toolbox-production-final` (superseded by ToolboxAI-Dashboard)
- [ ] Archive `social_Media_automations` (superseded by Social-auto-workflows)
- [ ] Archive `robloxMVP_001` (org version already archived)
- [ ] Archive `botpress` (unmodified fork)
- [ ] Archive `grayghostsite` (superseded by grayghostdata-website)
- [ ] Archive `ghostdata-application`
- [ ] Archive `RWA_Loandisk_Chainlink`
- [ ] Consolidate `MaySue2`/`maysue` — archive the older one
- [ ] Review `Accounts_Receivable`, `email-sig`, `green_info`, `SOC`, `investor`, `grsfib` with owner
- [ ] Review `ccarecodes`, `incubizo-website`, `fullcycleservice_site` — archive if clients inactive
- [ ] Review `real-leadgen-app` + `lead_generator` — archive or consolidate
- [ ] Review remaining abandoned 2024 repos (TargetMarketData, business-location-search, DockerPHP, smartContract, WallArt, TrendingFaves)
- [ ] Remove workflow-template directories for any repos confirmed for archival

**Total Phase 2:** ~15-20 additional archives after confirmation

### Phase 3 — Ongoing (Months 1-3)

- [ ] Transfer active grayghostdev repos to org per existing Tier 1/2/3 plan
- [ ] Apply CI/CD workflow templates to transferred repos
- [ ] Conduct Q3 2026 quarterly lifecycle review (Jul 7, 2026)
- [ ] Assess ~54 private grayghostdev repos not covered in this assessment

---

## Lifecycle Policy (Going Forward)

### Quarterly Review
- **Schedule:** First Monday of each quarter
- **Scope:** All repos across org and personal accounts
- **Output:** Updated REPO-LIFECYCLE.md with new assessment date

### Auto-Archive Triggers
A repo should be flagged for archival when ALL of the following are true:
- No push in 12+ months
- No open issues or pull requests
- No dependent repos or active deployments
- Not referenced by other active repos

### New Repo Requirements
- Every new repo must have a README with purpose statement within 7 days
- Must be assigned to a tier (client, internal, utility) within 7 days
- CI/CD workflow templates must be applied within 30 days

### Fork Policy
- Forks must have original commits within 30 days or be deleted
- Forks kept for reference only should be starred instead of forked
- Exception: forks maintained for upstream PRs

### Naming Conventions
- Client projects: prefix with `client-` (e.g., `client-roofing`)
- Internal tools: descriptive name (e.g., `Ghost`, `webssh-service`)
- Infrastructure: suffix with `-infrastructure` or `-infra`

---

## Private Repos Gap

This assessment covers 3 public org repos and ~52 public grayghostdev repos.
Approximately **9 private org repos** and **~54 private grayghostdev repos** were
identified but could not be fully assessed from public data alone.

The private org repos (the-system, DiningByUpscale, SmileDental, Structured-Project001,
ggdc-infrastructure, after-the-storm, business-goals, robolox_ai_agent, ai_webscraper)
were classified using metadata from the previous session's MCP exploration.

**Action:** Conduct a dedicated private repo audit during Phase 3 using authenticated
GitHub access to complete coverage of all ~106 grayghostdev repositories.

---

## Summary

| Category | Count | Action |
|----------|-------|--------|
| Org — Active | 5 | Keep, maintain CI/CD |
| Org — Already Archived | 3 | No action |
| Org — Under Review | 4 | Confirm within 30 days |
| Personal — Active | 9 | Keep / transfer to org |
| Personal — Stale | 20 | Review with owner |
| Personal — Archive | 22 | Archive |
| Personal — Delete | 6 | Delete |
| **Total assessed** | **69** | — |
| **Remaining (private, unassessed)** | **~37** | Phase 3 audit |
