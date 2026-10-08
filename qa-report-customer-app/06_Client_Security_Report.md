# Client-Side Security & Privacy Hygiene Report

## Reassessment qualification

This is static source review only; no runtime security test or external dependency vulnerability scan was executed in this reassessment. Replace PASS below with SOURCE REVIEWED where indicated. No security conclusion is supported by screenshots because the app could not launch.

## 1. Executive Summary
This report evaluates the client-side attack surface, credential exposure, data privacy compliance, and dependency hygiene for `pharmacustomer_app`.

---

## 2. Findings Matrix

| Audit Dimension | Evaluation Result | Findings & Details | Risk Level |
|---|---|---|---|
| **Hardcoded Secrets & API Keys** | **SOURCE REVIEWED** | Static text search in the previous report claimed no exposed keys; this was not re-executed in this reassessment. | Unverified |
| **Transport Security (Cleartext HTTP)** | **SOURCE REVIEWED** | No runtime/network traffic inspection was performed; prior static claim is not a runtime PASS. | Unverified |
| **PII & Data Storage Hygiene** | **WARNING** | Currently, state is kept strictly in transient memory (`CartNotifier`, local widget states). No PII is logged to persistent storage yet; however, when offline persistence is added, encryption is mandatory. | Medium |
| **OTP & Token Masking in Logs** | **SOURCE REVIEWED** | Prior draft reports no OTP logging; logging audit was not rerun here. | Unverified |
| **Prescription Image Exposure** | **SOURCE REVIEWED** | Source describes in-memory image display; storage permissions/temporary files were not runtime-tested. | Unverified |
| **Dependency Vulnerabilities & Audit** | **NOT RUN** | No vulnerability scanner or dependency advisory check was run in this reassessment. | Unverified |
| **Input Sanitization & Injection** | **SOURCE REVIEWED** | Flutter text widgets are used; dynamic rendering and runtime injection cases were not exercised. | Unverified |
| **Client-Side Business Logic Gating** | **DEFECT (S1)** | Cart totals, coupon eligibility, and prescription dispensation gating are evaluated entirely on the client side without backend signature verification. Must be enforced by server APIs upon backend integration. | High (Architectural) |

---

## 3. Remediation Checklist for Backend Integration
1. **Never Trust Client Totals**:
   - Ensure the upcoming backend API calculates all item totals, GST splits, and coupon deductions independently on `/api/v1/orders/checkout`.
2. **Secure Token Storage**:
   - Store future JWT session tokens in platform secure storage (`flutter_secure_storage` or Keychain/Keystore) rather than plain `SharedPreferences`.
3. **Prescription Upload Pre-signed URLs**:
   - Prescriptions should upload directly to private, pre-signed Cloud Storage buckets with short-lived tokens and MIME-type validation.
