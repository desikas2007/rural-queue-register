@echo off
REM Rural Queue Register - Complete Setup Script for Windows

echo.
echo 🏥 Rural Hospital Patient Queue Management System - Setup
echo ===========================================================
echo.

REM Check if Node.js is installed
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Node.js is not installed. Please install Node.js 18+ first.
    pause
    exit /b 1
)

for /f "tokens=*" %%i in ('node --version') do set NODE_VERSION=%%i
echo ✅ Node.js version: %NODE_VERSION%

REM Install dependencies
echo.
echo 📦 Installing dependencies...
call npm install

REM Generate Prisma Client
echo.
echo 🔧 Setting up database...
call npm run prisma:generate

REM Create .env.local if it doesn't exist
if not exist .env.local (
    echo 📝 Creating .env.local file...
    echo Please create .env.local with your credentials
)

REM Build the project
echo.
echo 🔨 Building project...
call npm run build

echo.
echo ✅ Setup complete!
echo.
echo 📋 Next steps:
echo 1. Update .env.local with your credentials:
echo    - PostgreSQL DATABASE_URL
echo    - Firebase credentials
echo    - Twilio credentials
echo    - NEXTAUTH_SECRET (min 32 characters)
echo.
echo 2. Run database migrations:
echo    npm run prisma:migrate
echo.
echo 3. Start development server:
echo    npm run dev
echo.
echo 4. Open http://localhost:3000 in your browser
echo.
pause
