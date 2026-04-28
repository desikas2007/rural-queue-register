# Quick Start Guide - Rural Queue Register

## 🚀 Get Running in 5 Minutes

### Option 1: Local Development

```bash
# 1. Navigate to project
cd rural-queue-register

# 2. Install dependencies
npm install

# 3. Setup environment variables
cp .env.example .env.local
# Edit .env.local with your credentials

# 4. Setup database
npm run prisma:generate
npm run prisma:migrate

# 5. Seed demo data (optional)
npm run seed

# 6. Start development server
npm run dev
```

Open http://localhost:3000 in your browser.

### Option 2: Docker Setup

```bash
# 1. Copy environment file
cp .env.docker .env

# 2. Start with Docker Compose
docker-compose up

# 3. Migrations run automatically
```

Open http://localhost:3000 in your browser.

## 📋 Demo Credentials

After seeding, use these credentials:

**Doctor:**
- Email: doctor@rural-queue.local
- Password: password
- Access: Doctor Console

**Receptionist:**
- Email: receptionist@rural-queue.local
- Password: password
- Access: Receptionist Dashboard

**Admin:**
- Email: admin@rural-queue.local
- Password: password
- Access: Admin Dashboard

## 🎯 Test the System

### 1. Patient Registration
- Go to http://localhost:3000/register
- Fill the form and submit
- Receive token number
- Check SMS (Twilio will log to console in dev)

### 2. View Queue Display
- Go to http://localhost:3000/queue-display
- See live queue updates (powered by Firebase)
- Switch between departments

### 3. Staff Login
- Go to http://localhost:3000/login
- Use demo credentials above
- View respective dashboards

### 4. Receptionist Actions
- View queue in dashboard
- Click "Call Next" to update token status
- See real-time updates

### 5. Doctor Console
- View current patient
- Mark as complete
- Add referrals

### 6. Admin Analytics
- View analytics dashboard
- See charts and statistics
- Department-wise metrics

## 📚 Documentation

| Document | Purpose |
|----------|---------|
| [README.md](README.md) | Full project overview & setup |
| [API.md](API.md) | API endpoints documentation |
| [DEPLOYMENT.md](DEPLOYMENT.md) | Production deployment guide |
| [TESTING.md](TESTING.md) | Testing & QA guide |
| [BEST_PRACTICES.md](BEST_PRACTICES.md) | Code quality & troubleshooting |
| [MIGRATION.md](MIGRATION.md) | Database migration help |

## 🔧 Common Commands

```bash
# Development
npm run dev              # Start dev server
npm run build            # Build for production
npm start                # Run production build

# Database
npm run prisma:generate  # Generate Prisma client
npm run prisma:migrate   # Run migrations
npm run prisma:studio    # Open Prisma Studio UI
npm run seed             # Seed demo data

# Linting & Formatting
npm run lint             # Run ESLint
npm test                 # Run tests

# Docker
docker-compose up        # Start services
docker-compose down      # Stop services
docker-compose logs -f   # View logs
```

## ⚙️ Environment Setup

### Required for Full Functionality

1. **PostgreSQL** (Database)
   - Download: https://www.postgresql.org/download/
   - Default: localhost:5432

2. **Firebase** (Real-time Updates)
   - Create project: https://console.firebase.google.com
   - Enable Realtime Database
   - Get credentials from Settings > Project Settings

3. **Twilio** (SMS Notifications)
   - Sign up: https://www.twilio.com/
   - Get Account SID, Auth Token, Phone Number
   - https://www.twilio.com/console

### Optional

- **Redis**: For caching (Docker included)
- **Sentry**: For error tracking
- **SendGrid**: For email notifications

## 🛠️ Troubleshooting

### "port 3000 already in use"
```bash
# Find process using port 3000
lsof -i :3000

# Kill process
kill -9 <PID>

# Or use different port
PORT=3001 npm run dev
```

### "Database connection failed"
```bash
# Check PostgreSQL is running
psql postgresql://localhost:5432

# Update DATABASE_URL in .env.local
# Format: postgresql://username:password@host:port/database
```

### "Firebase connection failed"
```bash
# Verify credentials in .env.local
# Check Firebase project has Realtime Database enabled
# Verify database URL format
```

### "SMS not sending"
```bash
# Check Twilio credentials
# Verify phone number format (include country code: +1...)
# Check account has credits
```

## 📊 Project Structure Summary

```
rural-queue-register/
├── prisma/              # Database schema & migrations
├── public/              # Static files
├── src/
│   ├── app/             # Next.js pages
│   ├── api/             # API routes
│   ├── components/      # React components
│   ├── hooks/           # Custom hooks
│   ├── lib/             # Utilities
│   ├── types/           # TypeScript types
│   └── middleware.ts    # Auth middleware
├── README.md            # Full documentation
├── package.json         # Dependencies
├── tsconfig.json        # TypeScript config
├── tailwind.config.ts   # Tailwind config
└── .env.local          # Environment variables
```

## 🎨 Features Overview

✅ **Patient Registration** - Quick token generation
✅ **Real-time Queue** - Firebase powered live updates
✅ **SMS Notifications** - Twilio integration
✅ **Role-based Access** - Receptionist, Doctor, Admin
✅ **Analytics Dashboard** - Charts & statistics
✅ **Consultation Tracking** - Doctor notes & referrals
✅ **Mobile Responsive** - Works on all devices
✅ **Production Ready** - Docker, CI/CD support

## 🚦 Next Steps

1. **Customize Branding**
   - Update app name in components
   - Add hospital logo to `public/`
   - Modify colors in `tailwind.config.ts`

2. **Configure Departments**
   - Edit enum in `prisma/schema.prisma`
   - Update select options in components

3. **Add Business Logic**
   - Implement appointment scheduling
   - Add payment processing
   - Setup email notifications

4. **Deploy to Production**
   - Follow [DEPLOYMENT.md](DEPLOYMENT.md)
   - Setup monitoring & backups
   - Configure SSL certificate

## 📞 Support

For issues or questions:
1. Check [BEST_PRACTICES.md](BEST_PRACTICES.md) troubleshooting section
2. Review API documentation in [API.md](API.md)
3. Check test files for usage examples
4. Review commit history for code examples

## 📄 License

MIT License - See LICENSE file

## 🎉 You're All Set!

Your rural hospital queue management system is ready to use. Start with the demo credentials and explore the features. Good luck! 🏥
