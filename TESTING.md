# Testing & Quality Assurance Guide

## Unit Testing

### Setup Jest

```bash
npm install --save-dev jest @testing-library/react @testing-library/jest-dom
npx jest --init
```

### Example Test - Utils

Create `src/lib/__tests__/utils.test.ts`:

```typescript
import {
  calculateWaitTime,
  isValidEmail,
  isValidPhone,
  getStatusBadgeColor,
} from "@/lib/utils";

describe("Utility Functions", () => {
  describe("calculateWaitTime", () => {
    it("should calculate wait time in minutes", () => {
      const now = new Date();
      const fiftyMinutesAgo = new Date(now.getTime() - 50 * 60000);
      const waitTime = calculateWaitTime(fiftyMinutesAgo);
      expect(waitTime).toBe(50);
    });
  });

  describe("isValidEmail", () => {
    it("should validate correct email", () => {
      expect(isValidEmail("test@example.com")).toBe(true);
    });

    it("should reject invalid email", () => {
      expect(isValidEmail("invalid-email")).toBe(false);
    });
  });

  describe("isValidPhone", () => {
    it("should validate correct phone", () => {
      expect(isValidPhone("+1234567890")).toBe(true);
    });

    it("should reject invalid phone", () => {
      expect(isValidPhone("123")).toBe(false);
    });
  });

  describe("getStatusBadgeColor", () => {
    it("should return correct badge color for status", () => {
      expect(getStatusBadgeColor("COMPLETED")).toBe("success");
      expect(getStatusBadgeColor("WAITING")).toBe("warning");
      expect(getStatusBadgeColor("SKIPPED")).toBe("danger");
    });
  });
});
```

### Run Tests

```bash
npm test
npm test -- --coverage
```

## Integration Testing

### Test API Routes

Create `src/api/__tests__/token.test.ts`:

```typescript
import { POST } from "@/api/token/generate/route";
import { NextRequest } from "next/server";

describe("Token Generation API", () => {
  it("should generate a new token", async () => {
    const request = new NextRequest("http://localhost:3000/api/token/generate", {
      method: "POST",
      body: JSON.stringify({
        name: "Test Patient",
        phone: "+1234567890",
        age: 30,
        gender: "male",
        department: "GENERAL",
      }),
    });

    const response = await POST(request);
    const data = await response.json();

    expect(response.status).toBe(201);
    expect(data.success).toBe(true);
    expect(data.data.tokenNumber).toBeDefined();
  });

  it("should reject invalid data", async () => {
    const request = new NextRequest("http://localhost:3000/api/token/generate", {
      method: "POST",
      body: JSON.stringify({
        name: "Test Patient",
        // Missing required fields
      }),
    });

    const response = await POST(request);
    const data = await response.json();

    expect(response.status).toBe(400);
    expect(data.success).toBe(false);
  });
});
```

## E2E Testing with Playwright

### Setup

```bash
npm install --save-dev @playwright/test
npx playwright install
```

### Example E2E Test

Create `tests/patient-registration.spec.ts`:

```typescript
import { test, expect } from "@playwright/test";

test.describe("Patient Registration Flow", () => {
  test("should successfully register a patient", async ({ page }) => {
    // Navigate to registration page
    await page.goto("http://localhost:3000/register");

    // Fill form
    await page.fill('input[name="name"]', "John Test Patient");
    await page.fill('input[name="phone"]', "+1234567890");
    await page.fill('input[name="age"]', "30");
    await page.selectOption('select[name="gender"]', "male");
    await page.selectOption('select[name="department"]', "GENERAL");

    // Submit form
    await page.click('button[type="submit"]');

    // Verify success message
    await expect(page.locator("text=Token Generated")).toBeVisible();
  });

  it("should validate required fields", async ({ page }) => {
    await page.goto("http://localhost:3000/register");

    // Try to submit empty form
    await page.click('button[type="submit"]');

    // Should see validation error
    await expect(page.locator("text=required")).toBeVisible();
  });
});
```

### Run E2E Tests

```bash
npx playwright test
npx playwright test --ui
npx playwright test --debug
```

## Load Testing

### Setup Artillery

```bash
npm install --save-dev artillery
```

### Load Test Configuration

Create `load-test.yml`:

```yaml
config:
  target: "http://localhost:3000"
  phases:
    - duration: 60
      arrivalRate: 10
      name: "Warm up"
    - duration: 120
      arrivalRate: 20
      name: "Ramp up"
    - duration: 60
      arrivalRate: 50
      name: "Spike"

scenarios:
  - name: "Patient Registration"
    flow:
      - post:
          url: "/api/token/generate"
          json:
            name: "Load Test Patient"
            phone: "{{ randomString(10) }}"
            age: 30
            gender: "male"
            department: "GENERAL"
          capture:
            - json: "$.data.tokenId"
              as: "tokenId"

  - name: "Queue View"
    flow:
      - get:
          url: "/api/queue"
```

### Run Load Test

```bash
artillery run load-test.yml
artillery run load-test.yml --output results.json
artillery report results.json --output results.html
```

## Performance Testing

### Lighthouse

```bash
npm install --save-dev @lhci/cli
```

### Check Core Web Vitals

```bash
lighthouse http://localhost:3000 --output=json
lighthouse http://localhost:3000/register --output=json
lighthouse http://localhost:3000/queue-display --output=json
```

## Manual Testing Checklist

### Patient Registration
- [ ] Form validation works
- [ ] SMS notification sent
- [ ] Token number generated correctly
- [ ] Firebase updated in real-time
- [ ] Mobile responsiveness

### Queue Display
- [ ] Real-time updates from Firebase
- [ ] Department filter works
- [ ] Status badges display correctly
- [ ] No console errors

### Authentication
- [ ] Login with valid credentials works
- [ ] Invalid credentials rejected
- [ ] Session persists on page reload
- [ ] Logout clears session

### Receptionist Dashboard
- [ ] Queue displays correctly
- [ ] Stats update in real-time
- [ ] Call Next button works
- [ ] Skip button works

### Doctor Console
- [ ] Current patient displays
- [ ] Mark as complete works
- [ ] Referral form works
- [ ] SMS sent for referrals

### Admin Dashboard
- [ ] Analytics load correctly
- [ ] Charts display data
- [ ] Department stats accurate
- [ ] Data exports work

## Debugging Tips

### Enable Debug Mode

```bash
# Next.js debugging
DEBUG=* npm run dev

# Prisma debugging
DEBUG="prisma*" npm run dev

# Firebase debugging
export FIREBASE_DEBUG=all
npm run dev
```

### Browser DevTools

1. **Network Tab**: Monitor API calls
2. **Console**: Check for JavaScript errors
3. **Application**: View local storage and cookies
4. **Performance**: Profile page load times

### Common Issues

#### High API Response Times
- Check database query performance
- Verify indexes are set up
- Use Prisma's query logging

#### Real-time Updates Not Working
- Check Firebase connection
- Verify listener is attached
- Check browser console for errors

#### SMS Not Sending
- Verify Twilio credentials
- Check phone number format
- Review Twilio logs

## Continuous Integration

### GitHub Actions Workflow

Create `.github/workflows/test.yml`:

```yaml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_PASSWORD: postgres
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432

    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: 18
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Lint
        run: npm run lint
      
      - name: Unit tests
        run: npm test
      
      - name: Build
        run: npm run build
      
      - name: E2E tests
        run: npx playwright test
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
```

## Code Quality Tools

### ESLint Configuration

```bash
npm install --save-dev eslint eslint-config-next
```

### Prettier Formatting

```bash
npm install --save-dev prettier
npx prettier --write "src/**/*.{ts,tsx}"
```

### Type Checking

```bash
npx tsc --noEmit
```

## Performance Benchmarks

### Target Metrics
- Page Load Time: < 2s
- API Response Time: < 500ms
- First Contentful Paint: < 1.5s
- Largest Contentful Paint: < 2.5s
- Cumulative Layout Shift: < 0.1

### Monitor with

```bash
# Real User Monitoring
npm install --save-dev web-vitals
```

## Test Coverage Goals

- Unit Tests: 80%+
- Integration Tests: 60%+
- E2E Tests: Key user flows
- Performance Tests: Critical paths
