# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Belle·Agenda** — single-page scheduling system for beauty salons/health professionals. No build step; pure HTML/CSS/JS files served via Firebase Hosting.

Live URL: `https://bella-agenda-226f0.web.app`
GitHub: `https://github.com/rafael-molinari2025/agenda-beleza`

## Deploy

To deploy after any change:

```bash
/c/Users/RafaeKatiaMolinari/AppData/Roaming/npm/firebase deploy \
  --token "FIREBASE_CI_TOKEN" \
  --project bella-agenda-226f0
```

The Firebase CI token was obtained via `npx firebase-tools login:ci` and must be provided by the user. To deploy only hosting (skip Firestore rules):

```bash
... deploy --only hosting
```

To push to GitHub (Windows Credential Manager blocks the stored `rafaelmolinari2019` token — use the header override):

```bash
git -c credential.helper="" \
    -c http.extraHeader="Authorization: Basic $(echo -n 'GITHUB_TOKEN:x-oauth-basic' | base64)" \
    push origin main
```

## Architecture

**No framework, no bundler.** Three HTML files served statically:

| File | Role |
|---|---|
| `index.html` | Meta-redirect to `login.html` |
| `login.html` | Firebase Auth (email/password) — redirects to `app.html` on success |
| `app.html` | Full application shell |

All Firebase SDKs (v10 compat) and QRCode.js are loaded via CDN inside each HTML file. `firebase-config.js` is a plain JS file that sets `const firebaseConfig = {...}` and is `<script src>`-ed before the Firebase SDK scripts.

## Data Layer (Firestore)

All data is scoped per authenticated user under `users/{uid}/`:

```
users/{uid}/settings/profile   — salonName, professionalName, pixKey, pixName, pixCity
users/{uid}/clients/{id}       — name, phone, bday, email, notes, createdAt
users/{uid}/services/{id}      — name, price, duration, commission, createdAt
users/{uid}/appts/{id}         — clientId, serviceId, date, time, notes, done, createdAt
```

`app.html` loads all four collections on auth, keeps them in a single in-memory `state` object, renders synchronously, then persists changes to Firestore async (fire-and-forget pattern — toast on error is not yet implemented).

Firestore security rules are in `firestore.rules` — each user can only read/write their own subtree.

## Key Behaviours

- **PIX QR Code** — generated client-side using the EMV/BACEN BR Code spec. `buildPixPayload()` and `crc16()` are self-contained in `app.html`. No external PIX API.
- **WhatsApp** — opens `wa.me/55{phone}?text=...` in a new tab. On new appointment save: WhatsApp opens automatically (400 ms delay), then PIX modal opens (800 ms delay) if a PIX key is configured.
- **Auth guard** — `app.html` redirects to `login.html` if `firebase.auth().onAuthStateChanged` returns no user.

## Firebase Hosting ignore list

`firebase.json` explicitly ignores `*.bat`, `*.sh`, `*.ps1`, `README.md`, `.git/**`, `.claude/**` — the Spark (free) plan forbids executable files.
