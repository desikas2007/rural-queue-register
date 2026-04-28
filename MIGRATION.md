# Prisma Migration Guide

## Initial Setup

1. Generate Prisma Client:
   ```bash
   npm run prisma:generate
   ```

2. Create initial migration:
   ```bash
   npm run prisma:migrate
   ```
   
   When prompted, name it something like `initial_setup`

3. Run migrations:
   ```bash
   npm run prisma:migrate
   ```

4. View database (optional):
   ```bash
   npm run prisma:studio
   ```

## Database Structure

The Prisma schema includes the following models:

- **User**: System users (doctors, receptionists, admins, patients)
- **Patient**: Patient demographic information
- **Token**: Generated tokens for queue management
- **QueueEntry**: Queue entries linking tokens and patients
- **ConsultationLog**: Doctor consultation records
- **Analytics**: Daily statistics and metrics
- **SmsNotification**: SMS notification tracking

## Important Enums

- **Role**: PATIENT, RECEPTIONIST, DOCTOR, ADMIN
- **TokenStatus**: WAITING, CALLED, CONSULTING, COMPLETED, SKIPPED, NO_SHOW
- **Department**: GENERAL, PEDIATRICS, ORTHOPEDICS, CARDIOLOGY, DERMATOLOGY
- **ReferralType**: NONE, LAB, PHARMACY, SPECIALIST

## Useful Prisma Commands

```bash
# Generate Prisma Client
npm run prisma:generate

# Create migration
npx prisma migrate dev --name migration_name

# View database GUI
npm run prisma:studio

# Reset database (development only)
npx prisma migrate reset

# Deploy migrations (production)
npx prisma migrate deploy
```
