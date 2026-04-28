
# Rural Hospital Patient Queue Management System - Complete Setup Guide

## Project Overview

A full-stack web application for managing patient queues in rural hospitals with real-time updates, SMS notifications, and role-based access control.

## Tech Stack

- **Frontend**: Next.js 14 (App Router), React 18, TypeScript, Tailwind CSS
- **Backend**: Next.js API Routes, Node.js
- **Database**: PostgreSQL (Prisma ORM)
- **Real-time**: Firebase Realtime Database
- **SMS**: Twilio
- **Authentication**: NextAuth.js
- **Charts**: Recharts

## Installation

### 1. Prerequisites

- Node.js 18+ and npm/yarn
- PostgreSQL database
- Firebase account with Realtime Database
- Twilio account
- Git

### 2. Installation Steps

```bash
# Navigate to project directory
cd rural-queue-register

# Install dependencies
npm install

# Install additional peer dependencies if needed
npm install bcrypt

# Generate Prisma Client
npm run prisma:generate

# Create .env.local file with your credentials (see Environment Variables section)

# Run database migrations
npm run prisma:migrate

# Start development server
npm run dev
```

## Environment Variables

Create a `.env.local` file in the root directory:

```env
# PostgreSQL Database
DATABASE_URL="postgresql://username:password@localhost:5432/rural_queue_db"

# NextAuth Configuration
NEXTAUTH_SECRET="generate-a-random-string-min-32-characters"
NEXTAUTH_URL="http://localhost:3000"

# Firebase Configuration
NEXT_PUBLIC_FIREBASE_API_KEY="your_api_key"
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN="your_project.firebaseapp.com"
NEXT_PUBLIC_FIREBASE_PROJECT_ID="your_project_id"
NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET="your_project.appspot.com"
NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID="your_sender_id"
NEXT_PUBLIC_FIREBASE_APP_ID="your_app_id"
FIREBASE_DATABASE_URL="https://your_project.firebaseio.com"

# Twilio Configuration
TWILIO_ACCOUNT_SID="your_account_sid"
TWILIO_AUTH_TOKEN="your_auth_token"
TWILIO_PHONE_NUMBER="+1234567890"

# Application
NEXT_PUBLIC_APP_NAME="Rural Queue Register"
NODE_ENV="development"
```

## Project Structure

```
src/
├── app/                    # Next.js App Router pages
│   ├── (auth)/            # Auth group
│   │   └── login/
│   ├── (dashboard)/       # Dashboard group
│   │   ├── admin/
│   │   ├── doctor/
│   │   └── receptionist/
│   ├── register/          # Patient registration
│   ├── queue-display/     # Public queue display
│   └── api/               # API routes
│       ├── auth/          # Authentication
│       ├── token/         # Token generation & updates
│       ├── queue/         # Queue data
│       ├── sms/           # SMS notifications
│       └── analytics/     # Analytics data
├── components/            # Reusable components
│   ├── ui/               # UI components (Button, Input, Badge)
│   └── Feature components # PatientForm, QueueBoard, etc.
├── lib/                   # Utility libraries
│   ├── prisma.ts         # Prisma client
│   ├── firebase.ts       # Firebase setup
│   ├── twilio.ts         # Twilio setup
│   └── auth.ts           # NextAuth configuration
├── hooks/                 # Custom React hooks
│   ├── useQueue.ts       # Queue operations
│   └── useRealtimeQueue.ts # Real-time queue updates
├── types/                 # TypeScript types
└── middleware.ts          # NextAuth middleware
```

## Database Setup

### 1. Create PostgreSQL Database

```bash
# Using psql
createdb rural_queue_db

# Or using your PostgreSQL client
```

### 2. Generate Prisma Migrations

```bash
npm run prisma:generate
npm run prisma:migrate
```

### 3. Seed Demo Data (Optional)

Create a `prisma/seed.ts` file:

```typescript
import { prisma } from '@/lib/prisma';
import bcrypt from 'bcrypt';

async function main() {
  // Create demo users
  const hashedPassword = await bcrypt.hash('password', 10);

  await prisma.user.upsert({
    where: { email: 'doctor@rural-queue.local' },
    update: {},
    create: {
      email: 'doctor@rural-queue.local',
      password: hashedPassword,
      name: 'Dr. John Doe',
      phone: '+1234567890',
      role: 'DOCTOR',
      department: 'GENERAL',
    },
  });

  await prisma.user.upsert({
    where: { email: 'receptionist@rural-queue.local' },
    update: {},
    create: {
      email: 'receptionist@rural-queue.local',
      password: hashedPassword,
      name: 'Jane Smith',
      phone: '+0987654321',
      role: 'RECEPTIONIST',
    },
  });

  console.log('Demo data seeded successfully');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
```

Run: `npx ts-node prisma/seed.ts`

## Firebase Setup

1. Go to Firebase Console (https://console.firebase.google.com/)
2. Create a new project
3. Enable Realtime Database
4. Get your credentials from Project Settings
5. Add them to `.env.local`

## Twilio Setup

1. Sign up at https://www.twilio.com/
2. Get your Account SID and Auth Token
3. Provision a phone number
4. Add credentials to `.env.local`

## Key Features

### 1. Patient Registration
- Quick registration with automatic token generation
- SMS notification on token creation
- Department selection
- Real-time queue updates via Firebase

### 2. Queue Management
- Receptionist can call next patient
- Skip/No-show functionality
- Real-time queue display
- Patient wait time tracking

### 3. Doctor Console
- View current patient details
- Mark consultations as complete
- Add referrals (Lab, Pharmacy, Specialist)
- Consultation notes and diagnosis

### 4. Admin Dashboard
- Analytics and reporting
- Department-wise statistics
- Wait time analysis
- Peak hour monitoring
- Performance metrics

### 5. Authentication
- Role-based access control (Patient, Receptionist, Doctor, Admin)
- NextAuth.js with JWT tokens
- Secure session management

## Available Routes

```
Public Routes:
- GET  /                 # Homepage
- GET  /register        # Patient registration
- GET  /queue-display   # Public queue display
- GET  /login           # Login page

API Routes:
- POST /api/token/generate          # Generate patient token
- POST /api/token/update-status     # Update token status
- GET  /api/queue                   # Get queue data
- POST /api/sms                     # Send SMS
- GET  /api/analytics               # Get analytics

Protected Routes (Require Authentication):
- GET  /receptionist                # Receptionist dashboard
- GET  /doctor                      # Doctor console
- GET  /admin                       # Admin dashboard
- POST /api/auth/signin             # Sign in
- GET  /api/auth/signout            # Sign out
```

## Development

### Running Development Server

```bash
npm run dev
```

Server runs at http://localhost:3000

### Building for Production

```bash
npm run build
npm start
```

### Database Management

```bash
# Open Prisma Studio
npm run prisma:studio

# Create new migration
npm run prisma:migrate

# Generate Prisma Client
npm run prisma:generate
```

## API Examples

### Generate Token

```bash
curl -X POST http://localhost:3000/api/token/generate \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Patient",
    "phone": "+1234567890",
    "age": 35,
    "gender": "male",
    "department": "GENERAL"
  }'
```

### Update Token Status

```bash
curl -X POST http://localhost:3000/api/token/update-status \
  -H "Content-Type: application/json" \
  -d '{
    "tokenId": "token-id-here",
    "status": "CALLED"
  }'
```

### Get Queue

```bash
curl http://localhost:3000/api/queue?department=GENERAL
```

## Troubleshooting

### Database Connection Issues
- Verify PostgreSQL is running
- Check DATABASE_URL in .env.local
- Run `npm run prisma:migrate`

### Firebase Issues
- Verify Firebase credentials
- Check database URL format
- Enable Realtime Database in Firebase console

### Twilio SMS Not Working
- Verify phone number format (+1 prefix)
- Check Twilio account has credits
- Verify TWILIO_ACCOUNT_SID and TWILIO_AUTH_TOKEN

### Authentication Issues
- Ensure NEXTAUTH_SECRET is set (min 32 chars)
- Check NEXTAUTH_URL matches your domain
- Clear cookies and try again

## Performance Optimization

1. **Database Indexing**: Prisma schema includes indexes on frequently queried fields
2. **Real-time Updates**: Firebase Realtime Database for instant queue updates
3. **Caching**: Implement Redis for session caching (optional)
4. **Image Optimization**: Use Next.js Image component
5. **API Rate Limiting**: Implement middleware for rate limiting

## Security Measures

1. **Authentication**: NextAuth.js with JWT tokens
2. **Authorization**: Role-based access control in middleware
3. **Password Hashing**: bcrypt for secure password storage
4. **Environment Variables**: Sensitive data in .env.local
5. **HTTPS**: Enable in production
6. **CORS**: Configure as needed
7. **SQL Injection**: Prevented by Prisma ORM

## Deployment

### Vercel (Recommended for Next.js)

```bash
npm install -g vercel
vercel login
vercel --prod
```

### Docker

Create `Dockerfile`:

```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build
EXPOSE 3000
CMD ["npm", "start"]
```

### Environment Variables in Production

Set in your hosting platform's dashboard:
- DATABASE_URL
- NEXTAUTH_SECRET
- Firebase credentials
- Twilio credentials

## Support & Contributing

For issues or contributions, please follow the standard GitHub workflow.

## License

MIT License - See LICENSE file for details

## Contact

For support, contact: support@rural-queue-register.local
running:1. npm install                    # Install dependencies
2. cp .env.example .env.local    # Create env file
   # Edit .env.local with your credentials
3. npm run prisma:migrate        # Setup database
4. npm run seed                  # Add demo data (optional)
5. npm run dev                   # Start server
6. Open: http://localhost:3000

🎯 ENTRY POINTS (Choose Your Path)
👀 Just Want to Look Around?
→ Read: 00-READ-ME-FIRST.md (2 min)

⚡ Want to Get Started Immediately?
→ Read: START_HERE.md then QUICKSTART.md (10 min)

🔧 Need Full Technical Details?
→ Read: README.md then ARCHITECTURE.md (30 min)

🚀 Ready to Deploy?
→ Follow: SETUP_CHECKLIST.md then DEPLOYMENT.md

