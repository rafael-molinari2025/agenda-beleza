# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Belle·Agenda** — single-page scheduling system for beauty salons/health professionals. No build step; pure HTML/CSS/JS files served via Firebase Hosting.

Live URL: `https://bella-agenda-226f0.web.app`
GitHub: `https://github.com/rafael-molinari2025/agenda-beleza`

## Local Development

```bash
npx --yes http-server . -p 3000 -c-1 --cors
# then open http://localhost:3000/login.html
```

## Deploy

Deploy to Firebase Hosting (requires CI token from `npx firebase-tools login:ci`):

```bash
npx firebase-tools deploy --token "FIREBASE_CI_TOKEN" --project bella-agenda-226f0 --only hosting
```

To also deploy Firestore rules, omit `--only hosting`.

Push to GitHub (Windows Credential Manager stores the wrong account `rafaelmolinari2019` — always use the header override with the `rafael-molinari2025` token):

```bash
TOKEN="GITHUB_TOKEN"
git -c credential.helper="" \
    -c "http.extraHeader=Authorization: Basic $(echo -n "$TOKEN:x-oauth-basic" | base64)" \
    push origin main
```

## Architecture

**No framework, no bundler.** Three HTML files served statically:

| File | Role |
|---|---|
| `index.html` | Meta-redirect to `login.html` |
| `login.html` | Firebase Auth (email/password) — redirects to `app.html` on success |
| `app.html` | Full application shell |

All Firebase SDKs (v10 compat) and QRCode.js are loaded via CDN inside each HTML file. `firebase-config.js` exports `const firebaseConfig = {...}` and is `<script src>`-ed before the Firebase SDK scripts.

## Data Layer (Firestore)

All data is scoped per authenticated user under `users/{uid}/`:

```
users/{uid}/settings/profile   — salonName, professionalName, pixKey, pixName, pixCity
users/{uid}/clients/{id}       — name, phone, bday, email, notes, createdAt
users/{uid}/services/{id}      — name, price, duration, commission, createdAt
users/{uid}/appts/{id}         — clientId, serviceId, date, time, notes, done, createdAt
```

`app.html` loads all four collections on auth, holds them in a single in-memory `state` object, renders synchronously, then persists changes to Firestore async (fire-and-forget). Firestore security rules are in `firestore.rules`.

## Key Behaviours

- **PIX QR Code** — generated client-side using the EMV/BACEN BR Code spec. `buildPixPayload()` and `crc16()` are self-contained in `app.html`. No external PIX API. If no PIX key is configured in Settings, the modal opens with a warning instead of a QR code.
- **WhatsApp** — opens `wa.me/55{phone}?text=...` in a new tab. On new appointment save: WhatsApp opens at 500 ms, PIX modal opens at 900 ms — both fire unconditionally (WhatsApp only if the client has a phone number).
- **Auth guard** — `app.html` redirects to `login.html` if `firebase.auth().onAuthStateChanged` returns no user.

## Firebase Hosting ignore list

`firebase.json` explicitly ignores `*.bat`, `*.sh`, `*.ps1`, `README.md`, `.git/**`, `.claude/**` — the Spark (free) plan forbids executable files.
