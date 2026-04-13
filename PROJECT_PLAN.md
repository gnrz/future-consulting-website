# WordPress Business Site - Project Plan

## Goal
Set up a WordPress site to host content for the business.

## Infrastructure
- **Hosting:** Digital Ocean App Platform
- **Source:** GitHub repository (to be created)
- **CMS:** WordPress

## WordPress Structure
- Option A: Full WP install committed to repo
- Dockerfile-based deployment (PHP + Apache)
- wp-config.php uses environment variables — safe to commit, no secrets in repo

## Status
- [ ] Clarify requirements
- [x] Clarify requirements
- [ ] Create GitHub repository
- [ ] Set up WordPress codebase
- [ ] Configure Digital Ocean App Platform
- [ ] Deploy and test

## Database
- **Reuse existing DO Managed DB**
- Host: `152.42.135.76:3306`
- Schema: `wordpress`
- Username: `wordpress`
- Password: stored as DO App Platform environment variable (never committed to repo)

## Domain
- `futureconsulting.nl` (DNS not yet configured)

## Repo
- GitHub org: `gnrz`
- Repo name: `future-consulting-website`
- Visibility: Public

## Notes
- Code is source for DO App Platform deployment
- Credentials injected via environment variables at runtime — never hardcoded in repo
- **Change DB password after initial setup** (was shared in plain text during planning)
