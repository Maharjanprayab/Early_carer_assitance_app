# Early Career Assistance App

## Project Overview

The **Early Career Assistance App** is a Flutter and Firebase-based career support application designed for IT students and recent graduates. The app helps users explore career options, analyse skill gaps, receive learning recommendations, build a resume, create a portfolio, and apply for entry-level jobs.

The project was developed as a capstone project to support students in improving employability and preparing for early career opportunities.

---

## Key Features

### User Authentication
- User registration
- User login
- User logout
- Firebase Authentication integration
- User session management

### User Profile Management
- Create career profile
- Update profile information
- Save skills and career interest
- View saved profile data
- Store profile data securely in Firestore

### Career Explorer
- Career data stored in Firestore
- Career paths include required skills, descriptions, entry-level roles, and salary ranges
- Used by the skill gap analyser for comparison

### Skill Gap Analyzer
- Compares user skills with selected career requirements
- Shows matched skills
- Shows missing skills
- Calculates match percentage
- Saves analysis results to Firestore

### Learning Recommendations
- Generates personalised recommendations based on missing skills
- Uses Firestore recommendation rules
- Shows only recommendations for the current skill gap analysis
- Stores recommendations under the logged-in user

### Resume Builder
- Generates resume content using user profile data
- Saves resume data to Firestore
- Stores personal details, summary, education, skills, projects, and experience

### Portfolio Showcase
- Allows users to add portfolio projects
- Displays saved portfolio projects
- Supports deleting portfolio projects
- Stores portfolio data under each user in Firestore

### Find Jobs and Applied Jobs
- Displays sample entry-level jobs
- Allows users to apply for jobs
- Saves applied jobs under the logged-in user
- Displays applied jobs in the portfolio/profile section

---

## Technology Stack

| Area | Technology |
|---|---|
| Frontend | Flutter |
| Programming Language | Dart |
| Authentication | Firebase Authentication |
| Database | Cloud Firestore |
| Storage | Firebase Storage |
| Backend Logic | Flutter service layer |
| Version Control | Git and GitHub |
| IDE | Visual Studio Code |
| Design Support | Figma |

---

## Firebase Services Used

### Firebase Authentication
Used for:
- User signup
- User login
- User logout
- Current user session handling

### Cloud Firestore
Used for:
- User profiles
- Career data
- Skill gap results
- Learning recommendations
- Resume data
- Portfolio projects
- Applied jobs

### Firebase Storage
Prepared for:
- Portfolio image uploads
- Project media storage

---

## Firestore Database Structure

```text
users/{userId}
users/{userId}/skillGapResults/{resultId}
users/{userId}/recommendations/{recommendationId}
users/{userId}/resumes/{resumeId}
users/{userId}/portfolioProjects/{projectId}
users/{userId}/appliedJobs/{applicationId}

careers/{careerId}
recommendationRules/{ruleId}
```

---

## Main Collections

### users
Stores profile data for each registered user.

Example fields:

```json
{
  "uid": "userId",
  "fullName": "Student Name",
  "name": "Student Name",
  "email": "student@example.com",
  "phone": "0400000000",
  "skillSet": "Flutter, Firebase, Git",
  "degree": "Bachelor of IT",
  "careerInterest": "Mobile App Developer",
  "interestedJob": "Mobile App Developer",
  "hasProfile": true,
  "createdAt": "serverTimestamp",
  "updatedAt": "serverTimestamp"
}
```

### careers
Stores career path data.

Example fields:

```json
{
  "title": "Mobile App Developer",
  "category": "Software Development",
  "description": "Builds mobile applications for Android and iOS.",
  "requiredSkills": ["Flutter", "Dart", "Firebase", "UI Design", "API Integration"],
  "entryLevelRoles": ["Junior Flutter Developer", "Mobile App Intern"],
  "averageSalary": "AUD 70,000 - 100,000"
}
```

### recommendationRules
Stores rule-based learning recommendations for missing skills.

Example fields:

```json
{
  "careerId": "mobile_app_developer",
  "skill": "Dart",
  "title": "Learn Dart Programming",
  "type": "Course",
  "provider": "Dart Documentation",
  "url": "https://dart.dev/language",
  "priority": "High"
}
```

### users/{userId}/skillGapResults
Stores individual user skill gap analysis results.

### users/{userId}/recommendations
Stores recommendations generated for a specific skill gap analysis.

### users/{userId}/resumes
Stores saved resume data.

### users/{userId}/portfolioProjects
Stores portfolio project details.

### users/{userId}/appliedJobs
Stores jobs that the user applied for.

---

## Project Folder Structure

```text
lib/
  backend/
    auth_service.dart
    user_service.dart
    career_service.dart
    skill_gap_service.dart
    recommendation_service.dart
    resume_service.dart
    portfolio_service.dart
    storage_service.dart
    job_application_service.dart
    seed_data_service.dart
    backend.dart

  core/
    firebase_constants.dart

  models/
    app_user.dart
    career.dart
    skill_gap_result.dart
    recommendation_item.dart
    resume_data.dart
    portfolio_project.dart
    models.dart

  screens/
    frontend/
      frontend_app_screens.dart
    dev_tests/
      seed_data_screen.dart

  find_jobs_screen.dart
  firebase_options.dart
  main.dart
```

---

## Backend Service Files

| File | Purpose |
|---|---|
| `auth_service.dart` | Handles signup, login, logout, and user profile creation |
| `user_service.dart` | Handles profile reading, saving, updating, and clearing |
| `career_service.dart` | Reads career data from Firestore |
| `skill_gap_service.dart` | Compares user skills with career requirements |
| `recommendation_service.dart` | Generates and reads learning recommendations |
| `resume_service.dart` | Saves and reads resume data |
| `portfolio_service.dart` | Adds, reads, updates, and deletes portfolio projects |
| `storage_service.dart` | Handles Firebase Storage uploads |
| `job_application_service.dart` | Saves and reads applied jobs |
| `seed_data_service.dart` | Seeds career and recommendation data into Firestore |

---

## Model Files

| File | Purpose |
|---|---|
| `app_user.dart` | User profile model |
| `career.dart` | Career model |
| `skill_gap_result.dart` | Skill gap result model |
| `recommendation_item.dart` | Recommendation model |
| `resume_data.dart` | Resume model |
| `portfolio_project.dart` | Portfolio project model |

---

## Security Rules Summary

Firestore security rules are used to protect private user data.

Main security approach:

```text
Users can only access their own private data under users/{userId}
```

Protected user subcollections:
- `skillGapResults`
- `recommendations`
- `resumes`
- `portfolioProjects`
- `appliedJobs`

Reference data:
- `careers` is readable by users/public depending on rule configuration
- `recommendationRules` is readable by signed-in users
- App users cannot modify career or recommendation rule data after seeding

---

## How to Run the Project

### 1. Clone the repository

```bash
git clone <repository-url>
cd early_career_assistance_app
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Check project health

```bash
flutter analyze
```

### 4. Run the app

For Chrome:

```bash
flutter run -d chrome
```

For Android:

```bash
flutter run
```

---

## Build Android APK

To build a release APK:

```bash
flutter clean
flutter pub get
flutter build apk --release
```

APK output:

```text
build/app/outputs/flutter-apk/app-release.apk
```

---

## Build Android App Bundle for Google Play

To build an AAB file:

```bash
flutter build appbundle --release
```

AAB output:

```text
build/app/outputs/bundle/release/app-release.aab
```

---

## Testing Checklist

| Test Case | Expected Result |
|---|---|
| Register user | User is created in Firebase Authentication |
| Save profile | Profile is saved in Firestore under `users/{uid}` |
| Login user | User can access saved profile |
| Analyse skills | Skill gap result is saved under `skillGapResults` |
| View recommendations | Recommendations are shown for the current analysis only |
| Save resume | Resume is saved under `resumes` |
| Add portfolio project | Project is saved under `portfolioProjects` |
| Delete portfolio project | Project is removed from Firestore |
| Apply for job | Job is saved under `appliedJobs` |
| Logout | User session ends successfully |

---

## Current Development Status

Completed:
- Firebase setup
- Authentication
- User profile management
- Career data seeding
- Skill gap analysis
- Learning recommendations
- Resume saving
- Portfolio project management
- Job application feature
- Firestore security rules
- Android APK build support

Pending or future improvements:
- Full resume PDF export
- Real job API integration
- Portfolio image upload UI
- Advanced recommendation algorithm
- App Store / Play Store production release
- More UI polish and accessibility testing

---

## Team Members

- Prayab Maharjan
- Yougesh Koirala
- Rushika Budhathoki
- Denish Bhattarai

---

## Project Purpose

The purpose of the Early Career Assistance App is to support IT students and recent graduates in preparing for the technology workforce. The app provides a structured platform for exploring careers, identifying missing skills, receiving personalised guidance, building resumes, showcasing projects, and tracking applied jobs.
