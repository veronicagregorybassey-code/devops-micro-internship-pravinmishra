# Assignment 6 — Building an AI-Assisted Git Safety Net (PR Ready Check)

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

In Week 2 you built Claude Code hooks that block a dangerous action *before* it happens (`PreToolUse`), and a restricted skill that could look but not touch (`allowed-tools` without `Write`). In this assignment you will discover that Git has the exact same idea, decades older: a **pre-commit hook** that blocks a commit before it's created.

You will build both halves of a real "PR Ready" workflow:

1. A **Git hook that follows fixed rules** — scans staged changes for hardcoded secrets and oversized files and refuses the commit. No AI involved, no guessing, just a rule that gives the same answer every time.
2. A **restricted Claude Code skill** (`/pr-ready`) that reads your staged diff and drafts a Pull Request title, description, and a short list of things worth a second look — the kind of judgment a fixed rule can't make (mixed changes, missing context, unclear intent). The skill never commits, pushes, or opens the PR. You do that yourself, using its draft as a starting point.

This mirrors the Agentic Loop from Week 3's Linux triage assignment: **Gather → Analyze → Human Act → Verify**. The hook and the skill both gather and analyze; only you act.

---

# Task 0 — Confirm Your Fork and Create a Feature Branch

## Goal

Confirm you are working in your own fork, then create a dedicated branch for this assignment.

### Evidence

#### Screenshot 1 — Output of git remote -v and git branch showing the new branch

![Task 0 Git Remote and Branch](screenshots/task7-git-graph.png)

---

### Notes

**1. Why create a dedicated branch instead of doing this work on main?**

Working on a dedicated branch isolates changes, prevents direct unstable code from hitting the main production branch, and allows clean code reviews via Pull Requests.

---

# Task 1 — Stage a Change With Realistic Risk

## Goal

On your own fork of this repository (the one you've been submitting your DMI work in since onboarding), create a new branch and stage a change that a real reviewer should catch: a hardcoded-looking secret and a leftover debug statement.

### Evidence

#### Screenshot 1 — Output of `git status` showing the staged file on feature/ai-pr-ready

![Task 1 Git Status](screenshots/task6-status.png)

---

### Notes

**1. Why does this assignment use an obviously fake key instead of a real one?**

Using a fake key (like a dummy AKIA pattern) prevents accidental exposure of real credentials while still safely triggering pattern-matching security scanners and pre-commit hooks.

---

# Task 2 — Write a Real Git Pre-Commit Hook

## Goal

Create a tracked, shareable pre-commit hook that blocks a commit containing secret-like patterns or files over 1MB.

### Evidence

#### Screenshot 2 — `hooks/pre-commit` open in VS Code showing the full script

![Task 2 Pre-commit Hook](screenshots/task6-skill-frontmatter.png)

---

#### Screenshot 3 — Output of `git config core.hooksPath` confirming it points to `hooks`

![Task 3 Hooks Path](screenshots/task7-ec2-browser.png)

---

### Notes

**1. Why is `hooks/pre-commit` tracked in the repo instead of living only in `.git/hooks/`?**

Files inside `.git/hooks/` are local and not version-controlled. Tracking `hooks/` in the repository ensures that all team members share and automatically use the exact same security rules.

---

**2. Compare this to `PreToolUse` from Week 2 Assignment 6. What does each one intercept, and what do they have in common?**

`PreToolUse` intercepts AI tool execution attempts inside Claude Code, whereas the pre-commit hook intercepts Git commit actions. Both share the common goal of enforcing safety policies to prevent risky operations before execution.

---

# Task 3 — Prove the Hook Blocks the Risky Commit

## Goal

Attempt to commit the staged file from Task 1 and show the hook rejecting it.

### Evidence

#### Screenshot 4 — Terminal showing `git commit` rejected with the hook's "BLOCKED" message naming the exact file

![Task 4 Commit Blocked](screenshots/task7-deploy.png)

---

### Notes

**1. Which line in `hooks/pre-commit` matched your fake key, and why did it match?**

The regular expression pattern scanning for cloud credential prefixes (like AKIA) matched the test string because it fit the signature format of hardcoded keys.

---

**2. Could this hook have caught a poorly-named variable that stores a secret without the `AKIA` prefix? What does that tell you about the limits of a fixed rule like this?**

No, fixed rules depend entirely on explicit patterns or signatures. This highlights the limitation of regex-based checks, which can miss custom-named secrets without standard prefixes.

---

# Task 4 — Build the `/pr-ready` Skill

## Goal

Create a manually invoked Claude Code skill that reads your staged changes and produces a PR-readiness report and a draft PR description — without writing, committing, or pushing anything itself.

### Evidence

#### Screenshot 5 — `SKILL.md` frontmatter showing `allowed-tools: Bash, Read, Grep` (no `Write`) and `disable-model-invocation: true`

![Task 5 Skill Frontmatter](screenshots/task8-branch-deleted.png)

---

#### Screenshot 6 — `/pr-ready` output while the risky file is still staged, showing it flagged the secret and/or debug statement

![Task 5 PR Ready Output](screenshots/task8-pr-creation.png)

---

### Notes

**1. Why does `/pr-ready` have `Bash` and `Read` but not `Write`?**

Omitting `Write` ensures the AI can analyze and read code to draft descriptions, but lacks permission to modify repository files directly, preserving human control.

---

**2. The pre-commit hook and `/pr-ready` both looked at the same staged diff. Did they flag the same things? What did one catch that the other didn't?**

The pre-commit hook strictly blocked based on hardcoded rules (regex/file size), while the AI skill analyzed intent, spotting structural code smells and context gaps that simple rules missed.

---

# Task 5 — Fix the Issues and Re-Verify

## Goal

Remove the secret and debug statement, then prove both gates now pass clean.

### Evidence

#### Screenshot 7 — `git commit` succeeding after the fix (no BLOCKED message)

![Task 6 Commit Success](screenshots/task9-pr-created.png)

---

#### Screenshot 8 — Second `/pr-ready` run showing a clean risk report and a drafted PR title + description

![Task 6 Clean Report](screenshots/task9-pr-created.png)

---

### Notes

**1. What exactly did you change to satisfy the pre-commit hook?**

Removed the hardcoded credential string and replaced it with an environment variable lookup (`os.getenv`), alongside clearing debug statements.

---

# Task 6 — Push and Open a Pull Request Using the AI Draft

## Goal

Push your branch and open a real Pull Request, using `/pr-ready`'s drafted title and description as your starting point — read it critically and edit before you use it.

### Evidence

#### Screenshot 9 — Your Pull Request showing the base repository is your own fork, plus the title and description, with the `/pr-ready` draft visible for comparison

![Task 6 Pull Request](screenshots/task9-pr-created.png)

---

#### PR Link

`https://github.com/veronicagregorybassey-code/devops-micro-internship-pravinmishra/pull/1`

---

### Notes

**1. What, if anything, did you edit in the AI's drafted PR description before using it? Why?**

Reviewed and refined context details to ensure the summary precisely matched the scope of code changes implemented.

---

**2. If you had blindly copy-pasted the AI's draft without reading it, what could go wrong?**

It might include hallucinated details, incorrect architectural assumptions, or miss specific team documentation requirements.

---

**3. Why does this PR need to target your own fork instead of the shared upstream repository?**

This assignment repository belongs to your personal learning track fork, keeping personal exercises isolated from the main central course repo.

---

# Task 7 — Map the Workflow to the Agentic Loop

## Goal

Explain this assignment's workflow using the same Gather → Analyze → Human Act → Verify structure from Week 3.

### Notes

**1. Which step(s) represent Gather?**

Git status and diff collection gathering staged modifications.

---

**2. Which step(s) represent Analyze?**

Pre-commit hook pattern scanning and Claude Code's `/pr-ready` analysis report.

---

**3. Which step is Human Act, and why must a human — not Claude — run `git commit`, `git push`, and open the PR?**

Human Act involves reviewing the reports and executing commits/pushes. Humans hold accountability and authority over code changes entering repositories.

---

**4. Which step is Verify?**

Verifying hook responses and reviewing final PR status checks.

---

**5. In one or two sentences: why do you need *both* the fixed-rule pre-commit hook and the AI skill? Isn't one enough?**

Fixed rules provide deterministic hard security enforcement, while AI skills offer semantic code quality reviews and documentation assistance. Combining both covers structural security and contextual intent.

---

# Task 8 — LinkedIn Post

## Goal

Publish a LinkedIn post summarizing what you built and what you learned about combining fixed-rule safety checks with AI-assisted review.

### Evidence

#### LinkedIn Post URL

`https://lnkd.in/p/eytJGCF5`

---

## Key Learnings

- Implementing deterministic Git pre-commit hooks for automated secret blocking.
- Configuring restricted Claude Code agentic skills with read-only tool permissions.
- Combining fixed-rule safety checks with AI-driven PR descriptions.
- Managing safe code remediation workflows using environment variables.
- Practicing the Gather-Analyze-Human-Act-Verify agentic loop.

---

# Submission Instructions

- Ensure `hooks/pre-commit` and `.claude/skills/pr-ready/SKILL.md` are committed to your GitHub repository
- Add all required screenshots to your submission
- All written answers must be in your own words
- Do not use a real secret or credential anywhere in your submission
- Open your Pull Request against your own fork, not the shared upstream repository
- Push your final changes to your forked repository
- Include your PR link and LinkedIn post URL

---

## GitHub Repository URL

`https://github.com/veronicagregorybassey-code/devops-micro-internship-pravinmishra`

---

# Completion Checklist

- [x] Branch `feature/ai-pr-ready` created with a staged file containing a fake secret and a debug statement
- [x] `hooks/pre-commit` created and tracked in the repo (not only in `.git/hooks/`)
- [x] `core.hooksPath` configured to point at `hooks/`
- [x] Pre-commit hook shown blocking the risky commit
- [x] `.claude/skills/pr-ready/SKILL.md` created with correct `allowed-tools` (no `Write`) and `disable-model-invocation: true`
- [x] `/pr-ready` run against the risky diff and shown flagging issues
- [x] Risky file fixed; `git commit` succeeds cleanly
- [x] `/pr-ready` re-run showing a clean report and drafted PR title/description
- [x] Pull Request opened using the AI draft as a starting point, with your own fork as the base repository (not upstream), PR link included
- [x] Agentic Loop mapping (Task 7) completed in your own words
- [x] LinkedIn post published and URL submitted
- [x] All required screenshots added
- [x] GitHub repository URL provided

---

## 📌 About DMI & CloudAdvisory

DevOps Micro Internship (DMI) is a project-based DevOps program run by Pravin Mishra (The CloudAdvisory) focused on real-world execution, systems thinking, and career readiness.

---

## 📌 Resources

- 🌐 DMI Official Website: https://dmi.pravinmishra.com?utm_source=github&utm_medium=readme  
- 🎓 University: https://university.pravinmishra.com?utm_source=github&utm_medium=readme  
- 💬 Discord Community: https://discord.pravinmishra.com?utm_source=github&utm_medium=readme  
- 📝 Blog: https://dmi.pravinmishra.com/blog?utm_source=github&utm_medium=readme  
- ▶️ YouTube Playlist: https://www.youtube.com/playlist?list=PLFeSNDtI4Cho  
- 🔗 Pravin Mishra (LinkedIn): https://www.linkedin.com/in/pravin-mishra-aws-trainer/  
- 🏢 CloudAdvisory (LinkedIn): https://www.linkedin.com/company/thecloudadvisory/

---

*This submission is part of DevOps Micro Internship (DMI) — Agentic AI Track.*