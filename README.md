# HELP AM-PM Legacy Stack

This repository contains the complete legacy HELP AM-PM platform stack, including the mobile app, backend API, and admin dashboard.

## 🏗️ Architecture Overview

### Components
- **Mobile App**: Flutter-based mobile application (`help-am-pm-mobileapp-master/`)
- **Backend API**: Spring Boot REST API (`help-am-pm-mothership-master/helpampm-api/`)
- **Admin Dashboard**: Angular-based admin interface (`help-am-pm-mothership-master/helpampm-admin-dashboard/`)

### Technology Stack
- **Mobile**: Flutter 3.x, Dart
- **Backend**: Spring Boot 2.7.6, Java 17, MySQL 8.0.29
- **Dashboard**: Angular 15.2.10, TypeScript 4.9.5, Bootstrap 5.1.3

## 🏗️ Local Development Status

**Backend (helpampm-api)**  
- Running locally on `http://localhost:8080` via Docker Compose  
- Health endpoint (`/actuator/health`) returns 200  
- Authentication flow validated, JWT token generation fixed  
- Database cleaned: only `superadmin` and `geddamsuraj@gmail.com` exist  

**Admin Dashboard (Angular)**  
- Running on `http://localhost:4200`  
- Customer list shows only the two remaining users  
- CI passing on GitHub (Admin Dashboard CI)  

**Mobile App (Flutter)**  
- Builds cleanly for iOS simulator (iPhone 15 Pro)  
- Connects to local backend successfully  
- Login works with `geddamsuraj@gmail.com` / `Test1234!`  
- All 13+ package compatibility issues resolved  
- Next: add CI workflow for lint/analyze/test  

**CI Status**  
- **API CI**: ✅ **Fixed** - Docker Compose syntax updated for GitHub Actions  
- **Admin Dashboard CI**: ✅ **Working** - Dependencies and build process stable  
- **Mobile Analyze Only**: ⚠️ **Disabled** - Temporarily disabled until mobile modernization  

## 🚀 Continuous Integration

This repository uses GitHub Actions for automated testing and validation:

### Workflows

#### 1. **API CI** (`.github/workflows/api-ci.yml`)
- **Triggers**: Changes to `help-am-pm-mothership-master/helpampm-api/**` + manual dispatch
- **Actions**: 
  - Sets up JDK 17 and Docker
  - Uses `docker compose` (v2 syntax) for GitHub Actions compatibility
  - Builds Spring Boot application with Docker Compose
  - Starts services and tests health endpoint
  - Graceful error handling with `continue-on-error: true`
- **Status**: ✅ **Active** - Fixed Docker Compose syntax issue
- **Recent Fix**: Updated from `docker-compose` to `docker compose` for GitHub Actions compatibility

#### 2. **Admin Dashboard CI** (`.github/workflows/admin-ci.yml`)
- **Triggers**: Changes to `help-am-pm-mothership-master/helpampm-admin-dashboard/**` + manual dispatch
- **Actions**:
  - Sets up Node.js 18
  - Clean install with `--legacy-peer-deps` for dependency resolution
  - Runs TypeScript linting (non-blocking)
  - Builds production bundle with error handling
- **Status**: ✅ **Active** - Stable dependency management and build process

#### 3. **Mobile Analyze Only** (`.github/workflows/mobile-analyze.yml.disabled`)
- **Status**: ❌ **Disabled** - File renamed to prevent execution
- **Reason**: Prevents blocking on outdated iOS/Android tooling issues
- **Future**: Will be re-enabled after mobile app modernization

### CI Strategy

**Why this approach?**
- **API & Dashboard**: Full CI/CD to maintain stability
- **Mobile App**: Disabled to avoid blocking on outdated tooling
- **Path-based triggers**: Each component only runs when relevant files change
- **Docker Integration**: API CI uses Docker Compose for realistic testing
- **Graceful Degradation**: Linting failures don't block builds
- **Manual Dispatch**: All workflows support manual triggering for testing

## 📁 Repository Structure

```
old-app/
├── help-am-pm-mobileapp-master/     # Flutter mobile app
├── help-am-pm-mothership-master/
│   ├── helpampm-api/                # Spring Boot backend
│   └── helpampm-admin-dashboard/    # Angular admin interface
└── .github/workflows/               # CI/CD workflows
```

## 🔧 Quick Start Guide

### Prerequisites
- **Docker & Docker Compose** (for backend)
- **Node.js 18+** (for dashboard)
- **Flutter 3.32.8+** (for mobile app)
- **Java 17** (optional, for local backend development)

### 🚀 One-Command Setup

#### **1. Backend API (Required First)**
```bash
# Navigate to API directory
cd help-am-pm-mothership-master/helpampm-api

# Start all services (MySQL, API, Prometheus, Grafana)
docker compose up -d

# Verify backend is running
curl http://localhost:8080/actuator/health
```

#### **2. Admin Dashboard (Optional)**
```bash
# Navigate to dashboard directory
cd help-am-pm-mothership-master/helpampm-admin-dashboard

# Install dependencies (first time only)
npm install --legacy-peer-deps

# Start development server
npm start
```

#### **3. Mobile App (Optional)**
```bash
# Navigate to mobile app directory
cd help-am-pm-mobileapp-master

# Install dependencies (first time only)
flutter pub get

# Run on iOS simulator
flutter run

# Or run on Android emulator
flutter run -d android
```

### 🌐 Access Points
- **Backend API**: http://localhost:8080
- **Admin Dashboard**: http://localhost:4200
- **Grafana Monitoring**: http://localhost:3000
- **Prometheus Metrics**: http://localhost:9090

### 🔑 Test Credentials
- **Superadmin**: `superadmin` / `Password@1`
- **Test User**: `geddamsuraj@gmail.com` / `Test1234!`

### 🛠️ Development Commands

#### Backend API
```bash
# Start services
docker compose up -d

# View logs
docker compose logs -f app

# Stop services
docker compose down

# Rebuild and restart
docker compose up -d --build
```

#### Admin Dashboard
```bash
# Install dependencies
npm install --legacy-peer-deps

# Start development server
npm start

# Build for production
npm run build:prod

# Run tests
npm test
```

#### Mobile App
```bash
# Install dependencies
flutter pub get

# Run on iOS
flutter run

# Run on Android
flutter run -d android

# Build iOS
flutter build ios

# Build Android
flutter build apk
```

## 🛡️ Security Notes

- Sensitive credentials (Firebase, tokens) are excluded from this repository
- Environment-specific configurations should be managed separately
- Database credentials should be configured via environment variables

## 📈 Migration Path

This legacy stack is being prepared for modernization:

1. **Phase 1**: ✅ CI setup and stability (current)
2. **Phase 2**: Mobile app modernization (planned)
3. **Phase 3**: Full CI/CD for all components (planned)

## 🤝 Contributing

When making changes:
1. Ensure relevant CI workflows pass
2. Follow existing code patterns
3. Test changes locally before pushing
4. Update documentation as needed

## 📞 Support

For questions about this legacy stack, refer to the original development team or create an issue in this repository. 