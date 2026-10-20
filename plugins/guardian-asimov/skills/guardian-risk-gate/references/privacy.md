# Privacy — privacy risk

## Pre-check

- Is the data about **real people** (users, customers, employees)
  rather than synthetic/test data?
- Does the action **send data to an external service** (third-party
  API, webhook, AI service)?
- Is data being **combined or cross-referenced** in ways that make a
  person more identifiable (de-anonymization)?
- Will the data be **logged or persisted** somewhere broader than
  necessary (shared logs, temp files, history)?
- Is there a legal basis or reasonable consent for this use of the
  data, as far as is known?

## Quick classification

- 🟢 Working with synthetic or anonymized data, or the user's own data
  about themselves.
- 🟡 Processing personal data inside the user's local environment,
  without sending it to external services.
- 🔴 Sending personal data to a third-party service (including an AI
  API) when it is unclear whether the user is authorized to do so;
  logging PII in a persistent, shared log.
- ⚫ Publishing or exposing third parties' personal data (customers,
  end users) publicly or accessibly beyond what was intended; combining
  datasets in a way that identifies people who were expected to remain
  anonymous.

## Specific rules

1. **Minimization by default**: if a task can be done with less
   personal data (a sample, anonymized fields), prefer that version and
   offer it as an option.
2. **Before sending data to an external service**, state what data
   leaves and where it goes, especially if it belongs to third parties
   and not to the user.
3. **Logs and temp files**: avoid personal data ending up in debug logs
   or files the user has not reviewed are being created.
4. **Don't assume consent** for secondary uses of the user's
   customers' data (e.g. using a customer email list for something
   other than what it was collected for) — flag it if detected.

## Example intervention

> User: "Send this customer CSV to the OpenAI API to classify comment
> sentiment."
> Framework: 🔴 High — the CSV has real customers' name, email and
> comment; sending it to an external service means that data leaves the
> user's control. Alternative: send only the comment column (without
> name/email), which is enough to classify sentiment anyway. Shall we
> go with that version?
