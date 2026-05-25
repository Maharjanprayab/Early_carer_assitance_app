import 'package:cloud_firestore/cloud_firestore.dart';

class SeedDataService {
  SeedDataService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<void> seedCareersAndRecommendationRules() async {
    final careers = <String, Map<String, dynamic>>{
      'mobile_app_developer': {
        'title': 'Mobile App Developer',
        'category': 'Software Development',
        'description':
            'Builds mobile applications for Android and iOS using frameworks such as Flutter.',
        'averageSalary': 'AUD 70,000 - 100,000',
        'requiredSkills': [
          'Flutter',
          'Dart',
          'Firebase',
          'UI Design',
          'API Integration',
        ],
        'entryLevelRoles': [
          'Junior Flutter Developer',
          'Mobile App Intern',
          'Junior Mobile App Developer',
        ],
      },
      'web_developer': {
        'title': 'Web Developer',
        'category': 'Software Development',
        'description':
            'Builds websites and web applications using frontend and backend technologies.',
        'averageSalary': 'AUD 65,000 - 95,000',
        'requiredSkills': [
          'HTML',
          'CSS',
          'JavaScript',
          'React',
          'Firebase',
        ],
        'entryLevelRoles': [
          'Junior Web Developer',
          'Frontend Developer Intern',
          'Web Development Assistant',
        ],
      },
      'software_developer': {
        'title': 'Software Developer',
        'category': 'Software Development',
        'description':
            'Designs, develops, tests, and maintains software applications.',
        'averageSalary': 'AUD 75,000 - 110,000',
        'requiredSkills': [
          'Java',
          'Python',
          'Git',
          'SQL',
          'Problem Solving',
        ],
        'entryLevelRoles': [
          'Junior Software Developer',
          'Graduate Developer',
          'Software Engineering Intern',
        ],
      },
      'cyber_security_analyst': {
        'title': 'Cyber Security Analyst',
        'category': 'Cyber Security',
        'description':
            'Protects systems, networks, and data from cyber threats and security risks.',
        'averageSalary': 'AUD 80,000 - 120,000',
        'requiredSkills': [
          'Networking',
          'Linux',
          'Security Tools',
          'Risk Analysis',
          'SIEM',
        ],
        'entryLevelRoles': [
          'Junior Security Analyst',
          'SOC Analyst Intern',
          'Cyber Security Trainee',
        ],
      },
      'data_analyst': {
        'title': 'Data Analyst',
        'category': 'Data',
        'description':
            'Analyses data to identify trends, insights, and support business decisions.',
        'averageSalary': 'AUD 70,000 - 100,000',
        'requiredSkills': [
          'Excel',
          'SQL',
          'Python',
          'Power BI',
          'Data Visualization',
        ],
        'entryLevelRoles': [
          'Junior Data Analyst',
          'Reporting Analyst',
          'Business Intelligence Intern',
        ],
      },
      'ui_ux_designer': {
        'title': 'UI/UX Designer',
        'category': 'Design',
        'description':
            'Designs user-friendly interfaces and improves user experience through research and prototyping.',
        'averageSalary': 'AUD 65,000 - 95,000',
        'requiredSkills': [
          'Figma',
          'Wireframing',
          'User Research',
          'Prototyping',
          'Design Thinking',
        ],
        'entryLevelRoles': [
          'Junior UI/UX Designer',
          'UX Research Intern',
          'Product Design Assistant',
        ],
      },
      'cloud_engineer': {
        'title': 'Cloud Engineer',
        'category': 'Cloud Computing',
        'description':
            'Designs, deploys, and manages cloud infrastructure and services.',
        'averageSalary': 'AUD 85,000 - 130,000',
        'requiredSkills': [
          'AWS',
          'Azure',
          'Firebase',
          'Docker',
          'Cloud Security',
        ],
        'entryLevelRoles': [
          'Junior Cloud Engineer',
          'Cloud Support Associate',
          'DevOps Intern',
        ],
      },
    };

    final rules = <String, Map<String, dynamic>>{
      'mobile_flutter': {
        'careerId': 'mobile_app_developer',
        'skill': 'Flutter',
        'title': 'Learn Flutter Fundamentals',
        'type': 'Course',
        'provider': 'Flutter Documentation',
        'url': 'https://docs.flutter.dev/',
        'priority': 'High',
      },
      'mobile_dart': {
        'careerId': 'mobile_app_developer',
        'skill': 'Dart',
        'title': 'Learn Dart Programming',
        'type': 'Course',
        'provider': 'Dart Documentation',
        'url': 'https://dart.dev/language',
        'priority': 'High',
      },
      'mobile_firebase': {
        'careerId': 'mobile_app_developer',
        'skill': 'Firebase',
        'title': 'Learn Firebase for Flutter',
        'type': 'Course',
        'provider': 'Firebase Documentation',
        'url': 'https://firebase.google.com/docs/flutter/setup',
        'priority': 'High',
      },
      'mobile_ui_design': {
        'careerId': 'mobile_app_developer',
        'skill': 'UI Design',
        'title': 'Learn Mobile UI Design Basics',
        'type': 'Task',
        'provider': 'Material Design',
        'url': 'https://m3.material.io/',
        'priority': 'Medium',
      },
      'mobile_api_integration': {
        'careerId': 'mobile_app_developer',
        'skill': 'API Integration',
        'title': 'Practice REST API Integration',
        'type': 'Practice Task',
        'provider': 'Flutter Networking Guide',
        'url': 'https://docs.flutter.dev/cookbook/networking/fetch-data',
        'priority': 'Medium',
      },
      'web_html': {
        'careerId': 'web_developer',
        'skill': 'HTML',
        'title': 'Learn HTML Basics',
        'type': 'Course',
        'provider': 'MDN Web Docs',
        'url': 'https://developer.mozilla.org/en-US/docs/Web/HTML',
        'priority': 'High',
      },
      'web_css': {
        'careerId': 'web_developer',
        'skill': 'CSS',
        'title': 'Learn CSS Basics',
        'type': 'Course',
        'provider': 'MDN Web Docs',
        'url': 'https://developer.mozilla.org/en-US/docs/Web/CSS',
        'priority': 'High',
      },
      'web_javascript': {
        'careerId': 'web_developer',
        'skill': 'JavaScript',
        'title': 'Learn JavaScript Basics',
        'type': 'Course',
        'provider': 'MDN Web Docs',
        'url': 'https://developer.mozilla.org/en-US/docs/Web/JavaScript',
        'priority': 'High',
      },
      'web_react': {
        'careerId': 'web_developer',
        'skill': 'React',
        'title': 'Learn React Fundamentals',
        'type': 'Course',
        'provider': 'React Documentation',
        'url': 'https://react.dev/learn',
        'priority': 'High',
      },
      'data_excel': {
        'careerId': 'data_analyst',
        'skill': 'Excel',
        'title': 'Practice Excel for Data Analysis',
        'type': 'Practice Task',
        'provider': 'Microsoft Support',
        'url': 'https://support.microsoft.com/excel',
        'priority': 'Medium',
      },
      'data_sql': {
        'careerId': 'data_analyst',
        'skill': 'SQL',
        'title': 'Practice SQL Queries',
        'type': 'Practice Task',
        'provider': 'SQLBolt',
        'url': 'https://sqlbolt.com/',
        'priority': 'High',
      },
      'data_python': {
        'careerId': 'data_analyst',
        'skill': 'Python',
        'title': 'Learn Python for Data Analysis',
        'type': 'Course',
        'provider': 'Python Documentation',
        'url': 'https://docs.python.org/3/tutorial/',
        'priority': 'High',
      },
      'data_power_bi': {
        'careerId': 'data_analyst',
        'skill': 'Power BI',
        'title': 'Learn Power BI Basics',
        'type': 'Course',
        'provider': 'Microsoft Learn',
        'url': 'https://learn.microsoft.com/power-bi/',
        'priority': 'Medium',
      },
      'software_java': {
        'careerId': 'software_developer',
        'skill': 'Java',
        'title': 'Learn Java Programming',
        'type': 'Course',
        'provider': 'Oracle Java Documentation',
        'url': 'https://docs.oracle.com/en/java/',
        'priority': 'High',
      },
      'software_python': {
        'careerId': 'software_developer',
        'skill': 'Python',
        'title': 'Learn Python Programming',
        'type': 'Course',
        'provider': 'Python Documentation',
        'url': 'https://docs.python.org/3/tutorial/',
        'priority': 'High',
      },
      'software_git': {
        'careerId': 'software_developer',
        'skill': 'Git',
        'title': 'Learn Git and GitHub',
        'type': 'Course',
        'provider': 'GitHub Skills',
        'url': 'https://skills.github.com/',
        'priority': 'Medium',
      },
      'software_sql': {
        'careerId': 'software_developer',
        'skill': 'SQL',
        'title': 'Practice SQL Queries',
        'type': 'Practice Task',
        'provider': 'SQLBolt',
        'url': 'https://sqlbolt.com/',
        'priority': 'Medium',
      },
      'cyber_networking': {
        'careerId': 'cyber_security_analyst',
        'skill': 'Networking',
        'title': 'Learn Networking Basics',
        'type': 'Course',
        'provider': 'Cisco Skills for All',
        'url': 'https://skillsforall.com/',
        'priority': 'High',
      },
      'cyber_linux': {
        'careerId': 'cyber_security_analyst',
        'skill': 'Linux',
        'title': 'Learn Linux Command Line',
        'type': 'Course',
        'provider': 'Linux Journey',
        'url': 'https://linuxjourney.com/',
        'priority': 'High',
      },
      'cyber_risk_analysis': {
        'careerId': 'cyber_security_analyst',
        'skill': 'Risk Analysis',
        'title': 'Learn Cyber Risk Management',
        'type': 'Course',
        'provider': 'NIST Cybersecurity Framework',
        'url': 'https://www.nist.gov/cyberframework',
        'priority': 'Medium',
      },
      'cloud_aws': {
        'careerId': 'cloud_engineer',
        'skill': 'AWS',
        'title': 'Learn AWS Cloud Basics',
        'type': 'Course',
        'provider': 'AWS Skill Builder',
        'url': 'https://skillbuilder.aws/',
        'priority': 'High',
      },
      'cloud_azure': {
        'careerId': 'cloud_engineer',
        'skill': 'Azure',
        'title': 'Learn Microsoft Azure Fundamentals',
        'type': 'Course',
        'provider': 'Microsoft Learn',
        'url': 'https://learn.microsoft.com/azure/',
        'priority': 'High',
      },
      'cloud_docker': {
        'careerId': 'cloud_engineer',
        'skill': 'Docker',
        'title': 'Learn Docker Basics',
        'type': 'Course',
        'provider': 'Docker Documentation',
        'url': 'https://docs.docker.com/get-started/',
        'priority': 'Medium',
      },
    };

    final batch = _firestore.batch();

    for (final entry in careers.entries) {
      final ref = _firestore.collection('careers').doc(entry.key);
      batch.set(ref, entry.value, SetOptions(merge: true));
    }

    for (final entry in rules.entries) {
      final ref = _firestore.collection('recommendationRules').doc(entry.key);
      batch.set(ref, entry.value, SetOptions(merge: true));
    }

    await batch.commit();
  }
}