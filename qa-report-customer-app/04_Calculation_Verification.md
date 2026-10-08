# Calculation & Pricing Verification

## Rule status

**Q76 is unconfirmed:** both the customer-facing rounding rule and whether listed prices are tax-inclusive are unconfirmed. This report does not mark the app FAIL against an invented pricing rule. The two candidate models are:

1. **Tax-inclusive candidate:** `taxable = price / (1 + rate)`; `GST = price - taxable`; gross remains the listed price, with any final display rounding still unspecified.
2. **Tax-exclusive candidate:** `taxable = price`; `GST = price × rate`; gross is taxable + GST, with any final display rounding still unspecified.

Calculations below use candidate 1 solely to correct the prior report's arithmetic, and assume cart-level values are presented to paise. They are arithmetic checks, not a confirmed business rule. For mixed-rate baskets the formula is applied per line and then summed.

## Recomputed carts

| Cart | Inputs and formula | Taxable (₹) | GST (₹) | Gross (₹) | Render comparison / status |
|---|---|---:|---:|---:|---|
| CART-01 | ₹925 @12%: 925/1.12; 925−825.89 | 825.89 | 99.11 | 925.00 | Cart calculation only; runtime NOT RUN |
| CART-02 | ₹485 @12%: 485/1.12; 485−433.04 | 433.04 | 51.96 | 485.00 | Cart calculation only; runtime NOT RUN |
| CART-03 | ₹24.50 @12%: 24.50/1.12; 24.50−21.88 | 21.88 | 2.62 | 24.50 | Candidate 1 gross is ₹24.50; prior ₹25 rounding assertion withdrawn; runtime NOT RUN |
| CART-04 | ₹1,240 @12%: 1240/1.12; 1240−1107.14 | 1,107.14 | 132.86 | 1,240.00 | Runtime NOT RUN |
| CART-05 | Janumet: 485/1.12=433.04, GST 51.96; Glucerna: 680/1.18=576.27, GST 103.73; sum | **1,009.31** | **155.69** | 1,165.00 | Corrected prior taxable/GST (previously miscomputed); runtime NOT RUN |
| CART-06 | ₹485 @12%: 485/1.12; 485−433.04; then assumed ₹50 coupon | 433.04 | 51.96 | 485.00 before coupon | Net payable depends on confirmed coupon/tax allocation; runtime NOT RUN |
| CART-07 | ₹24.50 @12%: 24.50/1.12; 24.50−21.88 | 21.88 | 2.62 | 24.50 before coupon | Clamp-to-zero policy unconfirmed; runtime NOT RUN |
| CART-08 | ₹4,850 @12%: 4850/1.12; 4850−4330.36 | 4,330.36 | 519.64 | 4,850.00 | Runtime NOT RUN |
| CART-09 | ₹485 @12%: 485/1.12; 485−433.04; delivery is shown FREE in UI | 433.04 | 51.96 | 485.00 before fees | **HARDCODED** delivery/handling labels; fee policy unconfirmed; runtime NOT RUN |
| CART-10 | ₹1,507 @12%: 1507/1.12; 1507−1345.54 | **1,345.54** | **161.46** | 1,507.00 | Corrected; order review/payment labels use fixed subsidy assumptions; those screen values are **HARDCODED**, not MATCH |
| CART-11 | Invoice fixed gross ₹1,507 @12% candidate: 1507/1.12; 1507−1345.54 | 1,345.54 | 161.46 | 1,507.00 | Invoice fixed values are **HARDCODED**, not MATCH to a dynamic cart |
| CART-12 | ₹485 @12%; intra-state candidate split 6%+6% on taxable | 433.04 | 25.98 + 25.98 | 485.00 | Split arithmetic only; UI runtime NOT RUN |
| CART-13 | ₹485 @12%; inter-state candidate total IGST = 485−433.04 | 433.04 | IGST 51.96 | 485.00 | **No IGST display state identified**; runtime NOT RUN |
| CART-14 | ₹50 @0%: 50/1.00; 50−50 | 50.00 | 0.00 | 50.00 | Tax slab not represented in mock catalog; NOT RUN |
| CART-15 | ₹1,000 @5%: 1000/1.05; 1000−952.38 | 952.38 | 47.62 | 1,000.00 | Tax slab not represented in mock catalog; NOT RUN |
| CART-16 | ₹50@0: 50/1; ₹1,000@5: 1000/1.05; ₹485@12: 485/1.12; ₹680@18: 680/1.18; sum | **2,011.69** | **203.31** | 2,215.00 | Corrected prior taxable/GST (prior report summed gross as taxable incorrectly); runtime NOT RUN |
| CART-17 | ₹4,999 @12%: 4999/1.12; 4999−4463.39 | 4,463.39 | 535.61 | 4,999.00 | **No COD limit logic identified**; threshold policy unconfirmed; NOT RUN |
| CART-18 | ₹99.99 @12%: 99.99/1.12; 99.99−89.28 | 89.28 | 10.71 | 99.99 | Paise arithmetic only; final rounding rule unconfirmed; NOT RUN |
| CART-19 | Fixed ₹1,507 @12% candidate: 1507/1.12; 1507−1345.54 | 1,345.54 | 161.46 | 1,507.00 | Prior shortage refund retained/refund values lack runtime evidence; NOT RUN |
| CART-20 | Fixed ₹1,507 @12% candidate: 1507/1.12; 1507−1345.54 | 1,345.54 | 161.46 | 1,507.00 | Address-change amount lacks runtime evidence; NOT RUN |

## Rendered screen comparison

| Screen | Observed from source | Classification |
|---|---|---|
| Cart | Item totals and grand total read `CartNotifier`; delivery and handling are literal `FREE`; GST is labeled included | Dynamic item subtotal; fees **HARDCODED**; no tax breakdown. Runtime NOT RUN |
| Checkout / payment | Reads cart total, while “Rx subsidy” ₹161 and payable presentation are fixed assumptions | **HARDCODED** subsidy; not a confirmed match |
| Order review | Lists live cart rows, but expresses difference from passed amount as subsidy and delivery as FREE | Mixed dynamic/hardcoded; **HARDCODED** fees and discount explanation |
| Confirmation | Reads current cart lines and total from provider; order identity is fixed/mock | Dynamic display from current cart state; not proof of persisted order data; runtime NOT RUN |
| Invoice | Fixed medicine lines, invoice ID, tax, taxable subtotal, gross | **HARDCODED** |
| Order history | Existing draft describes static/mock orders; no executed checkout-to-history comparison | **NOT VERIFIED** |

## Requested real flow: Glycomet ×1

The requested flow cannot be executed because Flutter launch is blocked before the app starts (engine cache write denied). Source inspection shows Glycomet has a listed price of ₹24.50; `CartNotifier` stores it in memory and the cart total is quantity × price. The order confirmation screen reads the current provider total, while the invoice screen is fixed at ₹1,507. No screen was observed in a running app, so values for checkout, order review, confirmation, history, and invoice are **NOT RUN**; invoice source values are explicitly **HARDCODED**. Evidence filename: none (no runtime capture exists).
