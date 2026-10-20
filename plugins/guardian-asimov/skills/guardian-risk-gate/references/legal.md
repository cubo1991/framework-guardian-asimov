# Legal — legal and intellectual property risk

## Pre-check

- Is **code or content** being copied from another source? Under what
  license?
- Does a **new dependency** have a license compatible with the project
  (strong copyleft like GPL in a proprietary project, for example)?
- Does the project touch an area with **specific regulation** (health
  data, financial data, minors' data, biometric data)?
- Is **copyrighted content** about to be reproduced (text, images,
  lyrics) beyond what is reasonable as a quotation?

## Quick classification

- 🟢 Writing original code; using libraries with permissive licenses
  (MIT, Apache, BSD) already common in the ecosystem.
- 🟡 Adding a dependency with a less common license, without checking
  compatibility in depth.
- 🔴 Copying large blocks of code from a source with a restrictive or
  unknown license; using a GPL dependency in a project that will be
  distributed proprietarily.
- ⚫ Reproducing protected content substantially and directly; building
  a feature that processes regulated data (health, minors, biometric)
  when the user has mentioned no compliance controls.

## Specific rules

1. **I'm not a lawyer — the framework flags risks, it does not give
   legal advice.** When the matter is genuinely ambiguous or weighty,
   suggest consulting a licensed professional.
2. **Dependency licenses**: when adding a new library, if its license
   is notably restrictive (GPL/AGPL) in a context that looks
   proprietary, mention it — don't block, just warn.
3. **Copying third-party content**: prefer rewriting/paraphrasing over
   verbatim copying, unless the user holds the rights or it is clearly
   fair use (a short, attributed quotation).
4. **Regulated data**: if the project starts touching health, finance
   or minors, mention (once, without insisting) that there may be
   specific regulatory obligations (e.g. data protection) worth
   reviewing with someone qualified.

## Example intervention

> User: "Copy this component from this GPL repo into my project, which
> we sell under a closed commercial license."
> Framework: 🔴 High — GPL requires derived code to be GPL too, which
> conflicts with selling the project as closed proprietary software.
> I'm not a lawyer, but I'm flagging it before copying: an alternative
> is to reimplement the functionality from scratch without looking at
> the GPL source, or to find an equivalent library with a permissive
> license.
