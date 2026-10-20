# Framework Guardian Asimov

A governance and risk-analysis layer for AI coding agents. It analyzes
every action with real-world effects before executing it, and decides
whether to proceed on its own, warn, or stop and ask for confirmation —
without slowing down normal work.

It ships as **one skill**, `guardian-risk-gate`, plus an optional Claude
Code hook. This repository is both **the marketplace** and **the
plugin**: it installs directly in Claude Code with `/plugin install`,
with no manual file copying.

## Quick install (per project)

From Claude Code, in the project where you want to use it — these are
**two separate commands**, each with its own Enter, not pasted together:

```
/plugin marketplace add cubo1991/framework-guardian-asimov
```

Wait for it to confirm the marketplace was added, and only then:

```
/plugin install guardian-asimov@guardian-asimov-marketplace
```

That's enough — the skill is available only in that project, and Claude
Code consults it when appropriate, based on its `description`.

## Global install (all your projects)

If you don't want to repeat the installation in every project, add
`--scope user` to the first command — the marketplace is then
registered at your user level, not tied to the folder where you ran it:

```
/plugin marketplace add cubo1991/framework-guardian-asimov --scope user
```

Type it in full on a single line (not inside the interactive "Add
Marketplace" box — that box only accepts the `owner/repo` source, with
no flags). When it confirms, install the plugin as before:

```
/plugin install guardian-asimov@guardian-asimov-marketplace
```

At `user` scope you don't need to repeat `marketplace add` in each new
project. To confirm it is global:

```
/plugin marketplace list --json
```

You should see `guardian-asimov-marketplace` not tied to a specific
project folder.

## Updating

Whenever new changes are pushed to the repo:

```
/plugin marketplace update guardian-asimov-marketplace
```

See `INSTALL.md` for full details, including the manual installation
option (no marketplace) for those who prefer copying files directly.

## What it is

An agent that can edit code, run shell commands, touch databases and
`git push` has a lot of power. Guardian Risk Gate is the layer that
asks itself, before every action with real consequences: *can this go
wrong, for whom, and how badly?* — and acts accordingly.

## Two layers: reasoning + technical enforcement

For most decisions, Guardian Risk Gate is a **skill** — behavioral
guidance the model interprets and follows. That works well in a normal
session, with you present to answer. But a skill is not a technical
control: in non-interactive mode (`-p`, no human available), a model can
decide to go ahead anyway.

So, for the closed list of "critical operations" (`rm -rf`,
`git push --force`, `DROP DATABASE`, etc.), the framework adds a second
layer: a **technical hook** (`scripts/guardian-gate.sh`, registered in
`hooks/hooks.json`) that Claude Code runs automatically before each
shell command, and that asks for confirmation through the permission
system when the command text matches one of its patterns — without
depending on the model cooperating. In unattended mode, with nobody to
confirm, the action is left unexecuted.

### What the hook does NOT do

It is a partial safety net, not a guarantee:

- It is regex over the command text, not a shell parser.
- It cannot see indirection: `eval`, variables, `python -c`, downloaded
  scripts.
- It does not cover the whole critical operations list (e.g.
  `find -delete`, `git checkout -- .`, `terraform destroy`,
  `kubectl delete`, touching `.env` or backups) nor actions done through
  other tools (MCP, file edits).
- It can flag harmless commands that merely mention a pattern (a commit
  message, a `grep`).
- Tested on Linux; Windows and macOS not verified.

The measured list of what it detects and what it doesn't is in
`plugins/guardian-asimov/skills/guardian-risk-gate/evals/hook-corpus.txt`
(run it with
`bash plugins/guardian-asimov/skills/guardian-risk-gate/evals/run-hook-corpus.sh`).

See `references/constitution.md` (section 0) for the detail of this
distinction.

## Repository structure

```
framework-guardian-asimov/              # marketplace root
├── .claude-plugin/
│   └── marketplace.json                # catalog — lists the plugin below
└── plugins/
    └── guardian-asimov/                # the plugin
        ├── .claude-plugin/plugin.json  # manifest
        ├── VERSION / CHANGELOG.md / DESIGN.md / ROADMAP.md / USAGE.md
        ├── hooks/hooks.json            # registers the PreToolUse hook
        └── skills/
            └── guardian-risk-gate/     # THE skill (self-contained folder)
                ├── SKILL.md            # decision process
                ├── references/         # per-domain checklists, profiles, constitution
                ├── scripts/            # optional hook + self-diagnosis
                └── evals/              # scenarios and hook corpus
```

It is a single skill: the process lives in `SKILL.md` and the
per-domain details are loaded on demand from `references/` (progressive
disclosure). See `plugins/guardian-asimov/DESIGN.md` for the full
reasoning behind this architecture.

## How this was built

This project was developed with the help of Claude (Anthropic's AI
assistant), with the author directing the work and reviewing the result.
Because AI-assisted work needs checking, the claims in this repository
are backed by tests you can rerun:

- `evals/hook-corpus.txt` + `evals/run-hook-corpus.sh`: a regression
  corpus for the hook that records what it detects, what it misses and
  where it raises false alarms. Nothing in it is executed; it only feeds
  command text to the hook.
- `scripts/guardian-doctor.sh`: checks that the hook can actually start
  in your environment (a hook that silently fails is worse than none).
- Headless end-to-end checks with `claude -p`, compared against a
  no-plugin baseline.
- Known limits are documented instead of hidden: see "What the hook does
  NOT do" above and the `LIMIT-FN` / `LIMIT-FP` categories in the corpus.

If you find a case the framework mishandles, please open an issue with
the command and the expected behavior.

## Usage

See `plugins/guardian-asimov/USAGE.md` for real examples of how the
framework intervenes in different scenarios.

## Philosophy in one sentence

Always choose the least risky alternative that still achieves the goal,
warning when appropriate and stopping only when the risk warrants it —
never by default, never silently.
