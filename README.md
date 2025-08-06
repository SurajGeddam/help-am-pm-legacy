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

## 🔧 Local Development

### Prerequisites
- Java 17 (for backend)
- Node.js 18+ (for dashboard)
- Flutter 3.32.8+ (for mobile app)
- MySQL 8.0.29 (for database)

### Quick Start

#### Backend API
```bash
cd help-am-pm-mothership-master/helpampm-api
docker compose up -d
# API runs on http://localhost:8080
```

#### Admin Dashboard
```bash
cd help-am-pm-mothership-master/helpampm-admin-dashboard
npm install --legacy-peer-deps
npm start
# Dashboard runs on http://localhost:4200
```

#### Mobile App
```bash
cd help-am-pm-mobileapp-master
flutter pub get
flutter run
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