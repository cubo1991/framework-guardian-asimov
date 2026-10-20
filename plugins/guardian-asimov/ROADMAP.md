# ROADMAP.md — proposed future improvements

Ideas for future versions, without compromising the core philosophy.

## Short term

- **Pure PowerShell port of `guardian-gate`** (partially covered since
  v1.3.0 via Git Bash): a native `.ps1` for Windows without Git Bash —
  see the known limitation in
  `skills/guardian-risk-gate/scripts/README.md`.
- **`dependencies` reference**: specific checklist for adding/updating
  packages (today split between `security` and `legal`) — package
  maintenance, popularity, known vulnerabilities, major-version breaking
  changes.
- **`infra` reference**: split infrastructure-as-code specifics
  (Terraform, Docker, CI/CD) out of `shell`/`internet` — risks such as
  destroying cloud resources or changing deploy pipelines.
- **Ready-to-paste `CLAUDE.md` template** with the framework section
  already written, to lower installation friction.

## Medium term

- **Extend the hook to non-shell vectors**: today `guardian-gate.sh`
  only covers `Bash`/`PowerShell`. A critical operation done through an
  MCP server (e.g. a tool that runs SQL directly) does not go through
  this hook yet — only through the reasoning layer
  (`references/database.md`).
- **Per-project vs. per-session profile**: let the active profile be
  declared persistently per project, and also overridden for the current
  session only.
- **Make `evals/scenarios/` an executable suite** (today they are
  documented markdown cases for manual review / subagent review) — run
  them automatically against a new framework version before adopting it,
  to detect regressions in judgment.
- **`decision-log.md` rotation**: if the file grows a lot over time,
  define a per-month/quarter file convention instead of a single
  indefinite file.

## Long term

- **Explicit confidence scale**: today the "confidence of the
  assessment" is part of the internal reasoning; it could be made
  explicit as a fourth axis reported to the user ("I'm assessing this
  with medium confidence because I have no visibility into X").
- **Extension to other risk domains** that may emerge over time (e.g.
  generative AI inside the project itself, content produced for end
  users, accessibility risks) if they appear as a recurring need.
- **Retrospective audit mode**: run the framework not before acting but
  over a history of actions already taken (e.g. a range of commits), to
  flag retroactively which operations should have gone through
  confirmation and did not.

## Principle for evaluating any future proposal

Every extension must be explainable in one sentence pointing to one of
the principles in `references/constitution.md`. If a proposed
improvement neither reduces real risk nor improves
transparency/reversibility, it probably does not belong in this
framework but elsewhere in the project.
