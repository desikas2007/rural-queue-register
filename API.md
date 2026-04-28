# API Documentation

## Authentication

### POST /api/auth/signin
Sign in with email and password.

**Request:**
```json
{
  "email": "doctor@rural-queue.local",
  "password": "password"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "user-id",
      "email": "doctor@rural-queue.local",
      "name": "Dr. John Doe",
      "role": "DOCTOR"
    },
    "token": "jwt-token"
  }
}
```

## Token Management

### POST /api/token/generate
Generate a new patient token.

**Request:**
```json
{
  "name": "John Patient",
  "phone": "+1234567890",
  "age": 35,
  "gender": "male",
  "department": "GENERAL"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "tokenNumber": 42,
    "tokenId": "token-id",
    "queueEntryId": "queue-entry-id",
    "message": "Token generated successfully"
  }
}
```

### POST /api/token/update-status
Update token status.

**Request:**
```json
{
  "tokenId": "token-id",
  "status": "CALLED",
  "additionalData": {
    "doctorId": "doctor-id"
  }
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "token": {
      "id": "token-id",
      "tokenNumber": 42,
      "status": "CALLED",
      "calledAt": "2026-04-23T10:00:00Z"
    },
    "queueEntry": {}
  }
}
```

## Queue

### GET /api/queue
Get current queue data.

**Query Parameters:**
- `department` (optional): Filter by department
- `limit` (optional): Maximum results (default: 50)

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "entry-id",
      "tokenId": "token-id",
      "patientId": "patient-id",
      "status": "WAITING",
      "department": "GENERAL",
      "waitingTime": 5,
      "patient": {
        "name": "John Patient",
        "phone": "+1234567890",
        "age": 35
      }
    }
  ]
}
```

## SMS

### POST /api/sms
Send SMS notification.

**Request:**
```json
{
  "phoneNumber": "+1234567890",
  "message": "Your token is ready. Please come to the reception.",
  "tokenId": "token-id"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "sid": "twilio-message-id",
    "message": "SMS sent successfully"
  }
}
```

## Analytics

### GET /api/analytics
Get analytics data.

**Query Parameters:**
- `dateFrom` (optional): Start date (ISO format)
- `dateTo` (optional): End date (ISO format)
- `department` (optional): Filter by department

**Response:**
```json
{
  "success": true,
  "data": {
    "analytics": [
      {
        "id": "analytics-id",
        "date": "2026-04-23T00:00:00Z",
        "totalPatients": 45,
        "totalConsultations": 40,
        "avgWaitTime": 12.5,
        "avgConsultationTime": 8.2,
        "departmentMetrics": {},
        "peakHours": {}
      }
    ],
    "aggregates": {
      "totalPatients": 315,
      "totalConsultations": 280,
      "avgWaitTime": 13.2,
      "period": "2026-04-16 to 2026-04-23"
    }
  }
}
```

## Error Responses

All error responses follow this format:

```json
{
  "success": false,
  "error": "Error message describing what went wrong"
}
```

**Common HTTP Status Codes:**
- 200: Success
- 201: Created
- 400: Bad Request
- 401: Unauthorized
- 404: Not Found
- 500: Internal Server Error

## Rate Limiting

API endpoints may be rate limited. Check response headers:
- `X-RateLimit-Limit`: Total requests allowed
- `X-RateLimit-Remaining`: Requests remaining
- `X-RateLimit-Reset`: Time when limit resets
