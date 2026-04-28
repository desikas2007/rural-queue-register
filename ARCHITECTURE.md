# System Architecture & Data Flow

## 🏗️ System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        CLIENT LAYER (Frontend)                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐            │
│  │   Patient    │  │ Receptionist │  │   Doctor     │   Admin    │
│  │ Registration │  │  Dashboard   │  │   Console    │ Dashboard  │
│  └──────────────┘  └──────────────┘  └──────────────┘            │
│        │                │                    │                   │
│        └────────────────┴────────────────────┴───────────────────┘
│                             ▼                                     │
│                    React Components (UI)                         │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      MIDDLEWARE LAYER                            │
├─────────────────────────────────────────────────────────────────┤
│  NextAuth.js Middleware (Authentication & Authorization)        │
│  Error Handling Middleware                                      │
│  CORS & Security Headers                                        │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      API LAYER (Backend)                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌────────────────┐  ┌────────────────┐  ┌────────────────┐    │
│  │  Auth APIs     │  │  Token APIs    │  │  Queue APIs    │    │
│  │  - signin      │  │  - generate    │  │  - getQueue    │    │
│  │  - signout     │  │  - updateStatus│  │  - filter      │    │
│  └────────────────┘  └────────────────┘  └────────────────┘    │
│                                                                   │
│  ┌────────────────┐  ┌────────────────┐  ┌────────────────┐    │
│  │  SMS APIs      │  │  Analytics API │  │   (Protected)  │    │
│  │  - sendSMS     │  │  - getMetrics  │  │   JWT Auth     │    │
│  │  - track       │  │  - getStats    │  │   Required     │    │
│  └────────────────┘  └────────────────┘  └────────────────┘    │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
                              │
                ┌─────────────┼─────────────┐
                ▼             ▼             ▼
┌──────────────────────┐  ┌──────────────────────┐
│  DATABASE LAYER      │  │  EXTERNAL SERVICES   │
├──────────────────────┤  ├──────────────────────┤
│  PostgreSQL          │  │  Firebase Realtime   │
│  (via Prisma ORM)    │  │  - Real-time DB      │
│                      │  │  - Queue updates     │
│  Tables:             │  │                      │
│  - User              │  │  Twilio              │
│  - Patient           │  │  - SMS service       │
│  - Token             │  │  - Notifications     │
│  - QueueEntry        │  │                      │
│  - ConsultationLog   │  │  NextAuth.js         │
│  - Analytics         │  │  - Authentication    │
│  - SmsNotification   │  │  - Sessions          │
└──────────────────────┘  └──────────────────────┘
```

---

## 📊 Data Flow Diagram

### Patient Registration Flow

```
Patient (No Login)
    │
    ▼
[Registration Form] ─► Validate Input
    │
    ├─► Create Patient (DB)
    │
    ├─► Generate Token Number
    │
    ├─► Create User (DB)
    │
    ├─► Create Token (DB)
    │
    ├─► Create QueueEntry (DB)
    │
    ├─► Update Firebase (Real-time Queue)
    │
    ├─► Send SMS via Twilio
    │
    ├─► Log SMS Notification (DB)
    │
    ▼
[Success: Show Token #]
    │
    ▼
Patient can now view live queue at /queue-display
```

### Receptionist Queue Management Flow

```
Receptionist (Authenticated)
    │
    ▼
[Login with Credentials]
    │
    ├─► Validate Email & Password
    │
    ├─► Generate JWT Token
    │
    ├─► Create Session
    │
    ▼
[Receptionist Dashboard]
    │
    ├─► Fetch Queue (GET /api/queue)
    │   └─► Query DB for waiting patients
    │
    ├─► Display Queue Stats
    │   ├─► Total Waiting
    │   ├─► Currently Consulting
    │   └─► Completed Today
    │
    ├─► Call Next Patient
    │   ├─► Update Token Status → CALLED
    │   ├─► Update QueueEntry Status
    │   ├─► Update Firebase
    │   └─► Notify Doctor
    │
    ├─► Skip Patient
    │   ├─► Update Token Status → SKIPPED
    │   ├─► Update QueueEntry Status
    │   └─► Update Firebase
    │
    ▼
[Queue Updated in Real-time for all viewers]
```

### Doctor Consultation Flow

```
Doctor (Authenticated)
    │
    ▼
[Login with Credentials]
    │
    ├─► Validate Email & Password & Role=DOCTOR
    │
    ├─► Create JWT Session
    │
    ▼
[Doctor Console]
    │
    ├─► Get Current Patient (Status = CALLED)
    │   ├─► Query DB for called tokens
    │   ├─► Load Patient Details
    │   └─► Display in Doctor Panel
    │
    ├─► View Patient Details
    │   ├─► Name, Age, Phone
    │   ├─► Department, Wait Time
    │   └─► Medical History
    │
    ├─► Enter Consultation Data
    │   ├─► Diagnosis
    │   ├─► Treatment
    │   ├─► Notes
    │   └─► Duration
    │
    ├─► Option 1: Mark Complete
    │   ├─► Create ConsultationLog (DB)
    │   ├─► Update Token Status → COMPLETED
    │   ├─► Update QueueEntry Status
    │   └─► Update Firebase
    │
    ├─► Option 2: Add Referral
    │   ├─► Select Referral Type (Lab/Pharmacy/Specialist)
    │   ├─► Add Notes
    │   ├─► Create ConsultationLog with referral
    │   ├─► Update Token Status → COMPLETED
    │   └─► Update Firebase
    │
    ▼
[Next patient automatically loaded or "No patients"]
```

### Analytics Flow

```
Admin (Authenticated)
    │
    ▼
[Login with Credentials]
    │
    ├─► Validate Role = ADMIN
    │
    ├─► Create JWT Session
    │
    ▼
[Admin Dashboard]
    │
    ├─► Query Analytics (GET /api/analytics)
    │   ├─► Date Range Parameters
    │   ├─► Query Analytics Table
    │   └─► Return aggregated data
    │
    ├─► Calculate Metrics
    │   ├─► Total Patients
    │   ├─► Avg Wait Time
    │   ├─► Completed Consultations
    │   └─► Department Breakdown
    │
    ├─► Display Charts
    │   ├─► Line Chart (Trends)
    │   ├─► Bar Chart (Comparisons)
    │   └─► Tables (Details)
    │
    ├─► Show Statistics
    │   ├─► Per Department
    │   ├─► Peak Hours
    │   └─► Performance Metrics
    │
    ▼
[Admin can export data for reporting]
```

### Real-time Queue Update Flow

```
Database (QueueEntry Updated)
    │
    ▼
[API Updates Firebase]
    │
    ▼
Firebase Realtime Database
    │
    ├─► queue/GENERAL/token-1
    ├─► queue/PEDIATRICS/token-2
    └─► queue/CARDIOLOGY/token-3
    │
    ▼
[Listener on Clients]
    │
    ├─► Queue Display Page
    ├─► Receptionist Dashboard
    ├─► Doctor Console
    └─► Admin Dashboard
    │
    ▼
[All viewers see updated queue in real-time]
```

### SMS Notification Flow

```
Patient Registers
    │
    ▼
[Generate Token]
    │
    ▼
[Compose SMS Message]
│ "Your token #42 generated for GENERAL dept"
│
    ▼
[Send to Twilio API]
    │
    ├─► Account SID
    ├─► Auth Token
    ├─► From: TWILIO_PHONE_NUMBER
    ├─► To: Patient Phone
    └─► Message: Token notification
    │
    ▼
[Twilio Processes]
    │
    ▼
[SMS Sent to Patient]
    │
    ▼
[Log in Database]
    │
    ├─► Status: sent
    ├─► Timestamp
    └─► Message ID
    │
    ▼
[Patient receives SMS]
```

---

## 🔐 Authentication & Authorization Flow

```
User Attempts Login
    │
    ▼
[POST /api/auth/signin]
    │
    ├─► Validate Email Format
    │
    ├─► Query User from DB
    │   └─► If not found → Error
    │
    ├─► Compare Password with Hash
    │   ├─► bcrypt.compare()
    │   └─► If mismatch → Error
    │
    ├─► Extract User Data
    │   ├─► id
    │   ├─► email
    │   ├─► role (DOCTOR/RECEPTIONIST/ADMIN)
    │   └─► department
    │
    ├─► Generate JWT Token
    │   ├─► Signed with NEXTAUTH_SECRET
    │   ├─► Expires in 24 hours
    │   └─► Contains user info & role
    │
    ├─► Create Session Cookie
    │   └─► Secure HTTP-only cookie
    │
    ▼
[Return Success with Token]
    │
    ▼
[Browser Stores JWT in Secure Cookie]
    │
    ▼
User can now access protected routes
    │
    ▼
[Middleware checks JWT on each request]
    │
    ├─► Valid token & role → Allow
    ├─► Invalid token → Redirect to login
    └─► Wrong role → Deny access
```

---

## 📱 Component Hierarchy

```
RootLayout
│
├─── HomePage
│    ├─── Hero Section
│    ├─── Features Grid
│    └─── Staff Access Cards
│
├─── LoginPage
│    ├─── LoginForm
│    │    ├─── EmailInput
│    │    ├─── PasswordInput
│    │    └─── SubmitButton
│    └─── DemoCredentials
│
├─── RegisterPage
│    ├─── PatientForm
│    │    ├─── NameInput
│    │    ├─── PhoneInput
│    │    ├─── AgeInput
│    │    ├─── GenderSelect
│    │    ├─── DepartmentSelect
│    │    └─── GenerateButton
│    └─── InfoSection
│
├─── QueueDisplayPage
│    ├─── DepartmentFilter
│    │    └─── [GENERAL, PEDIATRICS, ...]
│    ├─── QueueBoard
│    │    └─── QueueTable
│    │         ├─── TokenNumber
│    │         ├─── PatientName
│    │         ├─── Status Badge
│    │         └─── WaitTime
│    └─── LiveStatus
│
├─── ReceptionistPage
│    ├─── Header
│    ├─── StatsCards
│    │    ├─── TotalWaiting
│    │    ├─── Consulting
│    │    └─── Completed
│    ├─── QueueBoard
│    │    └─── ActionButtons (Call, Skip)
│    └─── RefreshButton
│
├─── DoctorPage
│    ├─── Header
│    ├─── DoctorPanel
│    │    ├─── CurrentPatientCard
│    │    │    ├─── PatientName
│    │    │    ├─── Department
│    │    │    └─── WaitTime
│    │    ├─── TreatmentForm
│    │    │    ├─── Textarea
│    │    │    └─── Button
│    │    ├─── MarkCompleteButton
│    │    └─── ReferralForm (Conditional)
│    │         ├─── ReferralTypeSelect
│    │         ├─── NotesTextarea
│    │         └─── ConfirmButton
│    └─── QueueStats
│         ├─── Waiting Count
│         └─── Your Queue Count
│
└─── AdminPage
     ├─── Header
     ├─── MetricsCards
     │    ├─── TotalPatients
     │    ├─── Consultations
     │    ├─► AvgWaitTime
     │    └─► Performance
     ├─── AnalyticsCharts
     │    ├─── LineChart
     │    └─── BarChart
     └─── DepartmentStatsTable
          ├─── Department
          ├─── Total
          ├─── Completed
          └─── AvgWaitTime
```

---

## 🔄 Database Relationships

```
User (1)
  │
  ├─ (1:M) ─────► Token
  │
  ├─ (1:M) ─────► QueueEntry (as Doctor)
  │
  └─ (1:M) ─────► ConsultationLog

Patient (1)
  │
  └─ (1:M) ─────► QueueEntry

QueueEntry (1)
  │
  └─ (1:1) ─────► ConsultationLog

Enums Used:
├─ Role: PATIENT, RECEPTIONIST, DOCTOR, ADMIN
├─ TokenStatus: WAITING, CALLED, CONSULTING, COMPLETED, SKIPPED, NO_SHOW
├─ Department: GENERAL, PEDIATRICS, ORTHOPEDICS, CARDIOLOGY, DERMATOLOGY
└─ ReferralType: NONE, LAB, PHARMACY, SPECIALIST
```

---

## 🚀 Deployment Architecture

```
┌─────────────────────────────────────────────────────┐
│              Client (Browser)                       │
└──────────────────────┬──────────────────────────────┘
                       │
                ▼
┌─────────────────────────────────────────────────────┐
│   DNS / Load Balancer (Production)                  │
│   or localhost:3000 (Development)                   │
└──────────────────────┬──────────────────────────────┘
                       │
        ┌──────────────┴──────────────┐
        │                             │
        ▼                             ▼
┌─────────────────────────┐  ┌─────────────────────────┐
│   Next.js Server (1)    │  │   Next.js Server (2)    │
│   Port: 3000            │  │   Port: 3000            │
│                         │  │                         │
│   ├─ App Router Pages   │  │   ├─ App Router Pages   │
│   ├─ API Routes         │  │   ├─ API Routes         │
│   ├─ Middleware         │  │   ├─ Middleware         │
│   └─ Static Assets      │  │   └─ Static Assets      │
└──────────┬──────────────┘  └──────────┬──────────────┘
           │                            │
           └────────────────┬───────────┘
                            │
            ┌───────────────┼───────────────┐
            │               │               │
            ▼               ▼               ▼
    ┌──────────────┐ ┌──────────────┐ ┌──────────────┐
    │ PostgreSQL   │ │   Firebase   │ │   Twilio     │
    │   (Primary)  │ │   (Real-time)│ │    (SMS)     │
    │              │ │              │ │              │
    │ User         │ │ Queue Data   │ │ SMS Service  │
    │ Patient      │ │ Updates      │ │              │
    │ Token        │ │              │ │              │
    │ QueueEntry   │ │              │ │              │
    │ Analytics    │ │              │ │              │
    └──────────────┘ └──────────────┘ └──────────────┘
            │               │               │
            └───────────────┴───────────────┘
                            │
                    ▼
                [Backups & Monitoring]
```

---

## 🔍 Request/Response Cycle

```
1. User Makes Request
   └─► http://localhost:3000/api/token/generate

2. Request Reaches Middleware
   ├─► Log Request
   ├─► Check CORS
   └─► Extract User Info (if authenticated)

3. Route Handler Processes
   ├─► Validate Input
   ├─► Check Permissions
   ├─► Interact with Database (Prisma)
   ├─► Call External Services (Firebase, Twilio)
   └─► Prepare Response

4. Response Sent to Client
   ├─► Status Code (200, 400, 401, 500, etc.)
   ├─► JSON Body
   └─► Headers

5. Client Processes Response
   ├─► Update State (React)
   ├─► Update UI
   ├─► Display Success/Error Message
   └─► Trigger Side Effects (Firebase listeners, etc.)
```

---

This architecture provides:
- ✅ **Scalability** - Horizontal scaling via load balancing
- ✅ **Real-time** - Firebase for instant updates
- ✅ **Security** - JWT auth, role-based access
- ✅ **Reliability** - Database backups, error handling
- ✅ **Performance** - Optimized queries, caching ready
- ✅ **Maintainability** - Clean separation of concerns

