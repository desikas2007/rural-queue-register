📦 **RURAL HOSPITAL PATIENT QUEUE MANAGEMENT SYSTEM**
Complete Project Structure & Setup

═══════════════════════════════════════════════════════════════════════════════

## PROJECT OVERVIEW

Full-stack Next.js 14 application for managing patient queues in rural hospitals
with real-time updates, SMS notifications, and role-based access control.

**Live URL:** http://localhost:3000 (development)
**Tech Stack:** Next.js 14, React 18, TypeScript, Tailwind CSS, PostgreSQL, Firebase, Twilio

═══════════════════════════════════════════════════════════════════════════════

## FOLDER STRUCTURE

```
rural-queue-register/
│
├── 📁 prisma/
│   ├── schema.prisma          # Database schema (models, enums, relations)
│   └── seed.ts                # Database seed data
│
├── 📁 public/                 # Static assets
│   └── (images, fonts, etc.)
│
├── 📁 src/
│   │
│   ├── 📁 app/                # Next.js App Router pages
│   │   ├── 📁 (auth)/         # Auth route group
│   │   │   └── 📁 login/
│   │   │       └── page.tsx   # Login page
│   │   │
│   │   ├── 📁 (dashboard)/    # Protected dashboard routes
│   │   │   ├── 📁 admin/
│   │   │   │   └── page.tsx   # Admin dashboard
│   │   │   ├── 📁 doctor/
│   │   │   │   └── page.tsx   # Doctor console
│   │   │   └── 📁 receptionist/
│   │   │       └── page.tsx   # Receptionist dashboard
│   │   │
│   │   ├── 📁 queue-display/
│   │   │   └── page.tsx       # Public queue display
│   │   │
│   │   ├── 📁 register/
│   │   │   └── page.tsx       # Patient registration
│   │   │
│   │   ├── layout.tsx         # Root layout
│   │   ├── page.tsx           # Homepage
│   │   └── globals.css        # Global styles
│   │
│   ├── 📁 api/                # Next.js API Routes
│   │   ├── 📁 auth/
│   │   │   └── 📁 [...nextauth]/
│   │   │       └── route.ts   # NextAuth handler
│   │   │
│   │   ├── 📁 token/
│   │   │   ├── 📁 generate/
│   │   │   │   └── route.ts   # Generate token endpoint
│   │   │   └── 📁 update-status/
│   │   │       └── route.ts   # Update token status
│   │   │
│   │   ├── 📁 queue/
│   │   │   └── route.ts       # Get queue data endpoint
│   │   │
│   │   ├── 📁 sms/
│   │   │   └── route.ts       # Send SMS endpoint
│   │   │
│   │   └── 📁 analytics/
│   │       └── route.ts       # Analytics data endpoint
│   │
│   ├── 📁 components/         # React components
│   │   ├── 📁 ui/
│   │   │   ├── Button.tsx     # Reusable button component
│   │   │   ├── Input.tsx      # Reusable input component
│   │   │   └── Badge.tsx      # Reusable badge component
│   │   │
│   │   ├── PatientForm.tsx    # Patient registration form
│   │   ├── QueueBoard.tsx     # Queue display table
│   │   ├── TokenCard.tsx      # Token card component
│   │   ├── DoctorPanel.tsx    # Doctor consultation panel
│   │   └── AnalyticsChart.tsx # Analytics charts
│   │
│   ├── 📁 hooks/              # Custom React hooks
│   │   ├── useQueue.ts        # Queue management hook
│   │   └── useRealtimeQueue.ts # Firebase real-time listener
│   │
│   ├── 📁 lib/                # Utility functions & configs
│   │   ├── prisma.ts          # Prisma client instance
│   │   ├── firebase.ts        # Firebase initialization
│   │   ├── twilio.ts          # Twilio client & SMS
│   │   ├── auth.ts            # NextAuth configuration
│   │   ├── utils.ts           # Helper functions
│   │   └── errors.ts          # Custom error classes
│   │
│   ├── 📁 types/              # TypeScript types
│   │   └── index.ts           # All type definitions
│   │
│   └── middleware.ts          # NextAuth middleware
│
├── 📄 Configuration Files
│   ├── .env.local              # Environment variables (git ignored)
│   ├── .env.example            # Example environment template
│   ├── .env.docker             # Docker environment variables
│   ├── .gitignore              # Git ignore rules
│   ├── .eslintrc.json          # ESLint configuration
│   ├── next.config.ts          # Next.js configuration
│   ├── tsconfig.json           # TypeScript configuration
│   ├── tailwind.config.ts      # Tailwind CSS configuration
│   ├── postcss.config.js       # PostCSS configuration
│   └── package.json            # NPM dependencies
│
├── 📄 Docker & Deployment
│   ├── Dockerfile              # Docker image definition
│   └── docker-compose.yml      # Multi-container setup
│
└── 📄 Documentation
    ├── README.md               # Complete project guide
    ├── QUICKSTART.md           # Quick setup (5 min)
    ├── API.md                  # API documentation
    ├── DEPLOYMENT.md           # Production deployment
    ├── TESTING.md              # Testing & QA
    ├── BEST_PRACTICES.md       # Code quality & troubleshooting
    └── MIGRATION.md            # Database migrations

═══════════════════════════════════════════════════════════════════════════════

## KEY FEATURES IMPLEMENTED

✅ Patient Registration
   - Quick form with instant token generation
   - SMS notification on registration
   - Department selection
   
✅ Real-time Queue Display
   - Firebase Realtime Database integration
   - Live updates for all clients
   - Department-wise queue filtering
   
✅ Role-Based Dashboard
   - Patient: View registration status
   - Receptionist: Manage queue, call next, skip
   - Doctor: View current patient, mark complete, add referrals
   - Admin: Analytics and reporting
   
✅ SMS Notifications
   - Token generation alerts via Twilio
   - Instant notifications to patients
   - Status updates
   
✅ Analytics & Reporting
   - Daily patient count
   - Average wait time tracking
   - Department-wise statistics
   - Peak hours analysis
   - Charts and visualizations
   
✅ Authentication & Authorization
   - NextAuth.js with JWT tokens
   - Role-based access control (RBAC)
   - Secure session management
   - Protected API routes

✅ Responsive Design
   - Mobile-first approach with Tailwind CSS
   - Works on all device sizes
   - Accessible UI components

═══════════════════════════════════════════════════════════════════════════════

## TECHNOLOGY STACK

Frontend:
  - Next.js 14 (App Router)
  - React 18
  - TypeScript 5
  - Tailwind CSS 3
  - Recharts (Analytics)
  - Axios (HTTP client)

Backend:
  - Next.js API Routes
  - Node.js
  - Express-like middleware

Database:
  - PostgreSQL
  - Prisma ORM

Real-time:
  - Firebase Realtime Database

Integrations:
  - Twilio (SMS)
  - NextAuth.js (Authentication)

DevOps:
  - Docker & Docker Compose
  - GitHub Actions (CI/CD)

═══════════════════════════════════════════════════════════════════════════════

## DATABASE SCHEMA

Tables:
  - User (doctors, receptionists, admins, patients)
  - Patient (patient demographics)
  - Token (generated queue tokens)
  - QueueEntry (queue management)
  - ConsultationLog (doctor consultations)
  - Analytics (daily statistics)
  - SmsNotification (SMS tracking)

Relationships:
  - User → Token (1:many)
  - Patient → QueueEntry (1:many)
  - User (Doctor) → QueueEntry (1:many)
  - QueueEntry → ConsultationLog (1:1)

Enums:
  - Role: PATIENT, RECEPTIONIST, DOCTOR, ADMIN
  - TokenStatus: WAITING, CALLED, CONSULTING, COMPLETED, SKIPPED, NO_SHOW
  - Department: GENERAL, PEDIATRICS, ORTHOPEDICS, CARDIOLOGY, DERMATOLOGY
  - ReferralType: NONE, LAB, PHARMACY, SPECIALIST

═══════════════════════════════════════════════════════════════════════════════

## API ENDPOINTS

Authentication:
  POST   /api/auth/signin
  GET    /api/auth/signout

Token Management:
  POST   /api/token/generate              # Create new patient token
  POST   /api/token/update-status         # Update token status

Queue:
  GET    /api/queue                       # Get queue data
  GET    /api/queue?department=GENERAL    # Filter by department

Notifications:
  POST   /api/sms                         # Send SMS notification

Analytics:
  GET    /api/analytics                   # Get analytics data
  GET    /api/analytics?dateFrom=X&dateTo=Y

═══════════════════════════════════════════════════════════════════════════════

## QUICK START

1. Install dependencies:
   npm install

2. Setup environment:
   cp .env.example .env.local
   (Add your credentials)

3. Setup database:
   npm run prisma:generate
   npm run prisma:migrate
   npm run seed

4. Start development:
   npm run dev

5. Open browser:
   http://localhost:3000

═══════════════════════════════════════════════════════════════════════════════

## DEMO CREDENTIALS

After seeding database:

Doctor:
  Email: doctor@rural-queue.local
  Password: password

Receptionist:
  Email: receptionist@rural-queue.local
  Password: password

Admin:
  Email: admin@rural-queue.local
  Password: password

═══════════════════════════════════════════════════════════════════════════════

## DEPLOYMENT OPTIONS

1. Vercel (Recommended)
   - Push to GitHub
   - Connect to Vercel
   - Auto-deploy on push

2. Docker
   - docker-compose up
   - Includes PostgreSQL, Redis

3. AWS/GCP/Azure
   - Use provided Dockerfile
   - Configure environment variables

See DEPLOYMENT.md for detailed instructions.

═══════════════════════════════════════════════════════════════════════════════

## MONITORING & MAINTENANCE

Logging:
  - Console logs for development
  - Sentry for error tracking (optional)
  - Structured logging in production

Backups:
  - PostgreSQL automated backups
  - Firebase backup exports
  - Daily cron jobs configured

Performance:
  - Database connection pooling
  - Next.js optimization
  - CDN for static assets
  - Redis caching layer

═══════════════════════════════════════════════════════════════════════════════

## NPM SCRIPTS

npm run dev                 # Start development server
npm run build               # Build for production
npm start                   # Start production server
npm run lint                # Run ESLint
npm run prisma:generate     # Generate Prisma client
npm run prisma:migrate      # Run database migrations
npm run prisma:studio       # Open Prisma Studio UI
npm run seed                # Seed demo data
npm test                    # Run tests

═══════════════════════════════════════════════════════════════════════════════

## ENVIRONMENT VARIABLES REQUIRED

DATABASE_URL                      # PostgreSQL connection string
NEXTAUTH_SECRET                   # Min 32 character random string
NEXTAUTH_URL                      # Your app URL
NEXT_PUBLIC_FIREBASE_API_KEY      # Firebase API key
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN  # Firebase auth domain
... (see .env.example for full list)

═══════════════════════════════════════════════════════════════════════════════

## DOCUMENTATION

Full Documentation Available:
  - README.md              → Complete setup & features
  - QUICKSTART.md          → 5-minute setup guide
  - API.md                 → API reference
  - DEPLOYMENT.md          → Production deployment
  - TESTING.md             → Testing & QA procedures
  - BEST_PRACTICES.md      → Code quality & troubleshooting
  - MIGRATION.md           → Database migration help

═══════════════════════════════════════════════════════════════════════════════

## PROJECT STATUS

✅ Project Structure: Complete
✅ Database Schema: Complete
✅ API Routes: Complete
✅ Frontend Components: Complete
✅ Authentication: Complete
✅ Real-time Features: Complete
✅ SMS Integration: Complete
✅ Analytics: Complete
✅ Documentation: Complete
✅ Docker Setup: Complete
✅ Error Handling: Complete
✅ Security: Complete

═══════════════════════════════════════════════════════════════════════════════

## NEXT STEPS

1. Update .env.local with your credentials
2. Run: npm install
3. Run: npm run prisma:migrate
4. Run: npm run seed (optional)
5. Run: npm run dev
6. Visit: http://localhost:3000

═══════════════════════════════════════════════════════════════════════════════

Created: April 23, 2026
Version: 1.0.0
License: MIT

═══════════════════════════════════════════════════════════════════════════════
