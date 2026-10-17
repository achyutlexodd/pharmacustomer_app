# API Contract

This document specifies the remote endpoints assumed for the persistent state layer. Until the backend is deployed, these contracts are backed by remote interfaces (`AuthRemoteDataSource`, `CartRemoteDataSource`, `OrdersRepository`, `PrescriptionRepository`) and their default in-memory implementations.

---

## 1. Authentication (`/auth`)

### `POST /auth/otp/verify`
Exchanges phone number and OTP for session credentials.
- **Request Body**:
  ```json
  {
    "phone": "+919876543210",
    "otp": "123456"
  }
  ```
- **Response `200 OK`**:
  ```json
  {
    "accessToken": "jwt.access.token",
    "refreshToken": "refresh.token.uuid",
    "accessExpiresAt": "2026-10-16T12:00:00Z",
    "userId": "u_123"
  }
  ```
- **Errors**: `400 Bad Request`, `401 Unauthorized` (invalid/expired OTP).

### `POST /auth/refresh`
Refreshes an expired access token using a valid refresh token.
- **Request Body**:
  ```json
  {
    "refreshToken": "refresh.token.uuid"
  }
  ```
- **Response `200 OK`**: Same format as `verify`.
- **Errors**: `401 Unauthorized` (emits `SessionExpired`).

### `POST /auth/logout`
Revokes active session tokens.
- **Headers**: `Authorization: Bearer <accessToken>`
- **Response `200 OK`**: `{ "success": true }`

---

## 2. Cart (`/cart`)

### `GET /cart`
Fetches canonical server cart.
- **Headers**: `Authorization: Bearer <accessToken>`
- **Response `200 OK`**:
  ```json
  {
    "revision": 3,
    "lastSyncedAt": "2026-10-15T07:32:10Z",
    "lines": [
      {
        "productId": "p_glycomet_gp2f",
        "name": "Glycomet-GP 2 Forte",
        "packSize": "Strip of 15 tablets",
        "unitPricePaise": 14860,
        "quantity": 5,
        "requiresPrescription": true
      }
    ],
    "prescriptionIds": []
  }
  ```

### `PUT /cart`
Updates server cart with optimistic locking.
- **Headers**:
  - `Authorization: Bearer <accessToken>`
  - `If-Match: <revision>`
- **Response `200 OK`**: Updated cart object.
- **Errors**: `409 Conflict` (triggers fetch + local `CartMergePolicy.mergeMaxQuantity` + re-push).

---

## 3. Orders (`/orders`)

### `POST /orders`
Places an order with idempotency guarantee.
- **Headers**:
  - `Authorization: Bearer <accessToken>`
  - `Idempotency-Key: <uuid>`
- **Request Body**:
  ```json
  {
    "cartFingerprint": "sha256...",
    "deliveryAddressId": "addr_1",
    "prescriptionIds": ["rx_1"]
  }
  ```
- **Response `201 Created`**:
  ```json
  {
    "orderId": "#HRX-982310",
    "status": "placed",
    "totalPaise": 245900,
    "itemCount": 8,
    "createdAt": "2026-10-15T07:45:00Z"
  }
  ```

---

## 4. Prescriptions (`/prescriptions`)

### `POST /prescriptions/upload`
Multipart upload for doctor prescriptions.
- **Headers**:
  - `Authorization: Bearer <accessToken>`
  - `Idempotency-Key: <queueId>`
- **Multi-part fields**: `file` (image/pdf, max 10MB), `source` (`upload` or `link`).
- **Response `201 Created`**:
  ```json
  {
    "id": "rx_server_99",
    "localId": "queue_123",
    "status": "uploaded",
    "fileName": "rx.jpg",
    "remoteUrl": "https://cdn.example.com/rx/99.jpg"
  }
  ```
