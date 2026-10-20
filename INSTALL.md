# Installation

## Requirement: `jq`

Since v1.3.0 the framework includes a technical hook
(`hooks/hooks.json` + `scripts/guardian-gate.sh`) that needs `bash` and
`jq` in the environment where Claude Code runs. If you don't have it:

```bash
# macOS
brew install jq
# Debian/Ubuntu
sudo apt install jq
# Windows (with Chocolatey)
choco install jq
```

If `jq` is not installed, the hook (since v1.3.1) asks for confirmation
on **every** shell command, so nothing slips through silently. After
installing, check that the hook starts:

```bash
bash plugins/guardian-asimov/skills/guardian-risk-gate/scripts/guardian-doctor.sh
```

(If you installed via the marketplace, the plugin lives under
`~/.claude/plugins/`; run the same script from that path.) More detail in
`plugins/guardian-asimov/skills/guardian-risk-gate/scripts/README.md`.

## Option A — Install as a plugin (recommended)

From inside Claude Code, in any project where you want to use it:

```
/plugin marketplace add <your-user>/framework-guardian-asimov
/plugin install guardian-asimov@guardian-asimov-marketplace
```

If the install summary says `Run /reload-plugins to activate.`, run
that command. Done — the skill is available in that project (or for
your user, depending on the `--scope` you use) and Claude Code consults
it automatically when the task matches its `description`.

### Updating to a new version

Whenever you push changes to the repo:

```
/plugin marketplace update guardian-asimov-marketplace
```

### Install for your whole user instead of a single project

Type the **full command, on a single line**, in the Claude Code prompt
(not inside the interactive "Add Marketplace" box that appears when you
type just `/plugin marketplace add` — that box only expects the
`owner/repo` source, with no flags or a second pasted command):

```
/plugin marketplace add <your-user>/framework-guardian-asimov --scope user
```

Wait for the confirmation, and only then, with its own Enter:

```
/plugin install guardian-asimov@guardian-asimov-marketplace
```

With `--scope user` it is available in all your Claude Code projects,
not just the current one — no need to repeat `marketplace add` each time
you open a new project. To confirm:

```
/plugin marketplace list --json
```

### Have your team get it automatically

If you work with other people on the same project repo (not the
framework's repo, but the project where you use it), add this to the
project's `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "guardian-asimov-marketplace": {
      "source": {
        "source": "github",
        "repo": "<your-user>/framework-guardian-asimov"
      }
    }
  },
  "enabledPlugins": {
    "guardian-asimov@guardian-asimov-marketplace": true
  }
}
```

That way, anyone who opens that project with Claude Code gets the
framework enabled automatically, with nothing installed by hand.

## Option B — Manual installation (no marketplace)

If you prefer not to use GitHub or the plugin mechanism, you can copy
the skill folder by hand:

```bash
git clone https://github.com/<your-user>/framework-guardian-asimov.git
cp -r framework-guardian-asimov/plugins/guardian-asimov/skills/guardian-risk-gate .claude/skills/
```

With this option the skill works, but the technical hook is not
registered (that is done by the plugin's `hooks/hooks.json`), and there
is no auto-update — each update requires cloning and copying again.

## Verify it is active

Ask Claude Code for something slightly risky but not destructive, for
example: *"Delete the `dist/` folder."* — it should briefly flag the
risk (🟡/🔴 depending on the project state) instead of deleting without
saying anything. If none of that happens:

- Confirm the plugin is installed: `/plugin list` (or check
  `.claude/settings.json` if you used Option B).
- Run `claude plugin validate .` from the framework repo root to check
  that `marketplace.json` and `plugin.json` are well formed.

To verify **the technical enforcement layer** specifically (the hook,
not just the skill), run `/hooks` inside Claude Code — it should list a
`PreToolUse` with matcher `Bash|PowerShell` coming from "Plugin Hooks".
As a real test, ask for something like *"delete this folder with
`rm -rf`"* on a test folder: a real permission request should appear
(not just text), even if the model at some point tried to skip it.

## Uninstall / remove the marketplace

```
/plugin marketplace remove guardian-asimov-marketplace
```

This also uninstalls the plugin. To just refresh without losing the
installation, use `update` instead of `remove`.
