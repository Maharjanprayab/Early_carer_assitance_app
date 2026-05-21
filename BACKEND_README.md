# Backend Documentation  
## Early Career Assistance App

## 1. Backend Overview

The backend of the Early Career Assistance App is implemented using Firebase. Firebase provides authentication, database storage, and file storage services for the application.

The backend supports the following app features:

- User account registration and login
- User profile management
- Career path explorer
- Skill gap analysis
- Resume builder
- Portfolio showcase
- Personalised recommendation system

## 2. Backend Technologies

| Technology | Purpose |
|---|---|
| Firebase Authentication | User signup, login, logout, and session management |
| Cloud Firestore | NoSQL database for users, careers, resumes, portfolios, skill results, and recommendations |
| Firebase Storage | Upload and store portfolio project images |
| FlutterFire | Connect Flutter app with Firebase |
| Dart | Backend service logic inside Flutter project |

## 3. Firebase Services Used

### Firebase Authentication

Firebase Authentication is used for:

- Creating user accounts
- Logging users in
- Logging users out
- Checking the current authenticated user
- Linking Firestore records to the authenticated user ID

The main authentication file is:

```text
lib/backend/auth_service.dart