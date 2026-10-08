---
name: setup-repo-checks
description: Set up the two standing maintenance routines for a GitHub repo - a Honeybadger production-error fixer and a Dependabot stuck-PR fixer. Use when the user runs /setup-repo-checks <owner/repo> or asks to set up error and dependency checks for a repo.
argument-hint: <owner/repo>
---

# Set up repo checks

Creates two scheduled routines for the repo named in the arguments (`owner/repo`; if only a
name is given, resolve the owner with `list_repos`). Both routines fire into a fresh session,
so each prompt must stand alone.

## 1. Gather inputs

Ask the user (AskUserQuestion) only for what you can't determine yourself:

- `REPO` - owner/repo from the arguments.
- `HB_PROJECT_ID` - the Honeybadger project ID. Never guess it. Never ask for or accept a token in chat.
- `ENVIRONMENT` - default `production`.
- Whether the repo is a Rails app (default commands below assume it). Otherwise read the
  repo's CLAUDE.md or README for the test and lint commands and substitute them for
  `TEST_CMD` and `LINT_CMD`. Rails defaults: `bundle exec rspec` and `bundle exec rubocop`.
- `PROTECTED_DEPS` - dependencies that never auto-merge. Default: Ruby, Rails, Postgres, Devise, ActiveAdmin, Shrine.

## 2. Check prerequisites and report gaps

Do not block on them; list what's missing so the user can fix it:

- Environment secret `HONEYBADGER_API_TOKEN` (Data API token) exists. Check with `[ -n "$HONEYBADGER_API_TOKEN" ]` and report only set or unset, never print it.
- The environment's network policy allows `app.honeybadger.io` (and `api.honeybadger.io` if used).
- The repo has "Allow auto-merge" enabled and a branch protection rule on the default branch
  that requires CI. Without the rule, auto-merge merges immediately instead of waiting for CI.
- The repo is reachable (`add_repo` succeeds).

## 3. Create the two routines

Use `create_trigger` with `initiation: human_request` and `create_new_session_on_fire: true`
for both. Substitute the placeholders in the prompts below. Use these schedules (local time
America/Los_Angeles unless the user says otherwise), and shift the minutes for each additional repo so
runs don't all start together:

- Errors routine: daily, `CRON_TZ=America/Los_Angeles 47 7 * * *`
- Dependency routine: weekdays, `CRON_TZ=America/Los_Angeles 13 9 * * 1-5`

If `create_trigger` is denied by the permission classifier, STOP. Do not try another way
around it. Tell the user the denial reason and that they need to add a permission rule for
`mcp__claude-code-remote__create_trigger`, then offer to retry.

After creating, call `list_triggers` to confirm both exist, and give the user a short summary:
names, schedules, and the list of unmet prerequisites. Tell them they can fire either
routine on demand ("play") and may add text such as "focus on fault 123456" or "focus on PR #42".

### Routine 1 name: `<REPO> errors (Honeybadger)`

Prompt:

```
First attach the repo with add_repo (owner/repo: <REPO>) and clone it, then register it. Read its CLAUDE.md and follow it (TDD with specs, commit style, lint before finishing).

Config:
- Honeybadger project ID: <HB_PROJECT_ID>
- Environment: <ENVIRONMENT>
- Auth: env var HONEYBADGER_API_TOKEN (Data API token, HTTP Basic: token as username, empty password)
- API base: https://app.honeybadger.io/v2 (confirm endpoints against https://docs.honeybadger.io/api/ before the first call)

The user has explicitly authorized you to fix production errors, open PRs, and enable auto-merge without asking. Honeybadger is the source of truth for what has been handled. If the token is missing or the host is unreachable, stop and report exactly that; do not guess.

If the user's message names a specific fault, handle only that one.

Each run:
1. Housekeeping: for faults with an open fix PR on a branch named hb/<fault-id>-*, check the PR. If it merged, resolve the fault in Honeybadger. If it closed unmerged or auto-merge failed, note it in your summary. Never resolve a fault whose PR hasn't merged.
2. List unresolved, un-ignored faults for the project in the environment above. Skip any that already have an open PR. For each remaining fault, fetch its latest notice (backtrace, request params, context) and triage:
   - Bot/scanner noise (malformed Accept headers, path-traversal probes, junk params): fix once generally (return a 4xx instead of a 500) with a request spec. No one-off fixes per probe. Ignore the fault in Honeybadger only after that fix merges.
   - Real bug: write a failing spec that reproduces it, make the minimal fix, make it pass.
   - Unclear, risky, or needing a product decision: leave it unresolved, comment on the fault with why, and list it in your summary.
3. For each fix: branch hb/<fault-id>-<slug> from the latest default branch. Run <TEST_CMD> (relevant specs at least) and <LINT_CMD>. Commit, push, open a PR (use the repo's PR template if there is one; link the Honeybadger fault), and enable auto-merge (squash). If CI fails, diagnose and push fixes. Never skip, disable, or quarantine a test.
4. Don't resolve at PR time. Step 1 of the next run does it after merge. A recurrence reopens the fault automatically.
5. Finish with a short summary: PRs opened (links), faults resolved, faults left for the user and why. If nothing was unresolved, say so in one line.
```

### Routine 2 name: `<REPO> dependency PRs`

Prompt:

```
First attach the repo with add_repo (owner/repo: <REPO>) and clone it, then register it. Read its CLAUDE.md and follow it (TDD with specs, commit style, lint before finishing).

The user has explicitly authorized you to fix stuck dependency PRs, push to their branches, and enable auto-merge on safe ones without asking. GitHub is the source of truth.

If the user's message names a specific PR, handle only that one.

List open PRs authored by dependabot[bot]. For each, look at merge state, CI on the latest commit, and how long it has sat. Handle by case:
1. Merge conflict or out of date: comment `@dependabot rebase`. Don't merge the base in by hand. If it is still conflicted on the next run, say so in your summary.
2. CI red: reproduce the failure and find the root cause. Push a fix onto the Dependabot branch (a deprecation, changed API, lockfile adjustment, an updated spec). Run <TEST_CMD> and <LINT_CMD> first. If the dependency itself is broken or the fix isn't clear, comment on the PR with the evidence and list it in your summary. Never skip, disable, or quarantine a test. A red check that is also red on the default branch is not this PR's fault: say so in one comment and leave it.
3. CI green:
   - Patch and minor bumps: enable auto-merge (squash).
   - Major bumps, and anything touching <PROTECTED_DEPS>: do not enable auto-merge. Get it green, skim the changelog for breaking changes, and put it in your summary for the user to approve.
4. Stuck means: red CI, a conflict, or open for more than 7 days with no activity. Treat any of those as work now.
5. After pushing a fix to a Dependabot branch, note in the PR that you did so, since Dependabot may overwrite the branch on rebase.

Finish with a short summary: PRs fixed, auto-merged, or waiting on the user and why. If nothing needed doing, say so in one line.
```

## Rules

- Never print, request, or store tokens or secret values.
- Don't create duplicate routines: run `list_triggers` first and, if routines with the same names exist, update them with `update_trigger` instead.
- Do not open PRs, push, or change repo settings during setup; this skill only creates routines and reports gaps.
