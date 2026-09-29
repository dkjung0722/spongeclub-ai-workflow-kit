---
name: skill-curator
description: Create, edit, review, deduplicate, deploy, and synchronize user skills managed by Skills Manager. Use when a user asks to create or modify a SKILL.md, add a skill, manage skill locations, publish a skill change, or keep Claude and Codex skill copies in sync.
---

# Skill Curator

Use Skills Manager as the source of truth for user-managed skills. Do not treat the
Claude, Codex, Orca-account, or `.agents/skills` deployment folders as independent
Git repositories.

## Source of truth and deployment model

The canonical library is the Skills Manager library, normally:

```text
Windows: %USERPROFILE%\.skills-manager\skills\<skill-name>
macOS/Linux: ~/.skills-manager/skills/<skill-name>
```

The Skills Manager Git remote is the user's configured `agent-skills` repository.
The manager owns the commit and push flow. Agent-specific folders are deployment
targets, not places to edit first.

```text
Skills Manager library
        ↓ manager git commit / git push
GitHub agent-skills repository
        ↓ skills sync
Claude / Codex / other enabled agents
```

If a skill is found only in an agent folder, inspect it first. Adopt it with
`skills adopt` only when it is genuinely a user skill and the user wants it managed.
Never silently overwrite an existing library skill with an agent-folder copy.

## Resolve and inspect the manager

Resolve the CLI once for the task. Prefer a command already on `PATH`; otherwise use
the platform path above:

```text
Windows: %USERPROFILE%\.skills-manager\bin\skills-manager-cli.exe
macOS/Linux: ~/.skills-manager/bin/skills-manager-cli
```

Use JSON output when available. At the beginning of a create, edit, or publish task:

```text
skills-manager-cli git status --json
skills-manager-cli agents list --json
```

If the manager reports uncommitted changes outside the requested skill, do not discard
or include them. Summarize the unrelated changes and stop before committing.
If it reports an ahead/behind state, pull or ask the user to resolve the divergence
before publishing. Never force-push and never rewrite remote history.

## Create or edit a skill

When the user asks to create, modify, or add a skill:

1. Identify the exact skill name and intended scope.
2. Inspect the existing library version and all same-name deployments.
3. Edit only the library path under the Skills Manager root.
4. Keep `SKILL.md` self-contained, concise, and specific about when it applies.
5. Preserve unrelated files and existing user changes.
6. Check for duplicate names, overlapping triggers, secrets, machine-specific paths,
   and instructions that would cause destructive or unapproved actions.

Every skill must have valid frontmatter with `name` and `description`. If scripts or
references are added, keep them inside the skill directory and explain their routing
from `SKILL.md`.

## Validate before publishing

Before committing, inspect the diff and run the manager's checks:

```text
skills-manager-cli skills check --all --json
skills-manager-cli git status --json
```

Also verify that the changed skill is discoverable and that its target deployments
are not stale. Report the changed files, validation result, and any unresolved risk.

## Automatic commit, push, and deployment

For a user-requested skill create or edit, publish the validated change automatically
unless the user explicitly says not to publish it. Use Skills Manager's Git commands,
not raw `git` commands in the deployment folders:

```text
skills-manager-cli git commit --message "skills: <short description>" --json
skills-manager-cli git push --json
skills-manager-cli skills sync --dry-run --json
skills-manager-cli skills sync --json
```

Do not claim success until the commit and push commands both succeed and the final
status is clean or contains only pre-existing unrelated changes. Include the commit,
push result, synced tools, and any skipped targets in the completion report.

If commit or push fails because of authentication, remote divergence, permissions,
or a network problem, keep the local validated change intact, report the exact
failure, and do not retry destructively. Do not request or handle passwords, tokens,
cookies, or authentication codes in chat.

## Agent-folder recovery

If the user edited a deployed copy directly:

1. Compare it with the library copy.
2. Show the diff and identify whether it is a new skill or an edit to an existing one.
3. If the user confirms it should become managed, use `skills adopt <path>` (with a
   Git source only when the source repository and subpath are known).
4. Re-run validation, then use the normal manager commit/push/sync flow.

Do not create junctions, overwrite deployments, or delete duplicates merely because
names match. Inspect content and source ownership first.

## Completion report

Report:

```text
작업한 스킬:
변경 파일:
검증 결과:
커밋:
푸시:
배포/동기화 대상:
건너뛴 대상:
남은 위험 또는 사용자 조치:
```

The goal is one reviewed library copy, one GitHub history, and consistent deployments
to the enabled agents—not several silently diverging skill copies.
