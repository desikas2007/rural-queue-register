#!/bin/bash

# Rural Queue Register - Complete Setup Script

echo "🏥 Rural Hospital Patient Queue Management System - Setup"
echo "=========================================================="

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js 18+ first."
    exit 1
fi

echo "✅ Node.js version: $(node --version)"

# Install dependencies
echo "📦 Installing dependencies..."
npm install

# Generate Prisma Client
echo "🔧 Setting up database..."
npm run prisma:generate

# Create .env.local if it doesn't exist
if [ ! -f .env.local ]; then
    echo "📝 Creating .env.local file..."
    cp .env.local.example .env.local 2>/dev/null || echo "⚠️  Please create .env.local with your credentials"
fi

# Build the project
echo "🔨 Building project..."
npm run build

echo ""
echo "✅ Setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. Update .env.local with your credentials:"
echo "   - PostgreSQL DATABASE_URL"
echo "   - Firebase credentials"
echo "   - Twilio credentials"
echo "   - NEXTAUTH_SECRET (min 32 characters)"
echo ""
echo "2. Run database migrations:"
echo "   npm run prisma:migrate"
echo ""
echo "3. Start development server:"
echo "   npm run dev"
echo ""
echo "4. Open http://localhost:3000 in your browser"
