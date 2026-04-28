# Best Practices & Troubleshooting Guide

## Code Quality

### File Organization
```
src/
├── app/         # Pages and layouts
├── api/         # API routes
├── components/  # React components
├── hooks/       # Custom hooks
├── lib/         # Utilities and libraries
├── types/       # TypeScript types
└── middleware.ts # Middleware
```

### Naming Conventions

- **Files**: kebab-case (my-component.tsx)
- **Components**: PascalCase (MyComponent)
- **Functions**: camelCase (myFunction)
- **Constants**: UPPER_SNAKE_CASE (MY_CONSTANT)
- **Database Models**: PascalCase (User, Token)

### TypeScript Best Practices

```typescript
// Good
interface IUser {
  id: string;
  name: string;
  email: string;
}

const getUser = (id: string): IUser | null => {
  // implementation
};

// Avoid
type user = any;
const getUser = (id) => {
  // no type info
};
```

## Database Best Practices

### Indexing Strategy

```prisma
model Token {
  id            String       @id @default(cuid())
  tokenNumber   Int          @unique  // Indexed
  userId        String
  status        TokenStatus  @default(WAITING)
  generatedAt   DateTime     @default(now())
  
  @@index([userId])      // Foreign key
  @@index([status])      // Often filtered
  @@index([generatedAt]) // For time-based queries
}
```

### Query Optimization

```typescript
// Good - specific fields
const users = await prisma.user.findMany({
  select: {
    id: true,
    name: true,
    email: true,
  },
  where: { isActive: true },
  take: 50,
});

// Avoid - fetch all data
const users = await prisma.user.findMany();
```

### Connection Pooling

For production, use PgBouncer:

```bash
sudo apt-get install pgbouncer
```

Configure `/etc/pgbouncer/pgbouncer.ini`:

```ini
[databases]
rural_queue_db = host=localhost port=5432 dbname=rural_queue_db

[pgbouncer]
pool_mode = transaction
max_client_conn = 1000
default_pool_size = 25
```

## API Design

### RESTful Conventions

```typescript
// GET - Retrieve
GET /api/queue              // List
GET /api/queue/123          // Single item

// POST - Create
POST /api/token/generate

// PUT - Update (full)
PUT /api/token/123

// PATCH - Partial update
PATCH /api/token/123/status

// DELETE - Remove
DELETE /api/token/123
```

### Response Format

```typescript
// Success
{
  success: true,
  data: {},
  message?: "Optional message"
}

// Error
{
  success: false,
  error: "Error message",
  code?: "ERROR_CODE"
}
```

### Error Handling

```typescript
import { NextResponse } from "next/server";

export async function POST(request: NextRequest) {
  try {
    const data = await request.json();
    
    if (!data.required_field) {
      return NextResponse.json(
        { success: false, error: "Missing required field" },
        { status: 400 }
      );
    }
    
    // Process request
    
    return NextResponse.json({ success: true, data });
  } catch (error) {
    console.error("Error:", error);
    return NextResponse.json(
      { success: false, error: "Internal server error" },
      { status: 500 }
    );
  }
}
```

## Frontend Best Practices

### Component Structure

```typescript
"use client";

import React, { useState, useEffect } from "react";
import { useSession } from "next-auth/react";
import Button from "@/components/ui/Button";

interface Props {
  id: string;
  onSuccess?: () => void;
}

export default function MyComponent({ id, onSuccess }: Props) {
  const { data: session } = useSession();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    // Setup effect
  }, [id]);

  const handleAction = async () => {
    try {
      setLoading(true);
      // API call
      onSuccess?.();
    } catch (err) {
      setError(err instanceof Error ? err.message : "Unknown error");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div>
      {error && <p className="text-danger-500">{error}</p>}
      <Button onClick={handleAction} loading={loading}>
        Action
      </Button>
    </div>
  );
}
```

### Hook Guidelines

```typescript
// Good custom hook
export const useQueue = () => {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const fetchQueue = useCallback(async () => {
    try {
      setLoading(true);
      const response = await fetch("/api/queue");
      const result = await response.json();
      setData(result.data);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Error");
    } finally {
      setLoading(false);
    }
  }, []);

  return { data, loading, error, fetchQueue };
};
```

## Authentication & Security

### Password Requirements

```typescript
const validatePassword = (password: string): boolean => {
  return (
    password.length >= 8 &&
    /[A-Z]/.test(password) &&        // Uppercase
    /[a-z]/.test(password) &&        // Lowercase
    /[0-9]/.test(password) &&        // Number
    /[!@#$%^&*]/.test(password)      // Special char
  );
};
```

### Session Management

```typescript
// Refresh session regularly
useEffect(() => {
  const interval = setInterval(() => {
    signIn("credentials", { redirect: false });
  }, 30 * 60 * 1000); // Every 30 minutes

  return () => clearInterval(interval);
}, []);
```

### CORS Configuration

```typescript
// pages/api/middleware.ts
export const middleware = (req: NextRequest) => {
  const response = NextResponse.next();
  
  response.headers.set("Access-Control-Allow-Origin", process.env.ALLOWED_ORIGINS || "*");
  response.headers.set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE");
  response.headers.set("Access-Control-Allow-Headers", "Content-Type, Authorization");
  
  return response;
};
```

## Performance Optimization

### Image Optimization

```typescript
import Image from "next/image";

export default function MyComponent() {
  return (
    <Image
      src="/hospital.jpg"
      alt="Hospital"
      width={1200}
      height={600}
      priority={true}
      placeholder="blur"
    />
  );
}
```

### Code Splitting

```typescript
import dynamic from "next/dynamic";

const Analytics = dynamic(() => import("@/components/AnalyticsChart"), {
  loading: () => <div>Loading...</div>,
});

export default function AdminPage() {
  return <Analytics />;
}
```

### Memoization

```typescript
import { useMemo, useCallback } from "react";

export default function MyComponent({ data }) {
  const processedData = useMemo(() => {
    return expensiveCalculation(data);
  }, [data]);

  const handleClick = useCallback(() => {
    // Handle click
  }, []);

  return <div>{processedData}</div>;
}
```

## Troubleshooting Guide

### "Module not found" Error

```bash
# Clear Next.js cache
rm -rf .next

# Reinstall dependencies
rm -rf node_modules package-lock.json
npm install

# Try again
npm run dev
```

### Database Connection Issues

```bash
# Test connection
psql postgresql://user:password@localhost:5432/rural_queue_db

# Check Prisma connection
npx prisma validate

# Reset migrations
npx prisma migrate reset
```

### Firebase Realtime Updates Not Working

```typescript
// Add error handling
const queueRef = ref(firebaseDb, `queue/${department}`);

onValue(
  queueRef,
  (snapshot) => {
    // Handle data
  },
  (error) => {
    console.error("Firebase error:", error);
    // Implement retry logic
  }
);
```

### Twilio SMS Not Sending

```bash
# Verify credentials
echo $TWILIO_ACCOUNT_SID
echo $TWILIO_AUTH_TOKEN
echo $TWILIO_PHONE_NUMBER

# Test SMS directly
curl -X POST https://api.twilio.com/2010-04-01/Accounts/$ACCOUNT_SID/Messages.json \
  -d "To=+1234567890" \
  -d "From=$TWILIO_PHONE_NUMBER" \
  -d "Body=Test message" \
  -u "$ACCOUNT_SID:$AUTH_TOKEN"
```

### Session Issues

```bash
# Clear cookies in browser DevTools
# Check NEXTAUTH_SECRET is set
echo $NEXTAUTH_SECRET | wc -c  # Should be >= 32

# Verify JWT token
npm install jsonwebtoken
node -e "console.log(require('jsonwebtoken').verify('token', 'secret'))"
```

### Memory Leaks in Development

```typescript
// Always clean up subscriptions
useEffect(() => {
  const subscription = observable.subscribe(data => {
    // Handle data
  });

  return () => subscription.unsubscribe(); // Cleanup
}, []);
```

## Monitoring & Logging

### Application Logging

```typescript
// src/lib/logger.ts
export const logger = {
  info: (message: string, data?: any) => {
    console.log(`[INFO] ${new Date().toISOString()}: ${message}`, data);
  },
  error: (message: string, error?: any) => {
    console.error(`[ERROR] ${new Date().toISOString()}: ${message}`, error);
  },
  warn: (message: string, data?: any) => {
    console.warn(`[WARN] ${new Date().toISOString()}: ${message}`, data);
  },
};
```

### Monitoring API Performance

```typescript
// Middleware to log API calls
export async function middleware(req: NextRequest) {
  const start = Date.now();
  
  // Your logic here
  
  const duration = Date.now() - start;
  console.log(`${req.method} ${req.nextUrl.pathname} - ${duration}ms`);
  
  return NextResponse.next();
}
```

## Backup & Recovery

### Database Backup

```bash
# Daily backup
0 2 * * * pg_dump rural_queue_db | gzip > /backups/db-$(date +\%Y\%m\%d).sql.gz

# Restore
gunzip < /backups/db-20260423.sql.gz | psql rural_queue_db
```

### Firebase Backup

Enable in Firebase Console:
- Settings > Backup & Restore
- Schedule: Daily/Weekly
- Retention: 30 days
