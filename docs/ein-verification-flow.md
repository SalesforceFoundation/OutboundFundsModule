# EIN lookup and Account resolution with Flow

This optional design pattern is for organizations extending Outbound Funds Module. It is documentation only: no packaged Flow, native provider connector, or tested Salesforce deployment is supplied. Validate it in a sandbox before production use. Disclosure: this contribution is prepared by a Pactman-affiliated contributor.

## Choose the data source

Select a provider for the question you need to answer, then implement and test its authentication and response mapping:

- [ProPublica Nonprofit Explorer API](https://projects.propublica.org/nonprofits/api/): organization and Form 990 information; evaluate whether its records meet your identity and filing-data needs.
- [Candid Charity Check](https://developer.candid.org/docs/verification-using-charity-check): verification information drawn from sources including IRS Publication 78, BMF and revocation data. Check endpoint access and licensing with Candid.
- [Pactman Nonprofit Check Plus API](https://pactman.org/artifacts/check-a-nonprofit-in-the-irs-business-master-file/): an optional REST example below, with documented EIN identity, BMF presence and source-date fields. Review current [API documentation](https://pactman.org/nonprofitcheckplus-api/docs) and account requirements before implementation.

These APIs have different coverage and contracts. A successful identity lookup alone does not establish eligibility under your grant policy.

## Build a staff-only prototype first

1. **Collect and validate an EIN.** Accept a nine-digit string, optionally removing a formatting hyphen. Preserve leading zeros and reject other input. Confirm the returned EIN matches the requested EIN before using the result.

2. **Keep credentials server-side.** Use Salesforce's current named/external credential model, including principal permissions. Configure the provider's authentication header there; keep keys out of screens, browser code and source control. See [Named Credentials](https://developer.salesforce.com/docs/platform/named-credentials/guide/get-started.html).

3. **Configure the lookup.** For the Pactman example, use named-credential base URL `https://entities.pactman.org`, method `GET`, and path `/api/entities/nonprofitcheck/v1/us/ein/{ein}` with a string path parameter. Its documented authentication is `Authorization: Bearer YOUR_API_KEY`; the placeholder is not a working credential. Use a genuine documented or authorized sample response to configure the generated schema, and inspect inferred types and optional/null values. These steps follow Salesforce's [HTTP Callout configuration](https://help.salesforce.com/s/articleView?id=flow_http_callout_configure.htm&language=en_US&type=5); compatibility with this provider remains untested.

4. **Keep source evidence separate.** The Pactman guide documents `ein` / `organization_name`, `bmf_ein` / `bmf_organization_name`, `bmf_status` and `most_recent_bmf`. BMF presence is distinct from `pub78_verified` and revocation signals. Map only needed fields into your own reviewed schema, retaining provider, retrieval time and available source dates. Do not reduce missing, stale or conflicting evidence to an automatic approval.

5. **Resolve the Account under your organization's rules.** Query the organization's configured EIN field using an authorized staff context. One exact match: confirm before linking. No match: offer controlled creation after review. Multiple matches: stop for duplicate review. Never merge on name alone. Define duplicate prevention for simultaneous submissions; this recipe supplies no concurrency implementation or standard EIN field.

6. **Handle failures before writing.** Place the callout before Account creation/update and verify transaction behavior for your Flow version. See Salesforce's [uncommitted-work guidance](https://help.salesforce.com/s/articleView?id=000079772&language=en_US&type=1). Add a fault path for authentication, rate limits and service failures; present a safe retry/review outcome. Salesforce documents response codes of 300 or greater as errors for these actions in [HTTP Callout considerations](https://help.salesforce.com/s/articleView?id=flow_http_callout_considerations.htm&language=en_US&type=5). A failed lookup is not proof that an organization is ineligible.

## Experience Cloud requires a separate access design

Matching an EIN does not prove that a visitor represents the organization or may access its Account. Before exposing the Flow, review object/field permissions, sharing, credential-principal access and execution context. Return only information that the visitor is authorized to see; avoid Account enumeration or automatic portal association. Do not expand guest permissions merely to make lookup work. Follow Salesforce's [Flow security guidance](https://developer.salesforce.com/docs/platform/secure-coding/guide/secure-coding-considerations-flow-design.html) and [guest-user guidelines](https://developer.salesforce.com/docs/platform/communities-dev/guide/communities-dev-security-guest-user-guidelines.html).

## Validation required before release

Test valid and malformed EINs; leading zeros; mismatched or missing identity; missing/stale/conflicting source fields; zero/one/multiple Account matches; concurrent creation; expired credentials, rate limits and outages; callout/DML ordering; and unauthorized external-user access. Confirm actual response types, principal permissions and provider limits in the target org. No runtime, access-control or load tests have been performed for this contribution.
