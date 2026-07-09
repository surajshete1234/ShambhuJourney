# Getting this onto your iPhone 13 — Windows-only workflow

You don't own a Mac, so the one unavoidable step (compiling with Xcode) happens on
GitHub's free macOS build runners instead. Everything else — installing the finished app
onto your phone — happens on Windows.

## ⚠️ Privacy first

This repo will eventually contain a very personal love letter and (once you add them)
real photos/videos of Vishakha's pregnancy and Shambhu. **Create the GitHub repository as
Private**, not public. Steps below assume Private.

## Step 1 — Push this project to a private GitHub repo

If you don't have a GitHub account yet, create one at github.com (free).

On github.com: **New repository** → name it e.g. `shambhu-journey` → set to **Private** →
Create (don't initialize with a README, this project already has files).

Then from this folder in PowerShell or Git Bash:

```
git init
git add .
git commit -m "Initial commit: Shambhu's Journey app"
git branch -M main
git remote add origin https://github.com/<your-username>/shambhu-journey.git
git push -u origin main
```

(GitHub will prompt for sign-in the first time — use a personal access token if it asks
for a password, since GitHub no longer accepts account passwords over git.)

## Step 2 — Let GitHub Actions build the .ipa

Pushing to `main` automatically triggers the `.github/workflows/build-ipa.yml` workflow.
- Go to your repo on github.com → **Actions** tab → you should see "Build IPA" running.
- It takes roughly 3–8 minutes.
- When it finishes (green check), click into the run → under **Artifacts**, download
  **ShambhuJourney-ipa** (a zip containing `ShambhuJourney.ipa`).
- If it doesn't trigger automatically, go to Actions → "Build IPA" → **Run workflow**.

If the build fails, open the failed step's log and paste it back to me — I generated this
project without a Mac to compile-check it, so there's a real chance the first CI run
surfaces something small to fix.

## Step 3 — Install Sideloadly on Windows

Download from **sideloadly.io** (official site) and install it. Also install
**Apple Devices** from the Microsoft Store (or iTunes from apple.com) so Windows has the
Apple USB drivers Sideloadly needs.

## Step 4 — Sideload the .ipa onto your iPhone

1. Unzip the artifact you downloaded so you have `ShambhuJourney.ipa`.
2. Connect an iPhone (13 or 14 — both fully support this app's iOS 17 minimum) to your
   Windows PC with a USB cable. Unlock it and tap **Trust This Computer** if prompted.
3. Open Sideloadly. Your phone should appear in the device dropdown.
4. Drag `ShambhuJourney.ipa` into Sideloadly.
5. Enter your **Apple ID** (a free/regular Apple ID is fine — this does not require a
   paid Apple Developer account). Sideloadly uses it only to generate a free signing
   certificate; it doesn't need your Apple ID password stored anywhere beyond the sign-in.
6. Click **Start**. It installs directly onto your phone over the USB connection.
7. Repeat steps 2–6 for your **second iPhone** — same `.ipa`, same Apple ID. A free Apple
   ID's limit is on how many distinct apps it signs in a 7-day window (max 3), not how
   many devices run the same app, so installing on both the 13 and the 14 doesn't cost
   you anything extra.

## Step 5 — Trust the developer certificate on the iPhone

On **each** iPhone: **Settings → General → VPN & Device Management** → tap your Apple ID
entry under "Developer App" → **Trust**. Now you can open "Shambhu's Journey" from the
home screen.

## The 7-day catch (free Apple ID signing)

Apps signed with a **free** Apple ID expire after **7 days** — iOS will refuse to open it
and show "Unable to Verify App." To refresh it, just reconnect the affected iPhone to Windows and
click **Start** in Sideloadly again with the same .ipa (no rebuild needed, takes under a
minute). Sideloadly can also do this automatically over Wi-Fi if you enable its
background refresh feature.

If the 7-day refresh becomes annoying, a **paid Apple Developer account** ($99/year)
extends signed apps to 1 year and removes the device-count limits — same Sideloadly
process, just enter your paid account's Apple ID instead.

## Adding your real photos, videos, and music before building

Do this *before* pushing to GitHub (or push again after adding them — every push to
`main` re-triggers the build):
- Drop files into `Resources/Media/` and `Resources/Audio/` per the READMEs in those
  folders.
- Or skip this and use the in-app "+" import button on the Journey Timeline once it's
  running on your phone — no rebuild needed for that path.

## Updating the app later

Any time you change something (via me or yourself) and want it back on your phone:
`git add . && git commit -m "..." && git push` → wait for the Actions build → download
the new .ipa → Sideloadly → Start again.
