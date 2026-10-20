# Security — security risk

## Pre-check

- Can the action **print, log or display** the contents of a `.env`, a
  key file, a token, or a variable holding secrets?
- Is a file that might contain secrets about to be **committed**?
- Is a **new dependency** being added? From a trustworthy source?
- Is something about **authentication, authorization or access
  control** being modified (permissions, roles, CORS, input
  validation)?
- Does the action **reduce** an existing protection (disabling a
  validation, lowering a security logging level, opening a port)?

## Quick classification

- 🟢 Reading security code to understand/explain it without exposing
  real values; adding a very well-known dependency already used in the
  project.
- 🟡 Adding a new dependency not previously used in the project;
  changing input validation in a way that hardens it.
- 🔴 Modifying authentication/authorization logic; weakening an
  existing validation; logging potentially sensitive data (even if it
  is not a "hard" secret).
- ⚫ Printing or committing a real secret (token, API key, password,
  private key); disabling a security protection without a replacement;
  exposing a `.env` or credentials file.

## Specific rules

1. **Never print the full contents of a file that may hold secrets**
   (`.env`, `*.pem`, `credentials.json`, etc.) — if you need to check
   that it exists or has the expected format, show only the
   keys/variable names, never the values.
2. **Before a commit, check for secrets** in the added files (patterns
   like `API_KEY=`, `-----BEGIN PRIVATE KEY-----`, long tokens). If
   something like that appears, warn and suggest `.gitignore` /
   environment variables instead of committing.
3. **New dependencies**: briefly mention if they are poorly maintained,
   very new, or have known vulnerabilities if that information is
   available; there is no need to audit in depth every time, but a
   quick sanity check is warranted.
4. **Never weaken a protection "to make it work more easily"** (for
   example, disabling TLS certificate verification, lowering an
   endpoint's permissions) without explaining the trade-off and
   confirming.
5. **Principle of least privilege**: when the user asks to grant access
   or permissions, suggest the minimum necessary unless they
   explicitly ask for more.

## Example intervention

> User: "Show me the `.env` so I can check the variable is set right."
> Framework: 🟡 Medium — instead of showing the whole file (it may
> contain other sensitive keys), I'll show you only the name of that
> specific variable and whether it has a value assigned, without
> printing the value. Does that work, or do you need to see the real
> value?
