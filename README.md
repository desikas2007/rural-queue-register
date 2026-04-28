# rural-queue-register
🏥 Rural Hospital Patient Queue Management System - Project Description Overview This is a complete full-stack web application designed for rural hospitals to manage patient queues efficiently. It provides real-time queue management, patient registration, doctor consultation tracking, and analytics—all in one integrated system.  
Project Purpose
Problem Solved:

❌ Manual queue management is inefficient
❌ Patients don't know their queue position
❌ Doctors waste time finding next patient
❌ No data on wait times or performance
❌ SMS notifications not automated
Solution:

✅ Automated queue management
✅ Real-time patient tracking
✅ SMS notifications
✅ Performance analytics
✅ Role-based access control
Key Features
👤 Patient Module
Self-service registration (no login required)
Automatic token generation
SMS notification with token number
Real-time queue position tracking
View current queue status anytime
👩‍💼 Receptionist Module
Queue management dashboard
"Call next patient" button
Mark no-show/skip options
Real-time statistics
View all waiting patients
👨‍⚕️ Doctor Module
Current patient display
Consultation notes entry
Diagnosis & treatment tracking
Referral system (Lab, Pharmacy, Specialist)
Patient medical history access
📊 Admin Module
Analytics dashboard with charts
Performance metrics
Department statistics
Wait time analysis
Daily reports
🔐 Security & Access Control
Role-based login (DOCTOR, RECEPTIONIST, ADMIN, PATIENT)
Secure password hashing
JWT token authentication
Protected routes
Technology Stack
Layer	Technology
Frontend	Next.js 14, React 18, TypeScript, Tailwind CSS
Backend	Node.js, Next.js API Routes
Database	PostgreSQL 18 + Prisma ORM
Real-time	Firebase Realtime Database
Notifications	Twilio SMS Service
Authentication	NextAuth.js with JWT
Visualization	Recharts (for analytics)
DevOps	Docker, Docker Compose
Project Structure:
rural-queue-register/
├── src/
│   ├── app/                 # 9 Pages (routes)
│   ├── api/                 # 6+ API Endpoints
│   ├── components/          # 8 React Components
│   ├── hooks/               # 2 Custom Hooks
│   ├── lib/                 # Utilities (Prisma, Firebase, Twilio, Auth)
│   ├── types/               # TypeScript Types
│   └── middleware.ts        # Authentication Middleware
│
├── prisma/
│   ├── schema.prisma        # Database Schema (7 tables)
│   └── seed.ts              # Demo Data
│
├── Documentation (16 files)
├── Docker Setup
└── Setup Scripts
Database Schema
7 Main Tables:

User - Staff and admin accounts
Patient - Patient information
Token - Generated queue tokens
QueueEntry - Queue management
ConsultationLog - Doctor consultations
Analytics - Daily statistics
SmsNotification - SMS tracking
Relationships:

User → Token (1:Many)
Patient → QueueEntry (1:Many)
Doctor → QueueEntry (1:Many)
QueueEntry → ConsultationLog (1:1)
API Endpoints
Endpoint	Method	Purpose
/api/token/generate	POST	Create patient token
/api/token/update-status	POST	Update token status
/api/queue	GET	Fetch queue data
/api/sms	POST	Send SMS notification
/api/analytics	GET	Get analytics data
/api/auth/[...nextauth]	GET/POST	Authentication
User Roles & Permissions
Role	Can Do	Cannot Do
Patient	Register, view queue	Access dashboard
Receptionist	Call patients, skip	Modify doctor notes
Doctor	View patients, add notes	Manage queue
Admin	View all data, analytics	(Read-only access)
Workflow Example
Key Integrations
Firebase Realtime Database
Live queue updates
No page refresh needed
Automatic synchronization
Twilio SMS
Token generation alerts
Status notifications
Failed message tracking
NextAuth.js
Secure login
Session management
Role-based protection
What's Included
✅ 60+ Source Files with complete code
✅ 5,000+ Lines of Code
✅ 16 Documentation Files
✅ Docker Containerization
✅ Demo Data & Credentials
✅ Setup Scripts (Windows, Mac, Linux)
✅ TypeScript Types for type safety
✅ Error Handling & Validation
✅ Security Best Practices
✅ Performance Optimization

Deployment Options
Platform	Time	Cost
Vercel	5 min	Free tier
Docker + VPS	15 min	$5-20/mo
AWS EC2	30 min	$3-10/mo
Google Cloud Run	20 min	Free tier
Azure	25 min	Free tier
Use Cases
✅ Small rural hospitals
✅ Clinics with multiple departments
✅ Walk-in patient centers
✅ Urgent care facilities
✅ Multi-location hospital chains

Key Benefits
🎯 Efficiency - Automated queue management
🎯 Real-time - Live updates across all devices
🎯 Data-driven - Analytics for decision making
🎯 Patient Friendly - SMS notifications, queue visibility
🎯 Scalable - Grows with your hospital
🎯 Secure - Role-based access, encrypted passwords
🎯 Cost-effective - Open-source tech stack

Status
✅ 100% Complete - Fully functional, production-ready
✅ Tested - All features working
✅ Documented - 16 comprehensive guides
✅ Secure - Industry-standard security
✅ Scalable - Ready for growth

