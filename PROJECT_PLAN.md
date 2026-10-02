# jackgannaway.com: Project Plan

## Goal
Personal site with a simple CMS: a few static pages and a blog.

| Page | Content |
|---|---|
| Home | Intro |
| Projects | Links to Wage Wizard and Datum |
| Consulting | Future Consulting info (futureconsulting.nl redirects here) |
| Blog | Personal blog (WordPress posts) |

## Infrastructure
- **Hosting:** one DigitalOcean Droplet, $6/mo (1 GB), weekly backups
- **Stack:** Docker Compose. Official `wordpress` image + MariaDB + Caddy (HTTPS)
- **This repo holds the server setup only.** WordPress itself, themes,
  plugins and uploads live in Docker volumes on the Droplet, so updates and
  plugin installs from wp-admin persist.
- **Database:** inside the compose stack, no public port.

## Why not App Platform
App Platform's filesystem is wiped on every redeploy, so uploads and
plugins installed from wp-admin would disappear, and WordPress needs managed
MySQL there ($15/mo). A Droplet is ~$7/mo all in and behaves like normal WordPress.

## Status
- [x] Requirements
- [x] Server setup in repo (compose, Caddyfile, backup script)
- [ ] Create Droplet: see SETUP.md step 1
- [ ] DNS for jackgannaway.com and futureconsulting.nl: step 2
- [ ] Install and create pages: steps 3 to 5
- [ ] Backups: step 6

## Follow-up
- The earlier plan pointed at a MySQL server on a public IP (port 3306) and
  noted its password had been shared in plain text. This site no longer
  uses it. **Decide what that server is still for**; if nothing, delete it.
  If something, firewall port 3306 and rotate the password.
