import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../find_jobs_screen.dart';
import '../../backend/backend.dart';
import '../../models/models.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool isLogin = true;

  Future<void> authenticate() async {
    try {
      if (isLogin) {
        await _authService.login(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      } else {
        await _authService.signUp(
          fullName: emailController.text.trim().split('@').first,
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          degree: 'Bachelor of IT',
        );
      }

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.work, size: 80, color: Colors.indigo),
              const SizedBox(height: 20),
              const Text(
                'Early Career Assistance App',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                isLogin ? "Login" : "Register",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.email),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: authenticate,
                  child: Text(isLogin ? "Login" : "Register"),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
                child: Text(
                  isLogin ? "Create Account" : "Already have account?",
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () async {
                  if (emailController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter your email first'),
                      ),
                    );
                    return;
                  }

                  try {
                    await FirebaseAuth.instance.sendPasswordResetEmail(
                      email: emailController.text.trim(),
                    );
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Password reset email sent. Check your inbox.',
                        ),
                      ),
                    );
                  } on FirebaseAuthException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.message ?? 'Password reset failed'),
                      ),
                    );
                  }
                },
                child: const Text('Forgot Password?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int selectedIndex = 0;

  final List<Widget> screens = const [
    HomeScreen(),
    ManageUserProfileScreen(),
    ViewProfileScreen(),
    SkillGapAnalyzerScreen(),
    FindJobsScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts),
            label: 'Profile',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'portfolio'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Skills'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'jobs'),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text('Early Career Assistance App'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,

        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Manage your career profile, skills, and job interest in one place.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 25),
            Card(
              elevation: 4,
              color: Colors.indigo,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: const [
                    Icon(Icons.work, color: Colors.white, size: 40),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Build your early career profile and prepare for your target job.',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 3,
              child: ListTile(
                leading: const Icon(
                  Icons.manage_accounts,
                  color: Colors.indigo,
                ),
                title: const Text('Manage User Profile'),
                subtitle: const Text(
                  'Add, edit, or delete your career profile',
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManageUserProfileScreen(),
                    ),
                  );
                },
              ),
            ),
            Card(
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.person, color: Colors.indigo),
                title: const Text('View Profile'),
                subtitle: const Text('See your saved career profile'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ViewProfileScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),

                icon: const Icon(Icons.description),

                label: const Text('Resume Builder'),

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResumeBuilderScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ManageUserProfileScreen extends StatefulWidget {
  const ManageUserProfileScreen({super.key});

  @override
  State<ManageUserProfileScreen> createState() =>
      _ManageUserProfileScreenState();
}

class _ManageUserProfileScreenState extends State<ManageUserProfileScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final skillSetController = TextEditingController();
  final UserService _userService = UserService();

  String selectedJob = 'Mobile App Developer';
  bool profileExists = false;

  final List<String> jobOptions = [
    'Mobile App Developer',
    'Web Developer',
    'Software Developer',
    'Cyber Security Analyst',
    'Data Analyst',
    'UI/UX Designer',
    'Cloud Engineer',
  ];

  String get userId => FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    emailController.text = FirebaseAuth.instance.currentUser?.email ?? '';
    loadProfile();
  }

  Future<void> loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    try {
      final data = await _userService.getCurrentUserProfileData();

      if (!mounted) return;

      if (data != null && data['hasProfile'] == true) {
        setState(() {
          nameController.text = data['name'] ?? data['fullName'] ?? '';
          emailController.text = data['email'] ?? user.email ?? '';
          phoneController.text = data['phone'] ?? '';
          skillSetController.text = data['skillSet'] ?? '';
          selectedJob =
              data['interestedJob'] ??
              data['careerInterest'] ??
              'Mobile App Developer';
          profileExists = true;
        });
      }
    } catch (e) {
      debugPrint('Load profile error: $e');
    }
  }

  Future<void> saveProfile() async {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        skillSetController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    try {
      await _userService.saveFrontendProfile(
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text,
        skillSet: skillSetController.text,
        interestedJob: selectedJob,
      );

      if (!mounted) return;

      setState(() {
        profileExists = true;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Save failed: $e')));
    } catch (e) {
      debugPrint('Save error: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Save failed: $e')));
    }
  }

  Future<void> deleteProfile() async {
    try {
      await _userService.clearFrontendProfile();

      if (!mounted) return;

      setState(() {
        nameController.clear();
        emailController.text = FirebaseAuth.instance.currentUser?.email ?? '';
        phoneController.clear();
        skillSetController.clear();
        selectedJob = 'Mobile App Developer';
        profileExists = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile deleted')));
    } catch (e) {
      debugPrint('Delete error: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
    }
  }

  Widget inputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text('Manage User Profile'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.manage_accounts, size: 70, color: Colors.indigo),
            const SizedBox(height: 10),
            Text(
              profileExists ? 'Edit Your Profile' : 'Create Your Profile',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),

            inputField(
              label: 'Name',
              icon: Icons.person,
              controller: nameController,
            ),

            inputField(
              label: 'Email',
              icon: Icons.email,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),

            inputField(
              label: 'Phone Number',
              icon: Icons.phone,
              controller: phoneController,
              keyboardType: TextInputType.phone,
            ),

            inputField(
              label: 'Skill Set',
              icon: Icons.psychology,
              controller: skillSetController,
              maxLines: 3,
            ),

            DropdownButtonFormField<String>(
              initialValue: selectedJob,
              decoration: InputDecoration(
                labelText: 'Interested Job',
                prefixIcon: const Icon(Icons.work),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              items: jobOptions.map((job) {
                return DropdownMenuItem(value: job, child: Text(job));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedJob = value!;
                });
              },
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                onPressed: saveProfile,
                icon: const Icon(Icons.save),
                label: Text(profileExists ? 'Update Profile' : 'Save Profile'),
              ),
            ),

            const SizedBox(height: 12),

            if (profileExists)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                  onPressed: deleteProfile,
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete Profile'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ViewProfileScreen extends StatefulWidget {
  const ViewProfileScreen({super.key});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  final PortfolioService _portfolioService = PortfolioService();
  final UserService _userService = UserService();

  bool _isAddingProject = false;

  Future<void> _addSampleProject() async {
    setState(() {
      _isAddingProject = true;
    });

    try {
      await _portfolioService.addProject(
        title: 'Early Career Assistance App',
        description:
            'A Flutter and Firebase app that helps students explore careers, analyse skill gaps, build resumes, and showcase projects.',
        technologies: ['Flutter', 'Firebase', 'Firestore', 'Firebase Auth'],
        githubUrl: 'https://github.com/example/early-career-assistance-app',
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Portfolio project added.')));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Add project failed: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isAddingProject = false;
        });
      }
    }
  }

  Future<void> _deleteProject(String projectId) async {
    try {
      await _portfolioService.deleteProject(projectId: projectId);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Portfolio project deleted.')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Delete project failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text('My Portfolio'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _userService.getCurrentUserProfileData(),
        builder: (context, profileSnapshot) {
          if (profileSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = profileSnapshot.data;

          if (data == null || data['hasProfile'] != true) {
            return const Center(
              child: Text(
                'No portfolio found. Please create your profile first.',
              ),
            );
          }

          final name = data['name'] ?? data['fullName'] ?? '';
          final careerInterest =
              data['interestedJob'] ?? data['careerInterest'] ?? '';
          final email = data['email'] ?? '';
          final phone = data['phone'] ?? '';
          final skillSet = data['skillSet'] ?? '';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.indigo,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        name.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        careerInterest.toString(),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                portfolioCard(Icons.email, 'Email', email.toString()),
                portfolioCard(Icons.phone, 'Phone', phone.toString()),
                portfolioCard(Icons.psychology, 'Skills', skillSet.toString()),
                portfolioCard(
                  Icons.work,
                  'Career Interest',
                  careerInterest.toString(),
                ),

                const SizedBox(height: 25),

                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Projects',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _isAddingProject ? null : _addSampleProject,
                      icon: _isAddingProject
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.add),
                      label: Text(_isAddingProject ? 'Adding...' : 'Add'),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                StreamBuilder<List<PortfolioProject>>(
                  stream: _portfolioService.getMyProjects(),
                  builder: (context, projectSnapshot) {
                    if (projectSnapshot.hasError) {
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.error, color: Colors.red),
                          title: Text('Error: ${projectSnapshot.error}'),
                        ),
                      );
                    }

                    if (projectSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final projects = projectSnapshot.data ?? [];

                    if (projects.isEmpty) {
                      return const Card(
                        child: ListTile(
                          leading: Icon(Icons.info, color: Colors.indigo),
                          title: Text('No portfolio projects yet.'),
                          subtitle: Text(
                            'Tap Add to create a sample portfolio project.',
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: projects.map((project) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: const Icon(
                              Icons.folder,
                              color: Colors.indigo,
                            ),
                            title: Text(project.title),
                            subtitle: Text(
                              '${project.description}\n\n'
                              'Technologies: ${project.technologies.join(', ')}',
                            ),
                            isThreeLine: true,
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteProject(project.id),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static Widget portfolioCard(IconData icon, String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: ListTile(
        leading: Icon(icon, color: Colors.indigo),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}

class ResumeBuilderScreen extends StatefulWidget {
  const ResumeBuilderScreen({super.key});

  @override
  State<ResumeBuilderScreen> createState() => _ResumeBuilderScreenState();
}

class _ResumeBuilderScreenState extends State<ResumeBuilderScreen> {
  final ResumeService _resumeService = ResumeService();

  bool _isSaving = false;

  String get userId => FirebaseAuth.instance.currentUser!.uid;

  Future<void> _saveResume(Map<String, dynamic> profileData) async {
    setState(() {
      _isSaving = true;
    });

    try {
      final resume = ResumeData(
        id: '',
        personalDetails: {
          'fullName': profileData['name'] ?? profileData['fullName'] ?? '',
          'email': profileData['email'] ?? '',
          'phone': profileData['phone'] ?? '',
          'location': 'Australia',
        },
        summary:
            'Motivated and passionate ${profileData['interestedJob'] ?? profileData['careerInterest'] ?? 'IT student'} seeking opportunities to grow professionally and contribute technical skills to innovative projects.',
        education: const [
          {
            'institution': 'Kent Institute Australia',
            'degree': 'Bachelor of Information Technology',
            'startYear': '2024',
            'endYear': 'Present',
          },
        ],
        skills: _parseSkills(profileData['skillSet']?.toString() ?? ''),
        projects: const [
          {
            'title': 'Early Career Assistance App',
            'description':
                'A Flutter and Firebase app that helps students explore careers, analyse skill gaps, build resumes, and showcase projects.',
            'technologies': ['Flutter', 'Firebase', 'Firestore'],
          },
        ],
        experience: const [],
        createdAt: null,
        updatedAt: null,
      );

      final resumeId = await _resumeService.createResume(resumeData: resume);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resume saved successfully. ID: $resumeId')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Resume save failed: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  List<String> _parseSkills(String skillsText) {
    return skillsText
        .split(',')
        .map((skill) => skill.trim())
        .where((skill) => skill.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text('Resume Builder'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData ||
              !snapshot.data!.exists ||
              ((snapshot.data!.data() as Map<String, dynamic>)['hasProfile'] !=
                  true)) {
            return const Center(
              child: Text('Please create your profile first'),
            );
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final name = data['name'] ?? data['fullName'] ?? '';
          final interestedJob =
              data['interestedJob'] ?? data['careerInterest'] ?? '';
          final skills = data['skillSet'] ?? '';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.indigo,
                            child: Icon(
                              Icons.person,
                              size: 45,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            name.toString(),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            interestedJob.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    resumeSection(
                      title: 'Contact Information',
                      content: '${data['email']}\n${data['phone']}',
                    ),
                    resumeSection(title: 'Skills', content: skills.toString()),
                    resumeSection(
                      title: 'Career Objective',
                      content:
                          'Motivated and passionate $interestedJob seeking opportunities to grow professionally and contribute technical skills to innovative projects.',
                    ),
                    resumeSection(
                      title: 'Education',
                      content: 'Bachelor of Information Technology',
                    ),
                    resumeSection(
                      title: 'Projects',
                      content:
                          'Early Career Assistance App\nStudent Management System\nFirebase Portfolio App',
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _isSaving ? null : () => _saveResume(data),
                        icon: _isSaving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.save),
                        label: Text(_isSaving ? 'Saving...' : 'Save Resume'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  static Widget resumeSection({
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(fontSize: 16)),
          const Divider(height: 28),
        ],
      ),
    );
  }
}

class SkillGapAnalyzerScreen extends StatefulWidget {
  const SkillGapAnalyzerScreen({super.key});

  @override
  State<SkillGapAnalyzerScreen> createState() => _SkillGapAnalyzerScreenState();
}

class _SkillGapAnalyzerScreenState extends State<SkillGapAnalyzerScreen> {
  final UserService _userService = UserService();
  final CareerService _careerService = CareerService();
  final SkillGapService _skillGapService = SkillGapService();
  final RecommendationService _recommendationService = RecommendationService();

  bool _isLoading = true;
  bool _isAnalysing = false;

  Map<String, dynamic>? _profileData;
  List<Career> _careers = [];
  Career? _selectedCareer;
  SkillGapResult? _latestResult;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final profileData = await _userService.getCurrentUserProfileData();
      final careers = await _careerService.getCareers().first;

      Career? selectedCareer;

      if (profileData != null) {
        final interestedJob =
            profileData['interestedJob'] ?? profileData['careerInterest'];

        if (interestedJob != null && interestedJob.toString().isNotEmpty) {
          selectedCareer = careers.where((career) {
            return career.title.toLowerCase() ==
                interestedJob.toString().toLowerCase();
          }).firstOrNull;
        }
      }

      selectedCareer ??= careers.isNotEmpty ? careers.first : null;

      if (!mounted) return;

      setState(() {
        _profileData = profileData;
        _careers = careers;
        _selectedCareer = selectedCareer;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  List<String> _parseUserSkills(String skillsText) {
    return skillsText
        .split(',')
        .map((skill) => skill.trim())
        .where((skill) => skill.isNotEmpty)
        .toList();
  }

  Future<void> _analyseSkillGap() async {
    final selectedCareer = _selectedCareer;
    final profileData = _profileData;

    if (selectedCareer == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No career selected.')));
      return;
    }

    if (profileData == null || profileData['hasProfile'] != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please create your profile first.')),
      );
      return;
    }

    final userSkills = _parseUserSkills(
      profileData['skillSet']?.toString() ?? '',
    );

    if (userSkills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add skills to your profile first.'),
        ),
      );
      return;
    }

    setState(() {
      _isAnalysing = true;
      _errorMessage = null;
    });

    try {
      final result = await _skillGapService.analyseSkillGap(
        careerId: selectedCareer.id,
        userSkills: userSkills,
      );

      await _recommendationService.generateRecommendations(
        careerId: result.selectedCareerId,
        missingSkills: result.missingSkills,
      );

      if (!mounted) return;

      setState(() {
        _latestResult = result;
        _isAnalysing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Skill gap analysis completed.')),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString();
        _isAnalysing = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Analysis failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileData = _profileData;
    final latestResult = _latestResult;

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF4F6FA),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text('Skill Gap Analyzer'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_errorMessage != null)
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),

            if (profileData == null || profileData['hasProfile'] != true)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Please create your profile first.'),
                ),
              )
            else ...[
              Card(
                color: Colors.indigo,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.analytics,
                        color: Colors.white,
                        size: 45,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          latestResult == null
                              ? 'Analyse your skills against career requirements'
                              : '${latestResult.matchPercentage}% Match for ${latestResult.careerTitle}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'Your Skills: ${profileData['skillSet'] ?? ''}',
                style: const TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<Career>(
                initialValue: _selectedCareer,
                decoration: InputDecoration(
                  labelText: 'Select Career',
                  prefixIcon: const Icon(Icons.work),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                items: _careers.map((career) {
                  return DropdownMenuItem<Career>(
                    value: career,
                    child: Text(career.title),
                  );
                }).toList(),
                onChanged: (career) {
                  setState(() {
                    _selectedCareer = career;
                  });
                },
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _isAnalysing ? null : _analyseSkillGap,
                  icon: _isAnalysing
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.analytics),
                  label: Text(_isAnalysing ? 'Analysing...' : 'Analyse Skills'),
                ),
              ),

              if (latestResult != null) ...[
                const SizedBox(height: 25),

                const Text(
                  'Matched Skills',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                if (latestResult.matchedSkills.isEmpty)
                  const Text('No matching skills found yet.')
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: latestResult.matchedSkills.map((skill) {
                      return Chip(
                        label: Text(skill),
                        avatar: const Icon(Icons.check, color: Colors.green),
                      );
                    }).toList(),
                  ),

                const SizedBox(height: 25),

                const Text(
                  'Missing Skills',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                if (latestResult.missingSkills.isEmpty)
                  const Text('Great! You have all required skills.')
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: latestResult.missingSkills.map((skill) {
                      return Chip(
                        label: Text(skill),
                        avatar: const Icon(Icons.close, color: Colors.red),
                      );
                    }).toList(),
                  ),

                const SizedBox(height: 25),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      latestResult.missingSkills.isEmpty
                          ? 'Recommendation: You are strongly prepared for this role.'
                          : 'Recommendation: Focus on learning ${latestResult.missingSkills.join(", ")} to improve your career readiness.',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RecommendationListScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.recommend),
                    label: const Text('View Learning Recommendations'),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class RecommendationListScreen extends StatelessWidget {
  const RecommendationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recommendationService = RecommendationService();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text('Recommendations'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<RecommendationItem>>(
        stream: recommendationService.getMyRecommendations(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final recommendations = snapshot.data ?? [];

          if (recommendations.isEmpty) {
            return const Center(
              child: Text('No recommendations generated yet.'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: recommendations.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = recommendations[index];

              return Card(
                child: ListTile(
                  leading: const Icon(Icons.school, color: Colors.indigo),
                  title: Text(item.title.isEmpty ? 'No title' : item.title),
                  subtitle: Text(
                    '${item.missingSkill} • ${item.provider}\n${item.type} • ${item.priority}',
                  ),
                  trailing: item.url.isEmpty
                      ? null
                      : const Icon(Icons.open_in_new),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class RecommendedJobListScreen extends StatelessWidget {
  final String jobTitle;

  const RecommendedJobListScreen({super.key, required this.jobTitle});

  static final Map<String, List<Map<String, String>>> jobListings = {
    'Mobile App Developer': [
      {
        'title': 'Junior Flutter Developer',
        'company': 'TechStart Solutions',
        'location': 'Melbourne',
      },
      {
        'title': 'Mobile App Intern',
        'company': 'AppWorks Studio',
        'location': 'Remote',
      },
    ],
    'Web Developer': [
      {
        'title': 'Junior Web Developer',
        'company': 'Digital Hive',
        'location': 'Sydney',
      },
      {
        'title': 'Frontend Developer Intern',
        'company': 'Creative Web Co.',
        'location': 'Remote',
      },
    ],
    'Data Analyst': [
      {
        'title': 'Graduate Data Analyst',
        'company': 'Insight Analytics',
        'location': 'Melbourne',
      },
      {
        'title': 'Business Intelligence Intern',
        'company': 'DataCore',
        'location': 'Remote',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final jobs = jobListings[jobTitle] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(jobTitle),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: jobs.isEmpty
          ? const Center(child: Text('No jobs available for this role yet.'))
          : ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];

                return Card(
                  margin: const EdgeInsets.all(12),
                  child: ListTile(
                    leading: const Icon(Icons.work, color: Colors.indigo),
                    title: Text(job['title'] ?? ''),
                    subtitle: Text('${job['company']} • ${job['location']}'),
                    trailing: ElevatedButton(
                      onPressed: () async {
                        await JobApplicationService().applyForJob(
                          jobTitle: job['title'] ?? '',
                          company: job['company'] ?? '',
                          location: job['location'] ?? '',
                          category: jobTitle,
                        );

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Applied for ${job['title']}'),
                          ),
                        );
                      },
                      child: const Text('Apply'),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
