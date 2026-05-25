# User Documentation  
## Early Career Assistance App

## 1. Introduction

The **Early Career Assistance App** is designed to help students and recent graduates prepare for early career opportunities in the technology industry. The app allows users to create a career profile, analyse their skill gaps, receive learning recommendations, build a resume, showcase portfolio projects, find sample jobs, and track applied jobs.

This user guide explains how to use the main features of the application.

---

## 2. Target Users

This app is intended for:

- IT students
- Recent graduates
- Entry-level job seekers
- Users who want to explore technology career paths
- Users who want to improve their employability skills

---

## 3. System Requirements

### For Android Users

- Android phone or emulator
- Internet connection
- Installed APK file
- Firebase backend access through the app

### For Web Testing

- Google Chrome or Microsoft Edge
- Internet connection
- App running through Flutter web

---

## 4. Getting Started

### 4.1 Open the App

When the app opens, the user will see the login screen.

The login screen contains:

- Email field
- Password field
- Login/Register button
- Forgot Password option

---

## 5. Account Registration

### Steps to Register

1. Open the app.
2. Enter your email address.
3. Enter your password.
4. Select the register option if available.
5. Tap **Register**.
6. After successful registration, the app will take you to the main home screen.

### Expected Result

A new user account is created and saved using Firebase Authentication.

---

## 6. User Login

### Steps to Login

1. Open the app.
2. Enter your registered email address.
3. Enter your password.
4. Tap **Login**.
5. The app will open the main navigation screen.

### Expected Result

The user is logged in and can access their saved profile and career data.

---

## 7. Forgot Password

### Steps to Reset Password

1. Enter your email address on the login screen.
2. Tap **Forgot Password?**
3. Check your email inbox.
4. Follow the password reset link sent by Firebase Authentication.

### Expected Result

The user receives a password reset email.

---

## 8. Main Navigation

After login, the user can access the main app sections from the bottom navigation bar.

The main sections are:

- Home
- Profile
- Portfolio
- Skills
- Jobs

---

## 9. Home Screen

The home screen gives users a quick overview of the app.

From the home screen, users can:

- Read a welcome message
- Open the profile management screen
- Open the profile/portfolio screen
- Open the resume builder

---

## 10. Manage User Profile

The profile management screen allows the user to create and update their career profile.

### Profile Fields

Users can enter:

- Name
- Email
- Phone number
- Skill set
- Interested job role

### Steps to Create or Update Profile

1. Go to the **Profile** section.
2. Enter your name.
3. Enter your email address.
4. Enter your phone number.
5. Enter your skills separated by commas.

   Example:

   ```text
   Flutter, Firebase, Git, SQL
   ```

6. Select your interested job role.
7. Tap **Save Profile** or **Update Profile**.

### Expected Result

The profile is saved to the database and can be used by other app features such as Skill Gap Analyzer, Resume Builder, and Portfolio.

---

## 11. View Profile and Portfolio

The profile/portfolio screen displays the user's saved information.

It shows:

- Name
- Email
- Phone number
- Skills
- Career interest
- Portfolio projects
- Applied jobs

### If No Profile Exists

The app will show a message asking the user to create a profile first.

---

## 12. Resume Builder

The Resume Builder uses saved profile data to generate a basic resume preview.

### Resume Sections

The resume includes:

- Name
- Career interest
- Contact information
- Skills
- Career objective
- Education
- Projects

### Steps to Save Resume

1. Create your profile first.
2. Open **Resume Builder** from the Home screen.
3. Review the resume preview.
4. Tap **Save Resume**.
5. The resume data will be saved to the database.

### Expected Result

The resume is saved under the user's account and can be used later for further development or export.

---

## 13. Skill Gap Analyzer

The Skill Gap Analyzer compares the user's skills with the required skills for a selected career.

### Steps to Analyse Skills

1. Create or update your profile.
2. Add your skills in the profile screen.
3. Go to the **Skills** section.
4. Select a career from the dropdown list.
5. Tap **Analyse Skills**.

### Expected Result

The app displays:

- Match percentage
- Matched skills
- Missing skills
- Recommendation message

### Example

If the selected career is **Mobile App Developer** and the user skills are:

```text
Flutter, Firebase
```

The app may show:

```text
Matched Skills:
Flutter, Firebase

Missing Skills:
Dart, UI Design, API Integration
```

---

## 14. Learning Recommendations

After running a skill gap analysis, users can view learning recommendations.

### Steps to View Recommendations

1. Run a skill gap analysis.
2. Tap **View Learning Recommendations**.
3. Review the recommended courses, tasks, or learning resources.

### Expected Result

The app shows recommendations only for the current skill gap analysis.

Example recommendations:

- Learn Dart Programming
- Learn Mobile UI Design Basics
- Practice REST API Integration

---

## 15. Portfolio Projects

The portfolio section allows users to display project work.

### Steps to Add a Project

1. Open the **Portfolio** section.
2. Tap **Add**.
3. A sample portfolio project is added.
4. The project appears in the project list.

### Project Information Displayed

Each portfolio project may include:

- Project title
- Project description
- Technologies used
- GitHub URL, if available

### Steps to Delete a Project

1. Open the **Portfolio** section.
2. Find the project you want to delete.
3. Tap the delete icon.
4. The project is removed from the portfolio.

---

## 16. Find Jobs

The Find Jobs section displays sample entry-level job opportunities.

### Job Information Displayed

Each job card shows:

- Job title
- Company name
- Location
- Salary range
- Required skills
- Apply button

### Steps to Apply for a Job

1. Go to the **Jobs** section.
2. Review the available job cards.
3. Tap **Apply Now** on a job.
4. The job is saved under your applied jobs list.

### Expected Result

The app shows a confirmation message and saves the applied job to the user's account.

---

## 17. Applied Jobs

Applied jobs are displayed in the Portfolio/Profile section.

### Information Displayed

Each applied job may show:

- Job title
- Company name
- Location
- Application status

### Steps to View Applied Jobs

1. Open the **Portfolio** section.
2. Scroll to the **Applied Jobs** section.
3. View the list of jobs you have applied for.

### Steps to Remove an Applied Job

1. Open the **Portfolio** section.
2. Find the applied job.
3. Tap the delete icon.
4. The job is removed from your applied jobs list.

---

## 18. Logout

### Steps to Logout

1. Go to the Home screen.
2. Tap the logout icon in the app bar.
3. The app returns to the login screen.

### Expected Result

The user session ends securely.

---

## 19. Common Errors and Solutions

### Error: Please create your profile first

**Reason:**  
The user is trying to access Resume Builder, Skill Gap Analyzer, or Portfolio without saving a profile first.

**Solution:**  
Go to the Profile section and save your profile.

---

### Error: Login failed

**Reason:**  
The email or password may be incorrect.

**Solution:**  
Check your email and password, then try again. Use **Forgot Password** if needed.

---

### Error: No recommendations generated yet

**Reason:**  
The user has not run a skill gap analysis, or the selected career has no matching recommendation rules.

**Solution:**  
Run the Skill Gap Analyzer first.

---

### Error: Internet connection issue

**Reason:**  
The app requires internet access to communicate with Firebase.

**Solution:**  
Check your internet connection and try again.

---

## 20. User Data and Privacy

The app stores user data securely using Firebase.

User-specific data is stored under each user's account, including:

- Profile information
- Skill gap results
- Recommendations
- Resume data
- Portfolio projects
- Applied jobs

Users can only access their own private data when logged in.

---

## 21. Recommended Demo Flow

For presentation or demonstration, use this flow:

1. Register a new user.
2. Create a profile.
3. Add skills and select a career interest.
4. Open Resume Builder and save a resume.
5. Open Skill Gap Analyzer and analyse skills.
6. View learning recommendations.
7. Add a portfolio project.
8. Apply for a job.
9. View applied jobs.
10. Logout.

---

## 22. Support

If the app does not behave as expected:

1. Check internet connection.
2. Restart the app.
3. Confirm the user is logged in.
4. Confirm the profile is saved.
5. Contact the project development team for support.

---

## 23. Conclusion

The Early Career Assistance App provides a structured way for students to manage their early career preparation. By combining profile management, skill analysis, recommendations, resume building, portfolio showcase, and job application tracking, the app helps users improve their readiness for entry-level technology roles.
