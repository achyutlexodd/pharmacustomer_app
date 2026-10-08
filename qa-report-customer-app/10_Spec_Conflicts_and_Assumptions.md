# Spec Conflicts & Developer Assumptions Log

## Reassessment status

**Q76 is UNCONFIRMED:** tax-inclusive versus tax-exclusive prices and the rounding rule are not established by available specification. Both candidate calculations are shown in `04_Calculation_Verification.md`; do not classify the UI as failing an assumed policy. CONF-01 is a **S1** specification conflict requiring a product decision before integration.

## 1. Specification Conflicts (`SPEC-CONFLICT`)

| Conflict ID | Topic | Model A (Architecture Doc) | Model B (Clarifications Doc) | Implemented in Current UI | Verdict / Defect |
|---|---|---|---|---|---|
| **CONF-01** | Pharmacy Visibility & Selection | Platform allocates pharmacy silently; customer never sees store identity | Customer selects pharmacy; multi-pharmacy carts split into sub-orders | **Hybrid**: Single cart initially, but `split_shipment_tracking.dart` and `address_change.dart` explicitly display store brands (`Apollo Pharmacy`, `MedPlus Pharmacy`) | `SPEC-CONFLICT` (Severity S1) |
| **CONF-02** | Multi-store Cart Splitting | One cart → one allocated fulfillment store | One cart → split sub-orders per pharmacy | `split_shipment_tracking.dart` implements split shipments (`Shipment 1 of 2` from MedPlus, `Shipment 2 of 2` from Apollo) | `SPEC-CONFLICT` (Severity S2) |
| **CONF-03** | Platform & Delivery Fees | Delivery fee + platform fee applied on bill | No platform fee, no delivery fee on customer bill | Current UI shows `Delivery fee: FREE` and `Handling & packaging: FREE` in `cart.dart` | `SPEC-CONFLICT` (Severity S2) |
| **CONF-04** | Invoice Issuer Identity | Platform-generated centralized invoice | Pharmacy-generated invoice in dispensary's name | `tax_invoice.dart` issues invoice under retail entity `AuraCare Retail & Specialty Pharmacy Pvt Ltd` | `SPEC-CONFLICT` (Severity S2) |

---

## 2. Developer Assumptions (`ASSUMPTION-MADE-BY-DEV, NEEDS CLIENT CONFIRMATION`)

| Assumption ID | Area | Developer Assumption Made in Code | Relevant Clarification Q# | Recommended Resolution |
|---|---|---|---|---|
| **ASSUMP-01** | OTP Expiry & Resend | OTP resend timer is 48 seconds (`lib/features/auth/otp.dart:20`) | Q14 (Auth flow) | Confirm whether 48s, 30s, or 60s is standard SLA. |
| **ASSUMP-02** | Coupon Flat Discount | `AURACARE50` offers flat ₹50 OFF on first prescription order above ₹999 (`coupon_offers.dart:24`) | Q28 (Coupons & Discounts) | Confirm coupon master catalog and eligibility rules. |
| **ASSUMP-03** | In-flight Address Change | Allowed with route recalculation & partner dispensary re-allocation (`address_change.dart:241`) | Q60 (In-flight cancellation & edits) | Confirm if customer can change address once order is in packing/transit. |
| **ASSUMP-04** | Partial Shortage Refund SLA | Instant auto-refund credited to original UPI account within 2–4 hours (`fulfillment.dart:284`) | Q61 (Refund processing SLA) | Confirm banking refund timeline copy (Instant vs 2–4 hours vs 5–7 days). |
| **ASSUMP-05** | Delivery Handover Code Length | Handover security PIN is 4 digits (`8492`) instead of 6 digits (`live_tracking.dart:244`) | Q49 (Handover OTP) | Confirm whether delivery OTP is 4 digits or 6 digits. |
| **ASSUMP-06** | Max Item Quantity | Cart restricts max item quantity to 10 units (`cart_notifier.dart:19`) | Q35 (Cart restrictions) | Confirm max order quantity limit for scheduled OTC vs Rx medicines. |
