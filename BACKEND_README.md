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
```

### Cloud Firestore

Cloud Firestore is used to store:

- User profiles
- Career data
- Skill gap results
- Recommendation rules
- User recommendations
- Resume data
- Portfolio project data

### Firebase Storage

Firebase Storage is used to store uploaded portfolio images.

The main storage service file is:

```text
lib/backend/storage_service.dart
```

---

## 4. Firestore Database Structure

```text
users/{userId}
careers/{careerId}
recommendationRules/{ruleId}

users/{userId}/skillGapResults/{resultId}
users/{userId}/recommendations/{recommendationId}
users/{userId}/resumes/{resumeId}
users/{userId}/portfolioProjects/{projectId}
```

---

## 5. Collections

### users

Stores user profile information.

Example:

```json
{
  "uid": "userId",
  "fullName": "Test Student",
  "email": "student@example.com",
  "degree": "Bachelor of IT",
  "careerInterest": "Backend Developer",
  "createdAt": "serverTimestamp",
  "updatedAt": "serverTimestamp"
}
```

### careers

Stores career path information.

Example:

```json
{
  "title": "Frontend Developer",
  "category": "Software Development",
  "description": "Builds user interfaces for websites and web applications.",
  "requiredSkills": ["HTML", "CSS", "JavaScript", "React", "Git"],
  "entryLevelRoles": ["Junior Frontend Developer", "Web Developer"],
  "averageSalary": "AUD 70,000 - 95,000"
}
```

### recommendationRules

Stores rule-based recommendation data.

Example:

```json
{
  "careerId": "frontend_developer",
  "skill": "JavaScript",
  "title": "Learn JavaScript Basics",
  "type": "Course",
  "provider": "MDN Web Docs",
  "url": "https://developer.mozilla.org/en-US/docs/Web/JavaScript",
  "priority": "High"
}
```

### users/{userId}/skillGapResults

Stores skill gap analysis results for each user.

Example:

```json
{
  "selectedCareerId": "frontend_developer",
  "careerTitle": "Frontend Developer",
  "userSkills": ["HTML", "CSS", "Python"],
  "requiredSkills": ["HTML", "CSS", "JavaScript", "React", "Git"],
  "matchedSkills": ["HTML", "CSS"],
  "missingSkills": ["JavaScript", "React", "Git"],
  "matchPercentage": 40,
  "createdAt": "serverTimestamp"
}
```

### users/{userId}/recommendations

Stores personalised recommendations generated from missing skills.

Example:

```json
{
  "basedOnCareerId": "frontend_developer",
  "missingSkill": "React",
  "type": "Course",
  "title": "Learn React Fundamentals",
  "provider": "React Documentation",
  "url": "https://react.dev/learn",
  "priority": "High",
  "createdAt": "serverTimestamp"
}
```

### users/{userId}/resumes

Stores resume builder data.

Example:

```json
{
  "personalDetails": {
    "fullName": "Test Student",
    "email": "student@example.com",
    "phone": "0400000000",
    "location": "Melbourne, Australia"
  },
  "summary": "Entry-level IT student interested in software development.",
  "education": [],
  "skills": ["Flutter", "Firebase", "Dart"],
  "projects": [],
  "experience": [],
  "createdAt": "serverTimestamp",
  "updatedAt": "serverTimestamp"
}
```

### users/{userId}/portfolioProjects

Stores portfolio project data.

Example:

```json
{
  "title": "Early Career Assistance App",
  "description": "A Flutter and Firebase app for IT students.",
  "technologies": ["Flutter", "Firebase", "Firestore"],
  "githubUrl": "https://github.com/example/project",
  "imageUrl": "",
  "createdAt": "serverTimestamp",
  "updatedAt": "serverTimestamp"
}
```

---

## 6. Firebase Storage Structure

Portfolio images are stored using this path:

```text
portfolio_uploads/{userId}/{projectId}/{fileName}
```

Example:

```text
portfolio_uploads/abc123/project456/1760000000000.jpg
```

---

## 7. Backend Service Files

| File | Purpose |
|---|---|
| `auth_service.dart` | Signup, login, logout, and user profile creation |
| `user_service.dart` | Read and update user profile data |
| `career_service.dart` | Read career path data |
| `skill_gap_service.dart` | Compare user skills with required career skills |
| `recommendation_service.dart` | Generate and read personalised recommendations |
| `resume_service.dart` | Create, read, update, and delete resume data |
| `portfolio_service.dart` | Create, read, update, and delete portfolio projects |
| `storage_service.dart` | Upload and delete portfolio images |

---

## 8. Model Files

| File | Purpose |
|---|---|
| `app_user.dart` | User profile model |
| `career.dart` | Career model |
| `skill_gap_result.dart` | Skill gap result model |
| `recommendation_item.dart` | Recommendation model |
| `resume_data.dart` | Resume model |
| `portfolio_project.dart` | Portfolio project model |

---

## 9. Security Rules Summary

Firestore security rules ensure that users can only access their own private data.

Main rule idea:

```text
A user can access users/{userId} only when request.auth.uid == userId
```

Private collections:

```text
users/{userId}/skillGapResults
users/{userId}/recommendations
users/{userId}/resumes
users/{userId}/portfolioProjects
```

Career data and recommendation rules are reference data. They can be read by users but cannot be edited from the app.

---

## 10. Storage Rules Summary

Firebase Storage rules ensure that users can only upload and access their own portfolio images.

Rules also restrict:

- Maximum file size: 5 MB
- File type: image only

---

## 11. Backend Testing Checklist

| Test | Expected Result |
|---|---|
| Signup user | User appears in Firebase Authentication |
| Signup user | User profile appears in Firestore `users` collection |
| Login user | User can access private backend data |
| Career service | Careers are loaded from Firestore |
| Skill gap service | Matched skills, missing skills, and percentage are generated |
| Recommendation service | Recommendations are generated from missing skills |
| Resume service | Resume can be created, updated, read, and deleted |
| Portfolio service | Portfolio project can be created, updated, read, and deleted |
| Storage service | Portfolio image can be uploaded to Firebase Storage |
| Security rules | User cannot access another user's private data |

---

## 12. Backend Development Status

Completed:

- Firebase setup
- Firebase Authentication integration
- Firestore integration
- Firebase Storage integration
- Authentication service
- User profile service
- Career service
- Skill gap service
- Recommendation service
- Resume service
- Portfolio service
- Storage service
- Firestore security rules
- Storage security rules
- Backend model classes

Pending:

- Integration with final UI screens
- Final resume PDF export connection
- Final image upload UI
- Full end-to-end testing
