# Firebase Authentication Setup Guide

## Overview
This document outlines the Firebase authentication setup for the CTU Smart School Calendar project, supporting both web and mobile platforms.

## Configuration Details

### Firebase Project
- **Project ID**: ctu-smart-school-calendar
- **Web App ID**: 1:504460775226:web:40aa281ade3dc47f754a03
- **Android App ID**: 1:504460775226:android:97eb3de792b44816754a03
- **Package Name**: com.ctu.smart.school.calendar

### Web Configuration
- **File**: `web/index.html`
- **Firebase SDK**: Added via CDN
- **Configuration**: Embedded in HTML with proper initialization

### Mobile Configuration
- **Android**: `google-services.json` configured
- **iOS**: `GoogleService-Info.plist` created
- **Dependencies**: Firebase Core, Auth, and Analytics added to `pubspec.yaml`

## Files Created/Modified

### 1. Web Configuration
- `web/index.html` - Added Firebase SDK scripts and initialization
- `web/firebase-config.js` - Firebase configuration file

### 2. Mobile Configuration
- `android/app/build.gradle.kts` - Added Google Services plugin
- `android/build.gradle.kts` - Added Firebase classpath
- `ios/Runner/GoogleService-Info.plist` - iOS Firebase configuration
- `pubspec.yaml` - Added Firebase dependencies

### 3. Authentication Services
- `lib/services/firebase_auth_service.dart` - Core Firebase authentication service
- `lib/services/auth_provider.dart` - State management for authentication

### 4. UI Components
- `lib/screens/auth/login_screen.dart` - Login interface
- `lib/screens/auth/signup_screen.dart` - Registration interface
- `lib/main.dart` - Updated to use Firebase authentication

## Features Implemented

### Authentication Methods
- Email and Password authentication
- User registration
- Password reset
- Sign out functionality
- Automatic authentication state management

### Security Features
- Input validation
- Error handling with user-friendly messages
- Password confirmation during registration
- Secure password storage via Firebase

### UI Features
- Responsive design for web and mobile
- Loading states
- Error messages
- Form validation
- Password visibility toggle

## Next Steps

1. **Enable Authentication Methods in Firebase Console**:
   - Go to Firebase Console → Authentication → Sign-in method
   - Enable Email/Password authentication

2. **Run the Application**:
   ```bash
   flutter pub get
   flutter run
   ```

3. **Test Authentication**:
   - Create a new account
   - Test login functionality
   - Test password reset

## Dependencies Added
```yaml
firebase_core: ^2.24.2
firebase_auth: ^4.15.3
firebase_analytics: ^10.7.4
```

## Notes
- Ensure Firebase project authentication is enabled in the console
- The app handles authentication state automatically
- Error messages are user-friendly and informative
- All platforms (web, Android, iOS) are properly configured
