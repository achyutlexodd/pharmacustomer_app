# Phase 0 Reconnaissance & Audit Plan

## Reassessment execution note (7 October 2026)

Runtime execution was attempted and blocked. `flutter run -d chrome --web-port=8765 --no-pub` failed before app launch because the SDK attempted to write `engine.stamp.tmp` and `engine.realm` outside the writable workspace. `xcrun simctl list devices booted` could not connect to CoreSimulatorService. Therefore no screen screenshots or recordings exist, and prior source-line-based PASS labels are not accepted as runtime evidence. The requested Phase 1 sections 7.1–7.10 were not found in the supplied workspace. See `02_Test_Cases.csv` (186 NOT RUN rows), `12_E2E_Results.md`, and `11_Executive_Summary.md`.

## 1. Environment & Setup Summary
- **App Name / Package**: `pharmacustomer_app` (Customer App for Pharma / Medicine Delivery Platform)
- **Framework**: Flutter (Dart SDK ^3.12.2)
- **State Management**: `provider: ^6.1.2` (`CartNotifier` in `lib/core/providers/cart_notifier.dart`)
- **UI & Helpers**: `google_fonts: ^6.2.1`, `file_picker: ^8.1.2`, `printing: ^5.14.2`, `cupertino_icons: ^1.0.8`
- **Target Platforms**: iOS (Simulator available: `iPhone 17 Pro`), macOS Desktop, Web (`Chrome`), Android.
- **Analysis State**: `flutter analyze` passes clean (0 issues).
- **Test State**: `widget_test.dart` fails due to hardcoded legacy brand expectation (`AuraCare` vs `PharmaCustomer`).

---

## 2. Mock Layer Map
Data is currently scattered across hardcoded static models, local widget states, and in-memory stores:
1. `lib/core/models/mock_medicines.dart`: Static constant list (`janumet`, `Glycomet`, `Januvia`, `Accu-Chek`, `Glucerna`). Only 5 items; lacks out-of-stock items, insulin variants, or varied GST rates.
2. `lib/core/providers/cart_notifier.dart`: In-memory `Map<String, CartItem>`, no disk persistence (`SharedPreferences` or `Hive` missing).
3. `lib/features/cart/tax_invoice.dart`: Hardcoded invoice `AC-INV-2024-88402`, hardcoded lines and fixed ₹1,345.54 taxable subtotal + 6% CGST/SGST.
4. `lib/features/cart/order_review.dart`: Hardcoded `Draft #ORD-9841`, mock address and fixed subsidy/discount calculation.
5. `lib/features/prescriptions/`: Static mock prescription cards and local state transitions.
6. `lib/features/cart/live_tracking.dart` & `split_shipment_tracking.dart`: Hardcoded timeline states with manual or simulated step triggers.

---

## 3. Screen Inventory & Route Mapping
- **Total Screens/Features Identified**: 28 main screens across onboarding, auth, home, category, medicine detail, cart/checkout, prescriptions, orders, profile, and support.
- **Root Entry**: `Splash` (`lib/features/onboarding/splash.dart`) → 2.2s delay → `Login` (`lib/features/auth/login.dart`).
- **Auth Flow**: `Login` → `OTP` (`lib/features/auth/otp.dart`) → `ProfileSetup` (`lib/features/onboarding/profile_setup.dart`) → `Location` (`lib/features/onboarding/location.dart`) → `MainNavWrapper` (Home, Category, Prescriptions, Orders, Profile).
- **Catalog & Product Flow**: `Home` → `Search` → `CategoryDetail` / `CgmSubCategory` → `MedicineDetail` / `MedicineDetailExtended`.
- **Prescription Flow**: `PrescriptionUploadSheet` → `PrescriptionStatus` → `PrescriptionReviewStatus` → `PrescriptionRejection` / `PrescriptionClarification` / `PrescriptionPartialApproval` → `PrescriptionVault`.
- **Checkout & Fulfillment Flow**: `Cart` → `Address` / `AddressChange` → `CouponOffers` → `Payment` → `PaymentProcessing` → `PaymentDeclined` / `PaymentStatusRecovery` → `OrderReview` → `OrderPlaced` → `ClinicalDispensing` → `Fulfillment` → `LiveTracking` → `DoorstepVerification` → `DeliveryConfirmation` → `TaxInvoice`.
- **Post-Order & Account**: `OrderHistory`, `ProfileHome`, `ClinicalSupport`.

---

## 4. Status Coverage Matrix (Spec vs Current UI)
| Entity | Status | UI Screen/Representation Found? | Trigger Mechanism |
|---|---|---|---|
| Order | CREATED / PAYMENT_PENDING | Yes (`payment_processing.dart`, `order_review.dart`) | Forward navigation |
| Order | PAYMENT_CONFIRMED | Yes (`order_placed.dart`) | Mock timer / button |
| Order | STORE_ALLOCATED | Yes (`store_allocation_status.dart`, `clinical_dispensing.dart`) | Push route |
| Order | PACKING / FULFILLMENT | Yes (`fulfillment.dart`) | Step indicator |
| Order | OUT_FOR_DELIVERY | Yes (`live_tracking.dart`) | Screen widget |
| Order | DELIVERED | Yes (`delivery_confirmation.dart`) | Manual button |
| Order | CANCELLED / REJECTED | Partial (`payment_declined.dart`, no dedicated store cancellation screen) | Incomplete |
| Prescription | UPLOADED / UNDER_REVIEW | Yes (`prescription_review_status.dart`) | Vault list / status |
| Prescription | APPROVED / REJECTED / CLARIFICATION | Yes (`prescription_status.dart`, `prescription_rejection.dart`, `prescription_clarification.dart`) | Dedicated screens |
| Payment | SUCCESS / DECLINED / PENDING | Yes (`payment_status_recovery.dart`, `payment_declined.dart`, `payment_processing.dart`) | Explicit screens |

---

## 5. Phase-by-Phase Audit Execution Plan

### Phase 1: Functional Flows in UI
- Execute UI flows using Flutter testing/driver/device emulator on iOS Simulator / macOS desktop / Chrome.
- Test Phone number, OTP logic, Form constraints, Address & PIN checks.
- Test Prescription upload validation, Cart modifications, Checkout pricing calculations, Payment options, Tracking timelines, Delivery OTP modal, and Order History.

### Phase 2: State Management & Client Data Integrity
- Test cart state synchronization across screens (Cart vs Order Review vs Confirmation vs Badge).
- Verify navigation stack pop/push integrity and form state isolation.

### Phase 3: Edge Cases
- Test 14 mandatory spec edge cases (sold out, payment pending timeout, pharmacy rejection, prescription rejection, duplicate click, offline network mode).

### Phase 4: Client-Side Security & Privacy
- Audit hardcoded secrets, bundle artifacts, plain-text PII storage, unsafe text/HTML rendering, dependency vulnerabilities (`flutter pub outdated` / audit).

### Phase 5: Premium UI/UX Audit
- Screen-by-screen audit (1–5 scale across Visual Polish, Consistency, Clarity, State Coverage, Responsiveness, Accessibility).
- Calculate overall Premium Feel Score (0–100) and top 10 actionable recommendations.

### Phase 6: Backend-Readiness & API Contract
- Extract complete OpenAPI 3.0 draft contract (`openapi-draft.yaml`).
- Catalog server-owned rules that currently reside in client mocks.
- Prepare Deferred Backend Test Backlog.

### Phase 7: UI E2E Scenarios (C-E2E-01 to C-E2E-14)
- Execute and document each of the 14 mandatory end-to-end customer scenarios.

---

## 6. Output Artifacts Checklist
- [ ] `qa-report-customer-app/00_Environment_and_Inventory.md`
- [ ] `qa-report-customer-app/01_Traceability_Matrix.csv`
- [ ] `qa-report-customer-app/02_Test_Cases.csv`
- [ ] `qa-report-customer-app/03_Defect_Log.md`
- [ ] `qa-report-customer-app/04_Calculation_Verification.md`
- [ ] `qa-report-customer-app/05_Edge_Case_Coverage.md`
- [ ] `qa-report-customer-app/06_Client_Security_Report.md`
- [ ] `qa-report-customer-app/07_UI_UX_Audit.md`
- [ ] `qa-report-customer-app/08_Backend_Readiness_and_API_Contract.md` + `openapi-draft.yaml`
- [ ] `qa-report-customer-app/09_Deferred_Backend_Test_Backlog.csv`
- [ ] `qa-report-customer-app/10_Spec_Conflicts_and_Assumptions.md`
- [ ] `qa-report-customer-app/11_Executive_Summary.md`
