# Deployment Guide

## Prerequisites

- Node.js 18+
- PostgreSQL database
- Firebase account
- Twilio account
- GitHub account (for Vercel deployment)

## Deployment Options

### 1. Vercel (Recommended for Next.js)

#### Steps:

1. **Push to GitHub**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/yourusername/rural-queue-register.git
   git push -u origin main
   ```

2. **Connect to Vercel**
   - Go to https://vercel.com/new
   - Import your GitHub repository
   - Select Next.js framework

3. **Add Environment Variables**
   - In Vercel dashboard, go to Settings > Environment Variables
   - Add all variables from .env.local
   - Make sure NEXTAUTH_URL is set to your Vercel domain

4. **Deploy**
   - Vercel will automatically deploy on git push
   - Custom domain: Settings > Domains

### 2. Docker + Docker Compose

#### Create docker-compose.yml:

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:15
    environment:
      POSTGRES_USER: rural_user
      POSTGRES_PASSWORD: rural_password
      POSTGRES_DB: rural_queue_db
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      DATABASE_URL: "postgresql://rural_user:rural_password@postgres:5432/rural_queue_db"
      NEXTAUTH_SECRET: ${NEXTAUTH_SECRET}
      NEXTAUTH_URL: ${NEXTAUTH_URL}
      NEXT_PUBLIC_FIREBASE_API_KEY: ${NEXT_PUBLIC_FIREBASE_API_KEY}
      NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN: ${NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN}
      NEXT_PUBLIC_FIREBASE_PROJECT_ID: ${NEXT_PUBLIC_FIREBASE_PROJECT_ID}
      NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET: ${NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET}
      NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID: ${NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID}
      NEXT_PUBLIC_FIREBASE_APP_ID: ${NEXT_PUBLIC_FIREBASE_APP_ID}
      FIREBASE_DATABASE_URL: ${FIREBASE_DATABASE_URL}
      TWILIO_ACCOUNT_SID: ${TWILIO_ACCOUNT_SID}
      TWILIO_AUTH_TOKEN: ${TWILIO_AUTH_TOKEN}
      TWILIO_PHONE_NUMBER: ${TWILIO_PHONE_NUMBER}
    depends_on:
      - postgres
    command: >
      sh -c "npm run prisma:migrate && npm start"

volumes:
  postgres_data:
```

#### Deploy with Docker:

```bash
# Build and run
docker-compose up -d

# Check logs
docker-compose logs -f app

# Stop
docker-compose down
```

### 3. AWS EC2

#### Steps:

1. **Launch EC2 Instance**
   - Amazon Linux 2 or Ubuntu 20.04
   - t3.medium or larger
   - Security group: Allow 80, 443, 3000

2. **Install Dependencies**
   ```bash
   sudo yum update -y  # Amazon Linux
   sudo apt update     # Ubuntu
   
   # Install Node.js
   curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
   sudo yum install -y nodejs
   
   # Install PostgreSQL client
   sudo yum install -y postgresql15
   ```

3. **Clone and Setup**
   ```bash
   cd /opt
   sudo git clone https://github.com/yourusername/rural-queue-register.git
   cd rural-queue-register
   sudo npm install
   ```

4. **Configure PM2**
   ```bash
   sudo npm install -g pm2
   pm2 start "npm run start" --name rural-queue
   pm2 startup
   pm2 save
   ```

5. **Setup Nginx Reverse Proxy**
   ```bash
   sudo yum install -y nginx
   ```
   
   Create `/etc/nginx/conf.d/rural-queue.conf`:
   ```nginx
   server {
       listen 80;
       server_name your-domain.com;
       
       location / {
           proxy_pass http://localhost:3000;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection 'upgrade';
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }
   ```
   
   ```bash
   sudo systemctl restart nginx
   ```

### 4. Google Cloud Run

```bash
# Install gcloud CLI
# https://cloud.google.com/sdk/docs/install

# Authenticate
gcloud auth login

# Deploy
gcloud run deploy rural-queue-register \
  --source . \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --set-env-vars DATABASE_URL="your_database_url",NEXTAUTH_SECRET="your_secret"
```

## Production Checklist

- [ ] Set NEXTAUTH_SECRET (min 32 random characters)
- [ ] Set NODE_ENV to "production"
- [ ] Enable HTTPS/SSL certificate
- [ ] Configure database backups
- [ ] Set up monitoring and logging
- [ ] Enable rate limiting on APIs
- [ ] Configure CORS for allowed domains
- [ ] Setup error tracking (Sentry)
- [ ] Configure email service for alerts
- [ ] Test all authentication flows
- [ ] Verify SMS sending (Twilio)
- [ ] Test database migrations on production
- [ ] Setup automated backups
- [ ] Configure CDN for static assets
- [ ] Enable gzip compression
- [ ] Setup health check endpoints

## Performance Optimization for Production

1. **Enable Output Standalone**
   Add to `next.config.ts`:
   ```typescript
   output: 'standalone',
   ```

2. **Configure Caching Headers**
   Create `vercel.json`:
   ```json
   {
     "headers": [
       {
         "source": "/static/(.*)",
         "headers": [
           {
             "key": "Cache-Control",
             "value": "public, max-age=31536000, immutable"
           }
         ]
       }
     ]
   }
   ```

3. **Enable Database Connection Pooling**
   Use PgBouncer for PostgreSQL:
   ```bash
   sudo yum install pgbouncer
   ```

4. **Setup Redis for Caching** (Optional)
   ```bash
   docker run -d -p 6379:6379 redis:latest
   ```

## Monitoring

### Setup Application Monitoring

1. **Sentry (Error Tracking)**
   ```bash
   npm install @sentry/nextjs
   ```
   
   Add to `_app.tsx` or `layout.tsx`:
   ```typescript
   import * as Sentry from "@sentry/nextjs";
   
   Sentry.init({
     dsn: "your_sentry_dsn",
     environment: process.env.NODE_ENV,
   });
   ```

2. **LogRocket (Session Replay)**
   ```bash
   npm install logrocket
   ```

3. **Google Analytics**
   Add to `_document.tsx`:
   ```html
   <script async src="https://www.googletagmanager.com/gtag/js?id=GA_ID"></script>
   ```

## Backup Strategy

1. **Database Backups**
   ```bash
   # Daily automated backups
   0 2 * * * pg_dump rural_queue_db | gzip > /backups/db-$(date +\%Y\%m\%d).sql.gz
   ```

2. **Firebase Backups**
   - Enable automatic backups in Firebase console
   - Setup weekly exports to Cloud Storage

## Scaling Considerations

- Use database read replicas for high traffic
- Implement Redis caching layer
- Use CDN for static assets
- Implement queue worker for heavy operations
- Consider microservices for each department
- Setup load balancing

## Troubleshooting Production Issues

### High Database Connections
```bash
# Check connections
psql -U user -d rural_queue_db -c "SELECT count(*) FROM pg_stat_activity;"

# Implement connection pooling with PgBouncer
```

### Memory Leaks
```bash
# Monitor memory usage
pm2 monit

# Restart if memory exceeds threshold
pm2 restart rural-queue --max-memory-restart 500M
```

### SSL/TLS Certificate
```bash
# Using Let's Encrypt with Certbot
sudo certbot certonly --nginx -d your-domain.com
```

## Support & Maintenance

- Setup uptime monitoring (UptimeRobot, Pingdom)
- Configure automated alerts for downtime
- Implement health check endpoint
- Setup log aggregation (CloudWatch, Loggly)
