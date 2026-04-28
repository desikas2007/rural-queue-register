#!/bin/bash

# Rural Queue Register - Installation Verification Script
# This script verifies that all project files are correctly set up

echo "🔍 Verifying Rural Queue Register Installation..."
echo "=================================================="
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counter
PASSED=0
FAILED=0

# Function to check file existence
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✅${NC} $1"
        ((PASSED++))
    else
        echo -e "${RED}❌${NC} $1"
        ((FAILED++))
    fi
}

# Function to check directory existence
check_dir() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✅${NC} $1"
        ((PASSED++))
    else
        echo -e "${RED}❌${NC} $1"
        ((FAILED++))
    fi
}

echo "📁 Checking Directory Structure..."
check_dir "prisma"
check_dir "public"
check_dir "src/app"
check_dir "src/api"
check_dir "src/components"
check_dir "src/hooks"
check_dir "src/lib"
check_dir "src/types"

echo ""
echo "📄 Checking Configuration Files..."
check_file "package.json"
check_file "tsconfig.json"
check_file "next.config.ts"
check_file "tailwind.config.ts"
check_file "postcss.config.js"
check_file ".gitignore"
check_file ".env.local"
check_file ".env.example"

echo ""
echo "🗄️  Checking Database Files..."
check_file "prisma/schema.prisma"
check_file "prisma/seed.ts"

echo ""
echo "🎨 Checking Frontend Pages..."
check_file "src/app/page.tsx"
check_file "src/app/layout.tsx"
check_file "src/app/globals.css"
check_file "src/app/(auth)/login/page.tsx"
check_file "src/app/register/page.tsx"
check_file "src/app/queue-display/page.tsx"
check_file "src/app/(dashboard)/admin/page.tsx"
check_file "src/app/(dashboard)/doctor/page.tsx"
check_file "src/app/(dashboard)/receptionist/page.tsx"

echo ""
echo "🔌 Checking API Routes..."
check_file "src/api/auth/[...nextauth]/route.ts"
check_file "src/api/token/generate/route.ts"
check_file "src/api/token/update-status/route.ts"
check_file "src/api/queue/route.ts"
check_file "src/api/sms/route.ts"
check_file "src/api/analytics/route.ts"

echo ""
echo "🧩 Checking Components..."
check_file "src/components/ui/Button.tsx"
check_file "src/components/ui/Input.tsx"
check_file "src/components/ui/Badge.tsx"
check_file "src/components/PatientForm.tsx"
check_file "src/components/QueueBoard.tsx"
check_file "src/components/TokenCard.tsx"
check_file "src/components/DoctorPanel.tsx"
check_file "src/components/AnalyticsChart.tsx"

echo ""
echo "🪝 Checking Hooks..."
check_file "src/hooks/useQueue.ts"
check_file "src/hooks/useRealtimeQueue.ts"

echo ""
echo "📚 Checking Libraries..."
check_file "src/lib/prisma.ts"
check_file "src/lib/firebase.ts"
check_file "src/lib/twilio.ts"
check_file "src/lib/auth.ts"
check_file "src/lib/utils.ts"
check_file "src/lib/errors.ts"

echo ""
echo "📋 Checking Types..."
check_file "src/types/index.ts"

echo ""
echo "🔐 Checking Security..."
check_file "src/middleware.ts"

echo ""
echo "🐳 Checking Docker Files..."
check_file "Dockerfile"
check_file "docker-compose.yml"
check_file ".env.docker"

echo ""
echo "📖 Checking Documentation..."
check_file "README.md"
check_file "QUICKSTART.md"
check_file "API.md"
check_file "DEPLOYMENT.md"
check_file "TESTING.md"
check_file "BEST_PRACTICES.md"
check_file "MIGRATION.md"
check_file "PROJECT_STRUCTURE.md"
check_file "CHANGELOG.md"

echo ""
echo "🔧 Checking Setup Scripts..."
check_file "setup.sh"
check_file "setup.bat"

echo ""
echo "=================================================="
echo ""
echo -e "${GREEN}✅ Passed: $PASSED${NC}"
echo -e "${RED}❌ Failed: $FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 All files verified successfully!${NC}"
    echo ""
    echo "📋 Next Steps:"
    echo "1. Run: npm install"
    echo "2. Configure: .env.local with your credentials"
    echo "3. Setup Database: npm run prisma:migrate"
    echo "4. Seed Data: npm run seed"
    echo "5. Start Dev: npm run dev"
    echo ""
    exit 0
else
    echo -e "${RED}⚠️  Some files are missing!${NC}"
    echo "Please check the list above and ensure all files exist."
    exit 1
fi
