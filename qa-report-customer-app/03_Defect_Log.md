# Defect Log (source review; runtime verification NOT RUN)

No defect below has screenshot evidence because the app could not be launched. Findings are code/spec inspection results and must not be represented as executed UI results.

| ID | Severity | Finding | Evidence / reproduction state |
|---|---|---|---|
| DEF-01 | S1 | Invoice values and order identity are hardcoded and disconnected from current cart | `tax_invoice.dart` literals; requested Glycomet flow NOT RUN |
| DEF-02 | S2 | Login permits any non-empty phone string to OTP route; empty value returns silently | `login.dart`; UI reproduction NOT RUN |
| DEF-03 | S2 | Cart has no persisted storage and resets with app process | `CartNotifier` in-memory map; restart reproduction NOT RUN |
| DEF-04 | S3 | Legacy widget test brand assertion is stale | Existing draft reports `test/widget_test.dart`; test not rerun |
| DEF-05 | S2 | Mock catalog has five items and lacks broad stock/tax variants | `mock_medicines.dart`; source review |
| DEF-06 | S2 | Order review labels arbitrary amount delta as subsidy | `order_review.dart`; source review |
| DEF-07 | S2 | Cart delivery and handling display literal FREE | `cart.dart`; source review; fee policy unconfirmed |
| DEF-08 | S2 | No IGST presentation identified; only GST-included and CGST/SGST invoice labels appear | `cart.dart`, `tax_invoice.dart`; source review |
| DEF-09 | S2 | No COD limit/eligibility logic identified in UI | `payment.dart`; backend/policy unconfirmed |
| DEF-10 | S1 | Cart stock revalidation is non-reactive; an already-added item has no inventory recheck path | `CartNotifier` stores only local quantities; EC-01 **FAIL** (not MOCKED-OK) |
| DEF-11 | S2 | No dedicated last-unit out-of-stock race dialog identified | `sourcing_solution_card.dart` provides sourcing view; EC-02 **FAIL** |
| DEF-12 | S2 | Dedicated CANCELLED and REJECTED order result screens are missing | Inventory and routes show no distinct order terminal-state screens; NOT RUN |
| DEF-13 | S2 | Order IDs and handover code are fixed mock values | `order_review.dart`, `order_placed.dart`, `live_tracking.dart`, `doorstep_verification.dart`; runtime NOT RUN |
| DEF-14 | S1 | Pharmacy visibility/selection specification conflict (CONF-01) leaks store brands in some UI while platform allocation is also modeled | `10_Spec_Conflicts_and_Assumptions.md`; resolve product specification before integration |
| DEF-15 | S3 | Invoice share/PDF icon controls have empty callbacks | `tax_invoice.dart`; classify DEAD-UI by source, runtime tap NOT RUN |
| DEF-16 | S2 | 200% text scale, responsive widths, dark appearance and offline states are unverified | No runtime evidence available |

## Edge cases: corrected status

- **EC-01: FAIL.** State trigger in source is absent: there is no inventory event or cart revalidation call when availability changes. The existing catalog no-stock card does not prove reactive cart behavior.
- **EC-02: FAIL.** No last-unit race trigger or dedicated dialog exists in the reviewed flow. A sourcing suggestion screen is not equivalent behavior.
- **EC-03–EC-18: NOT RUN.** The previous draft called screen existence a PASS. A state screen is not proof its triggering behavior works; every case needs a real trigger and runtime recording. In particular cancelled/rejected order screens are missing, and payment/order state transitions remain mock UI paths.

Severity scale: S1 blocks core financial/order correctness or creates material trust risk; S2 major functional gap; S3 minor usability/dead control; S4 cosmetic.
