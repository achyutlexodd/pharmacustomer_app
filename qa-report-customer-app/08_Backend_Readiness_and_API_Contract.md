# Backend Readiness & API Contract

## Status

The frontend is **NOT READY for production integration**: the existing client uses mock/static data, client-only cart state, hardcoded invoice/IDs/fees, and no authoritative inventory or payment backend. The OpenAPI draft covers the endpoint inventory described below. It is a proposed contract, not a confirmed server implementation.

## Endpoint inventory

All endpoints use the single base path `https://api.staging.pharmavis.in/api/v1` in `openapi-draft.yaml`.

- Auth: `POST /auth/otp/send`, `POST /auth/otp/verify`
- Customer: `GET/PUT /customer/profile`; `GET/POST /customer/addresses`; `GET/PUT/DELETE /customer/addresses/{addressId}`
- Serviceability: `POST /serviceability/check`
- Catalog: `GET /catalog/medicines`, `GET /catalog/medicines/{medicineId}`
- Prescriptions: `POST /prescriptions/upload`, `GET /prescriptions`, `GET /prescriptions/{prescriptionId}`
- Quote: `POST /checkout/quote`, `POST /orders/quote` (both paths kept because readiness notes explicitly name `/api/v1/checkout/calculate` and `/api/v1/orders/quote`; reconcile naming before implementation)
- Orders: `POST /orders/create`, `GET /orders`, `GET /orders/{orderId}`, `GET /orders/{orderId}/tracking`, `POST /orders/{orderId}/cancel`
- Payments: `POST /payments/initiate`, `GET /payments/{paymentId}/status`
- Refunds: `GET /refunds`, `GET /refunds/{refundId}`
- Invoices: `GET /orders/{orderId}/invoice`
- Notifications: `GET /notifications`, `POST /notifications/{notificationId}/read`
- Support: `GET/POST /support/tickets`, `GET /support/tickets/{ticketId}`

Order create includes `prescription_ids` and per-line `prescription_id`; it requires an `Idempotency-Key`. Payment initiation, cancellation, and ticket creation also require idempotency keys. List endpoints support page/page_size. Common error schema carries code, message, details, and request_id.

## Server-owned decisions

Server must own tax-inclusive/exclusive interpretation and rounding (Q76 is unconfirmed), coupon eligibility, stock reservation and last-unit contention, prescription approval gates, COD eligibility/limits, cancellation by stage, order IDs and delivery verification codes, payment reconciliation, refund amounts/timing, serviceability, and notification delivery. Client must re-quote before order creation and render returned authoritative totals/statuses.
