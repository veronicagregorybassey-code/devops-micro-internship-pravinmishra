# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

A personal **fork** of the *DevOps Micro Internship (DMI) with Agentic AI* curriculum by Pravin Mishra (Cohort 3). It is a coursework/portfolio repo, **not** an application — there is no build, lint, or test step. Content is almost entirely Markdown assignment files that the learner fills in, plus screenshots as evidence. The learner here is **Veronica Bassey** (README "About Me" still shows the upstream template author, Pravin Mishra — it is meant to be personalized).

The "code" work in this repo is: editing Markdown, adding screenshots, keeping the root progress table in sync, and syncing from upstream each week.

## Layout

- `week-00` … `week-14/` — one folder per week. Each has a `README.md` (the assignment) and usually a `screenshots/` folder. The learner writes answers *in place* inside that README.
- `week-02-agentic-ai/` is the richest week and has an unusual structure:
  - `assignments/assignment-0N-*.md` — the blank prompts.
  - `solution-assignment-0N-*.md` (repo root of the week) — the learner's / reference solutions.
  - `Solutions_walkthrough/` — step-by-step guides with `images/`.
- `Ultimate-Agentic-DevOps-with-Claude-Code/` — a **separate nested project** (static HTML/CSS portfolio site) with **its own `CLAUDE.md`**. When working inside that folder, follow that file, not this one.
- `onboarding/` — fork/clone/submit walkthrough. `INSTRUCTIONS.md` — the submission workflow. `dmi_cohort3_resources.md` — program links.
- `badges/` — per-week SVG badges referenced by the root README "My DevOps Stack".

## The core workflow (this is the actual "development loop")

1. **Sync from upstream before starting a new week** (upstream = Pravin's original repo):
   ```bash
   git fetch upstream
   git merge upstream/main
   ```
   `origin` is the learner's fork; `upstream` is `pravinmishraaws/devops-micro-internship-pravinmishra`.
2. **Answer prompts by replacing placeholders in place.** Every blank is the literal string `Add your answer here...`. Remove it entirely and write the answer — never leave the placeholder behind.
3. **Add screenshots** into that week's `screenshots/` folder, referenced with relative Markdown paths (`![alt](screenshots/name.png)`). Delete the `.gitkeep` once real images exist.
4. **Update the root `README.md` progress table** for that week only: status `⬜ Not Started → 🔄 In Progress → ✅ Completed`, assignment `⏳ Pending → ✅ Solved`, and paste LinkedIn/Blog links.
5. **Uncomment the week's badge** in the root README "Your stack" section (remove the surrounding `<!-- -->`).
6. Commit and push to `origin`, then submit the fork URL.

## Conventions that matter

- **Screenshot filenames must not contain spaces** — use hyphens or underscores (`week-01-screenshot-01.png`). Note some existing files under `week-02-agentic-ai/screenshots/` (`screenshot 1.png`, …) violate this; don't copy that pattern.
- Only ever edit the **current week's row** in the progress table; leave other weeks untouched.
- Preview Markdown rendering (VS Code preview / GitHub) before committing — broken tables and image paths are the common failure.
- Screenshots must show the learner's own name/username (a DMI submission rule), and each week's LinkedIn post needs the required credit line documented in that week's README.
