# Setting up jackgannaway.com

One step at a time. Each step says what "done" looks like before you move on.
Total time: about 45 minutes, plus waiting for DNS.

---

## Step 1: Create the Droplet (5 min)

In DigitalOcean → **Create → Droplets**:

- **Image:** Marketplace → **Docker on Ubuntu**
- **Size:** Basic → Regular → **$6/mo (1 GB RAM)**
- **Region:** Amsterdam (AMS3)
- **Authentication:** your SSH key
- **Backups:** turn on weekly backups (+$1.20/mo)
- **Hostname:** `jackgannaway`
- **Advanced options → Add initialization scripts:** paste the whole of
  `cloud-init.sh` from this repo. It does Step 3 for you on first boot,
  so you can **skip Step 3**. Allow 3–5 minutes after the Droplet appears.

✅ **Done when:** the Droplet shows an IP address. Write it down.

---

## Step 2: Point DNS at the Droplet (5 min, then wait)

Wherever each domain is registered, add these records (IP = your Droplet IP):

| Domain | Type | Name | Value |
|---|---|---|---|
| jackgannaway.com | A | `@` | Droplet IP |
| jackgannaway.com | A | `www` | Droplet IP |
| futureconsulting.nl | A | `@` | Droplet IP |
| futureconsulting.nl | A | `www` | Droplet IP |

⚠️ **Do not touch the MX records on futureconsulting.nl.** They route your
Fastmail email. Change only the A records.

✅ **Done when:** `dig +short jackgannaway.com` on your laptop prints the
Droplet IP. Can take minutes to a few hours.

---

## Step 3: Install the site (10 min). Skip if you used cloud-init.sh

> Used `cloud-init.sh`? Check it finished:
> `ssh root@DROPLET_IP tail -3 /var/log/cloud-init-output.log` should show
> `jackgannaway setup finished`. Then go to Step 4.

SSH in: `ssh root@DROPLET_IP`, then paste these one block at a time.

**3a. Add swap** (stops the 1 GB Droplet running out of memory):

```bash
fallocate -l 1G /swapfile && chmod 600 /swapfile && mkswap /swapfile && swapon /swapfile
echo '/swapfile none swap sw 0 0' >> /etc/fstab
```

**3b. Firewall** (only SSH and web traffic in):

```bash
ufw allow OpenSSH && ufw allow 80 && ufw allow 443 && ufw --force enable
```

**3c. Get the code and set passwords:**

```bash
git clone https://github.com/gnrz/future-consulting-website.git /opt/jackgannaway
cd /opt/jackgannaway
cp .env.example .env
sed -i "s|^DB_PASSWORD=.*|DB_PASSWORD=$(openssl rand -hex 24)|" .env
sed -i "s|^DB_ROOT_PASSWORD=.*|DB_ROOT_PASSWORD=$(openssl rand -hex 24)|" .env
```

**3d. Start it:**

```bash
docker compose up -d
docker compose ps
```

✅ **Done when:** `docker compose ps` shows `db`, `wordpress` and `caddy`
all "running" / "healthy".

> If DNS from Step 2 isn't ready yet, that's fine. Caddy keeps retrying
> the certificate and picks it up once DNS arrives.

---

## Step 4: Install WordPress (5 min)

Open **https://jackgannaway.com** in a browser.

- Language → Site title "Jack Gannaway" → choose a username (not `admin`)
  → strong password → your email → **Install**.

✅ **Done when:** you can log in at https://jackgannaway.com/wp-admin

---

## Step 5: Create the pages (15 min)

In wp-admin:

1. **Settings → Permalinks** → choose **Post name** → Save.
   *(Makes URLs like `/consulting/`. The futureconsulting.nl redirect needs this.)*
2. **Pages → Add New**, create four pages:
   - **Home**
   - **Projects** (links to https://www.wage-wizard.co.uk and https://datum.report)
   - **Consulting** (the slug must be `consulting`)
   - **Blog** (leave it empty; WordPress fills it with posts)
3. **Settings → Reading** → "Your homepage displays: **A static page**"
   → Homepage: *Home* → Posts page: *Blog* → Save.
4. **Appearance → Editor → Navigation** → add Home, Projects, Consulting, Blog.
5. **Plugins:** delete *Hello Dolly*. Keep Akismet only if you want blog comments.

✅ **Done when:** https://futureconsulting.nl lands on your Consulting page.

---

## Step 6: Backups (2 min)

Weekly Droplet backups (Step 1) cover the whole machine. For a daily
copy of just the site:

```bash
chmod +x /opt/jackgannaway/backup.sh
/opt/jackgannaway/backup.sh            # run once by hand to check it works
( crontab -l 2>/dev/null; echo "15 3 * * * /opt/jackgannaway/backup.sh >> /var/log/site-backup.log 2>&1" ) | crontab -
```

✅ **Done when:** the manual run prints `backup ok`.

---

## Step 7 (optional): Auto-deploy from GitHub

Only needed when this repo changes (e.g. the Caddyfile). Blog posts and
pages never need a deploy.

GitHub repo → Settings → Secrets → Actions, add:
- `DROPLET_HOST`: the Droplet IP
- `DROPLET_SSH_KEY`: a private key whose public half is in `/root/.ssh/authorized_keys`

---

## Day-to-day

- **Write a post:** wp-admin → Posts → Add New → Publish. No deploy needed.
- **Updates:** wp-admin → Dashboard → Updates. Click update. That's it.
- **Restart everything:** `cd /opt/jackgannaway && docker compose restart`
