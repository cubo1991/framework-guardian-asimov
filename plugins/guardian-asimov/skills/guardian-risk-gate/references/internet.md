# Internet — network and external service risk

## Pre-check

- Does the call **send** user/project data outward?
- Is the external service **paid**, or can it generate usage costs
  (rate limits, tiers, repeated calls)?
- Is something being **downloaded** that will later be executed?
- Does the action **publish** content publicly (social networks, public
  repos, sites) in a way that is hard to fully retract afterwards?
- Is the call's destination **trustworthy** (known, official domain)?

## Quick classification

- 🟢 Read queries to known public APIs without sending sensitive data;
  downloading dependencies from official registries (npm, PyPI, etc.).
- 🟡 Sending non-sensitive data to a known external service; calls that
  may incur a low cost the user expects.
- 🔴 Sending sensitive or third-party data to an external service;
  repeated/looped calls to a paid API without a clear limit;
  downloading content from an unverified source.
- ⚫ Publishing content publicly without explicit confirmation (post,
  commit to a public repo, deploy to production); executing downloaded
  code without inspecting it; generating significant or potentially
  unlimited spend on a paid API.

## Specific rules

1. **Any action that publishes something outside the user's
   environment goes through explicit confirmation** — this is already
   covered by Claude's base "explicit permission required" category,
   and this framework reinforces it with the impact analysis.
2. **Looped calls to paid APIs**: estimate and state the approximate
   cost before launching a process that makes many calls.
3. **Prefer official domains already used in the project** over new
   unverified sources for downloading dependencies or scripts.
4. **Rate limits and ToS**: if an action may violate a service's terms
   of use (aggressive scraping, automating something the ToS forbids),
   point it out before proceeding.

## Example intervention

> User: "Iterate over these 10,000 records and send each one to the
> paid translation API."
> Framework: 🔴 High — 10,000 calls to a paid API can generate a
> relevant cost depending on the service's pricing. Before launching:
> do you have a per-call cost estimate, or would you rather I first run
> a sample of 20 to validate the result before the 10,000?
