# Edge Case Coverage

All previous PASS labels based only on a screen existing are withdrawn. Runtime launch was blocked; cases below are source review findings or NOT RUN.

| ID | Scenario | How state is triggered | Result / status |
|---|---|---|---|
| EC-01 | Stock falls after adding to cart | No inventory event/test hook or revalidation path found after `CartNotifier.add` | **FAIL** — cart is in-memory quantity only; no reactive revalidation |
| EC-02 | Two customers contend for last unit | No concurrency/state trigger or dedicated dialog found | **FAIL** — last-unit dialog missing |
| EC-03 | Payment succeeds, order creation times out | `PaymentStatusRecovery` screen exists; no runtime/mock trigger executed | NOT RUN |
| EC-04 | Payment fails after stock reservation | Decline screen exists; no reservation or trigger executed | NOT RUN |
| EC-05 | Pharmacy rejects after payment | Rejection/fulfillment screens exist; no order lifecycle trigger executed | NOT RUN |
| EC-06 | Prescription rejected after payment | Rejection screen exists; trigger NOT RUN | NOT RUN |
| EC-07 | Cancel after pharmacy acceptance | Order-history cancel control/stage gate not verified at runtime | NOT RUN |
| EC-08 | Driver rejects assignment | Tracking screen content is mock; no assignment event triggered | NOT RUN |
| EC-09 | Delivery fails, customer unavailable | Delivery issue UI exists in source; no failure event triggered | NOT RUN |
| EC-10 | Pharmacy closes while pending | Address/store allocation screens exist; no closure/reallocation event triggered | NOT RUN |
| EC-11 | Item expired during fulfillment | Fulfillment exception copy exists; no expiry event triggered | NOT RUN |
| EC-12 | Duplicate gateway callback | No gateway callback harness executed; navigation replacement alone is insufficient proof | NOT RUN |
| EC-13 | Notification provider unavailable | No provider failure injected; UI scaffold does not prove fallback behavior | NOT RUN |
| EC-14 | Duplicate order action | No rapid-tap runtime test or idempotency/server trigger executed | NOT RUN |
| EC-15 | Multi-pharmacy partial fulfillment | Split-shipment screen exists; no real split state generated | NOT RUN |
| EC-16 | In-flight address change | Address-change UI exists; PIN/route recalculation not run | NOT RUN |
| EC-17 | Handover verification | Fixed code 8492 is displayed in source; no delivery code validation trigger run | NOT RUN; code is hardcoded |
| EC-18 | Prescription clarification | Clarification screen exists; no pharmacist state trigger executed | NOT RUN |

Also not run: payment retry/pending/decline state triggers, coupon boundary behavior, file-picker denial/type/size checks, offline launch and recovery, or 360/430/200%/dark-mode passes. See `02_Test_Cases.csv` and `00_Environment_and_Inventory.md`.
