# 🚀 Installation & Setup Checklist

**Project**: Rural Hospital Patient Queue Management System
**Status**: ✅ Complete & Ready to Deploy
**Last Updated**: April 23, 2026

---

## 📋 Pre-Installation Checklist

Before you start, ensure you have:

- [ ] Node.js 18+ installed (`node --version`)
- [ ] npm or yarn installed (`npm --version`)
- [ ] PostgreSQL server running locally or remote URL
- [ ] Firebase account with Realtime Database
- [ ] Twilio account with verified phone number
- [ ] Git installed (optional, for version control)
- [ ] Text editor or IDE (VS Code recommended)
- [ ] 30 minutes of time
- [ ] All credentials ready (see credentials checklist below)

---

## 🔑 Credentials Checklist

Gather these before installation:

### PostgreSQL
- [ ] Database host (default: localhost)
- [ ] Database port (default: 5432)
- [ ] Database name (e.g., rural_queue_db)
- [ ] Database username (e.g., postgres)
- [ ] Database password
- [ ] Format: `postgresql://username:password@host:port/dbname`

### Firebase
- [ ] API Key
- [ ] Project ID
- [ ] Auth Domain
- [ ] Database URL (Realtime DB)
- [ ] Storage Bucket
- [ ] Messaging Sender ID
- [ ] App ID

### Twilio
- [ ] Account SID
- [ ] Auth Token
- [ ] Verified Phone Number (for SMS)

### NextAuth
- [ ] Generate secret: `openssl rand -base64 32` or use [this generator](https://generate-secret.vercel.app/)
- [ ] Minimum 32 characters required

---

## ⚙️ Step 1: Project Setup

### 1.1 Navigate to Project
```bash
cd rural-queue-register
```

### 1.2 Install Dependencies
```bash
npm install
```
- [ ] npm install completes without errors
- [ ] node_modules directory created
- [ ] package-lock.json updated

### 1.3 Verify Installation
```bash
npm list
```
- [ ] Shows 16+ production dependencies
- [ ] Shows 10+ development dependencies
- [ ] No error messages

---

## 🔐 Step 2: Environment Configuration

### 2.1 Create Environment File
```bash
cp .env.example .env.local
```
- [ ] .env.local file created in project root
- [ ] .gitignore includes .env.local

### 2.2 Configure Environment Variables

**Edit `.env.local` and add:**

#### Database (PostgreSQL)
```
DATABASE_URL="postgresql://user:password@localhost:5432/rural_queue_db"
```
- [ ] DATABASE_URL added
- [ ] Connection tested (below)

#### Authentication
```
NEXTAUTH_SECRET="your-generated-secret-here"
NEXTAUTH_URL="http://localhost:3000"
```
- [ ] NEXTAUTH_SECRET added (min 32 chars)
- [ ] NEXTAUTH_URL set to localhost:3000

#### Firebase
```
NEXT_PUBLIC_FIREBASE_API_KEY="your-api-key"
NEXT_PUBLIC_FIREBASE_PROJECT_ID="your-project-id"
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN="your-auth-domain"
NEXT_PUBLIC_FIREBASE_DATABASE_URL="https://your-db.firebaseio.com"
NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET="your-bucket"
NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID="your-sender-id"
NEXT_PUBLIC_FIREBASE_APP_ID="your-app-id"
```
- [ ] All Firebase variables added
- [ ] NEXT_PUBLIC_ prefix used for client-side vars

#### Twilio
```
TWILIO_ACCOUNT_SID="your-account-sid"
TWILIO_AUTH_TOKEN="your-auth-token"
TWILIO_PHONE_NUMBER="+1234567890"
```
- [ ] Twilio credentials added
- [ ] Phone number in E.164 format

### 2.3 Verify Environment File
```bash
cat .env.local
```
- [ ] All variables present
- [ ] No empty values
- [ ] Correct format for all URLs

---

## 🗄️ Step 3: Database Setup

### 3.1 Generate Prisma Client
```bash
npm run prisma:generate
```
- [ ] Prisma client generated
- [ ] No TypeScript errors
- [ ] .prisma folder created

### 3.2 Run Database Migrations
```bash
npm run prisma:migrate
```
- [ ] Migrations run successfully
- [ ] All 7 tables created:
  - [ ] User table
  - [ ] Patient table
  - [ ] Token table
  - [ ] QueueEntry table
  - [ ] ConsultationLog table
  - [ ] Analytics table
  - [ ] SmsNotification table

### 3.3 Verify Database Connection
```bash
npm run prisma:studio
```
- [ ] Opens Prisma Studio in browser
- [ ] Can see all tables
- [ ] No connection errors
- [ ] Close browser tab when done

### 3.4 Seed Demo Data (Optional)
```bash
npm run seed
```
- [ ] Seeding completes successfully
- [ ] 3 demo users created
- [ ] 2 demo patients created
- [ ] Demo credentials ready:
  - [ ] doctor@rural-queue.local / password
  - [ ] receptionist@rural-queue.local / password
  - [ ] admin@rural-queue.local / password

---

## ✨ Step 4: Firebase Setup

### 4.1 Verify Firebase Configuration
```bash
npm run dev
```
- [ ] Server starts without Firebase errors
- [ ] Can open http://localhost:3000

### 4.2 Create Firebase Database Rules (Optional)
- [ ] Log into Firebase Console
- [ ] Go to Realtime Database
- [ ] Set rules to allow authenticated reads/writes
- [ ] Publish rules

### 4.3 Test Firebase Connection
- [ ] Register a patient (token generation)
- [ ] Check Firebase console for queue data
- [ ] Verify real-time updates working

---

## 📱 Step 5: Twilio Setup

### 5.1 Configure Twilio
- [ ] Log into Twilio Console
- [ ] Get Account SID
- [ ] Get Auth Token
- [ ] Get verified phone number
- [ ] Add to .env.local

### 5.2 Test SMS
- [ ] Register patient with your phone number
- [ ] Check for SMS notification
- [ ] Verify token number in message

---

## 🧪 Step 6: Development Testing

### 6.1 Start Development Server
```bash
npm run dev
```
- [ ] Server starts on http://localhost:3000
- [ ] No console errors
- [ ] Hot reload working

### 6.2 Test Homepage
- [ ] Open http://localhost:3000
- [ ] Page loads without errors
- [ ] All sections visible
- [ ] No broken links

### 6.3 Test Registration
- [ ] Go to /register
- [ ] Fill patient form
- [ ] Submit
- [ ] See success message with token
- [ ] Check SMS received (if SMS configured)

### 6.4 Test Queue Display
- [ ] Go to /queue-display
- [ ] See registered patient in queue
- [ ] Department filter working
- [ ] Real-time updates working

### 6.5 Test Authentication
- [ ] Go to /login
- [ ] Try demo credentials
- [ ] Verify redirect to role-based dashboard

### 6.6 Test Doctor Role
- [ ] Login as doctor@rural-queue.local
- [ ] See doctor dashboard
- [ ] View queue
- [ ] See patient details

### 6.7 Test Receptionist Role
- [ ] Login as receptionist@rural-queue.local
- [ ] See receptionist dashboard
- [ ] Call next patient
- [ ] Verify status updated

### 6.8 Test Admin Role
- [ ] Login as admin@rural-queue.local
- [ ] See admin dashboard
- [ ] View analytics charts
- [ ] See statistics

---

## 🏗️ Step 7: Build for Production

### 7.1 Build Application
```bash
npm run build
```
- [ ] Build completes without errors
- [ ] .next folder created
- [ ] No TypeScript errors
- [ ] Output shows all pages built

### 7.2 Test Production Build
```bash
npm run start
```
- [ ] Server starts
- [ ] Application runs
- [ ] All features work
- [ ] No console errors

### 7.3 Stop Production Server
```bash
# Press Ctrl+C
```
- [ ] Server stops cleanly

---

## 🐳 Step 8: Docker Setup (Optional)

### 8.1 Build Docker Image
```bash
docker build -t rural-queue:latest .
```
- [ ] Image builds successfully
- [ ] No errors in output

### 8.2 Test Docker Container
```bash
docker run -p 3000:3000 --env-file .env.local rural-queue:latest
```
- [ ] Container starts
- [ ] Application accessible at http://localhost:3000
- [ ] All features work

### 8.3 Docker Compose (Multi-service)
```bash
docker-compose up
```
- [ ] PostgreSQL container starts
- [ ] Next.js container starts
- [ ] Both services connected
- [ ] Application works with Docker database

### 8.4 Stop Containers
```bash
docker-compose down
```
- [ ] Services stop cleanly
- [ ] Volumes preserved

---

## 📊 Step 9: Verification

### 9.1 Run Verification Script
```bash
./verify-installation.sh  # On Mac/Linux
.\verify-installation.bat # On Windows
```
- [ ] All files verified
- [ ] 60+ files present
- [ ] No missing files reported

### 9.2 Check Documentation
- [ ] [README.md](README.md) exists
- [ ] [QUICKSTART.md](QUICKSTART.md) exists
- [ ] [API.md](API.md) exists
- [ ] All 10 docs present

### 9.3 Database Backup
```bash
# Optional: Export database
pg_dump rural_queue_db > backup.sql
```
- [ ] Backup file created (if needed)

---

## 🎯 Final Checklist

### Deployment Ready?
- [ ] All credentials configured
- [ ] Database connected and seeded
- [ ] Firebase configured
- [ ] Twilio configured
- [ ] Development testing passed
- [ ] Build successful
- [ ] Documentation reviewed
- [ ] Docker ready (optional)

### Ready to Deploy?
- [ ] Choose deployment platform
- [ ] Review [DEPLOYMENT.md](DEPLOYMENT.md)
- [ ] Follow platform-specific steps
- [ ] Set production environment variables
- [ ] Enable HTTPS/SSL
- [ ] Configure domain
- [ ] Test production instance
- [ ] Monitor for errors

---

## 🚀 Deployment Options

### Option 1: Vercel (Easiest)
- Time: 5 minutes
- Cost: Free tier available
- Reference: [DEPLOYMENT.md](DEPLOYMENT.md) - Vercel section

### Option 2: Docker + VPS
- Time: 15 minutes
- Cost: $5-20/month
- Reference: [DEPLOYMENT.md](DEPLOYMENT.md) - Docker section

### Option 3: AWS EC2
- Time: 30 minutes
- Cost: $3-10/month
- Reference: [DEPLOYMENT.md](DEPLOYMENT.md) - AWS section

### Option 4: Google Cloud Run
- Time: 20 minutes
- Cost: Free tier available
- Reference: [DEPLOYMENT.md](DEPLOYMENT.md) - Google Cloud section

---

## 📞 Troubleshooting Quick Links

| Issue | Reference |
|-------|-----------|
| npm install fails | [BEST_PRACTICES.md](BEST_PRACTICES.md) - Troubleshooting |
| Database connection error | [BEST_PRACTICES.md](BEST_PRACTICES.md) - Database Issues |
| Firebase not working | [BEST_PRACTICES.md](BEST_PRACTICES.md) - Firebase Issues |
| SMS not sending | [BEST_PRACTICES.md](BEST_PRACTICES.md) - Twilio Issues |
| Build errors | [BEST_PRACTICES.md](BEST_PRACTICES.md) - Build Issues |
| Authentication fails | [BEST_PRACTICES.md](BEST_PRACTICES.md) - Auth Issues |

---

## 📝 Notes

- **First Time?** Follow this checklist step by step
- **Have Questions?** Check [README.md](README.md) or [BEST_PRACTICES.md](BEST_PRACTICES.md)
- **Need Help?** See Troubleshooting section above
- **Want More?** Read [DEPLOYMENT.md](DEPLOYMENT.md) for production setup

---

## ✅ Completion

Once all items are checked:

1. ✅ System is installed and configured
2. ✅ All tests passed
3. ✅ Ready for development or deployment
4. ✅ Documentation available
5. ✅ Support resources ready

**Congratulations! Your Rural Hospital Patient Queue Management System is ready! 🎉**

---

## 🔄 Post-Installation Maintenance

### Daily
- [ ] Monitor for errors in logs
- [ ] Check database performance
- [ ] Verify SMS delivery

### Weekly
- [ ] Review analytics
- [ ] Check for failed requests
- [ ] Backup database

### Monthly
- [ ] Update dependencies (npm update)
- [ ] Review security patches
- [ ] Performance optimization
- [ ] User feedback review

---

**Version**: 1.0.0
**Status**: Production Ready ✅
**Support**: Check documentation files for help

