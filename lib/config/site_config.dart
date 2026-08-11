/// ============================================================
/// SITE CONFIG
/// Edit everything here — name, contact info, links, projects,
/// screenshots, skills, experience. Nothing else in the codebase
/// needs to change when you update your info.
/// ============================================================
library;

class Stat {
  const Stat({required this.label, required this.value, this.suffix = ''});
  final String label;
  final double value;
  final String suffix;

  int get decimals => value % 1 != 0 ? 1 : 0;
}

class Skill {
  const Skill(this.name, this.level);
  final String name;
  final int level;
}

class SkillGroup {
  const SkillGroup({required this.group, required this.skills});
  final String group;
  final List<Skill> skills;
}

class ExperienceEntry {
  const ExperienceEntry({
    required this.company,
    required this.role,
    required this.duration,
    required this.points,
  });
  final String company;
  final String role;
  final String duration;
  final List<String> points;
}

class Project {
  const Project({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.role,
    required this.tech,
    required this.features,
    required this.challenges,
    required this.solutions,
    this.thumb = '',
    this.gallery = const [],
    this.android = '',
    this.ios = '',
    this.github = '',
    this.live = '',
  });

  final String id;
  final String name;
  final String tagline;
  final String description;
  final String role;
  final List<String> tech;
  final List<String> features;
  final String challenges;
  final String solutions;
  final String thumb;
  final List<String> gallery;
  final String android;
  final String ios;
  final String github;
  final String live;

  String get shortDescription => description.length > 100
      ? '${description.substring(0, 97)}…'
      : description;
}

/// Icon keys are resolved to real icons in `sections/services_section.dart`.
enum ServiceIcon { flutter, api, payment, publish, ui, perf }

class Service {
  const Service({required this.title, required this.icon, required this.desc});
  final String title;
  final ServiceIcon icon;
  final String desc;
}

class Certification {
  const Certification({
    required this.title,
    required this.issuer,
    required this.year,
    this.link = '',
  });
  final String title;
  final String issuer;
  final String year;
  final String link;
}

class Education {
  const Education({
    required this.degree,
    required this.school,
    required this.meta,
  });
  final String degree;
  final String school;
  final String meta;
}

class SiteConfig {
  const SiteConfig._();

  // ---------- Identity ----------
  static const String name = 'Philemon Pushparaj';
  static const String firstName = 'Philemon';
  static const String role = 'Flutter Developer';
  static const List<String> taglineRoles = [
    'Flutter Developer',
    'Android Developer',
    'iOS Developer',
    'Cross-Platform Developer',
    'Mobile App Engineer',
  ];
  static const String summary =
      'Flutter Developer with 4+ years of experience building scalable Android & iOS '
      'applications across Food Delivery, Healthcare, Matrimony, Logistics and Job '
      'Marketplace domains.';
  static const String photo = 'assets/img/p1.png';
  static const String location = 'Chennai, Tamil Nadu, India';

  // ---------- Contact ----------
  static const String phone = '+91 8825739779';
  static const String whatsapp = '918825739779'; // digits only, for wa.me links
  static const String email = 'jpushparaj2021@gmail.com';
  static const String linkedin =
      'https://www.linkedin.com/in/j-philemon-pushparaj-85bb9a28b/';
  static const String github = 'https://github.com/'; // TODO: add handle
  static const String portfolio = 'https://your-portfolio-domain.com'; // TODO
  static const String instagram = 'https://instagram.com/'; // TODO
  static const String resumeFile =
      'assets/resume/Philemon Pushparaj_Flutter_Developer _4_Yr_Exp.pdf';

  // ---------- Hero stats (About section counters) ----------
  static const List<Stat> stats = [
    Stat(label: 'Years Experience', value: 4, suffix: '+'),
    Stat(label: 'Production Apps', value: 10, suffix: '+'),
    Stat(label: 'REST APIs Integrated', value: 50, suffix: '+'),
    Stat(label: 'Play Store & App Store Apps', value: 8, suffix: '+'),
  ];

  static const List<String> domains = [
    'Food Delivery',
    'Healthcare',
    'Grocery',
    'Pharmacy',
    'Logistics',
    'Matrimony',
    'Job Marketplace',
  ];

  // ---------- Skills ----------
  static const List<SkillGroup> skillGroups = [
    SkillGroup(
      group: 'Languages & Frameworks',
      skills: [
        Skill('Dart', 95),
        Skill('Flutter', 96),
        Skill('Java', 70),
        Skill('Firebase', 88),
      ],
    ),
    SkillGroup(
      group: 'State Management',
      skills: [Skill('GetX', 93), Skill('Bloc', 78), Skill('Riverpod', 65)],
    ),
    SkillGroup(
      group: 'Data & APIs',
      skills: [
        Skill('REST APIs', 92),
        Skill('Firebase Firestore', 85),
        Skill('SQLite', 80),
        Skill('MongoDB', 68),
      ],
    ),
    SkillGroup(
      group: 'Maps, Payments & Notifications',
      skills: [
        Skill('Google Maps API', 87),
        Skill('Geolocation & Routing', 85),
        Skill('Razorpay / Stripe', 84),
        Skill('Firebase Cloud Messaging', 88),
      ],
    ),
    SkillGroup(
      group: 'Tools',
      skills: [
        Skill('Git / GitHub / Bitbucket', 90),
        Skill('Postman', 88),
        Skill('Android Studio / VS Code', 92),
        Skill('Figma', 60),
      ],
    ),
  ];

  // ---------- Work Experience ----------
  static const List<ExperienceEntry> experience = [
    ExperienceEntry(
      company: 'Bytesflow Technologies',
      role: 'Flutter Developer',
      duration: 'Jan 2024 — Present',
      points: [
        'Developed and maintained 8+ cross-platform Flutter applications serving 10,000+ users.',
        'Reduced development time by 30% through reusable widget architecture and state management using GetX and Bloc.',
        'Integrated 50+ REST APIs, payment gateways (Stripe, Razorpay), Google Maps, and Firebase services.',
        'Improved application performance by 20% through code optimization and efficient state management.',
        'Successfully published and maintained applications on both Google Play Store and Apple App Store.',
      ],
    ),
    ExperienceEntry(
      company: 'Appxperts Enterprise Solution',
      role: 'Junior Flutter Developer',
      duration: 'May 2023 — Dec 2023',
      points: [
        'Built reusable UI components and integrated REST APIs.',
        'Collaborated with QA, UI/UX, and backend teams in Agile environments.',
      ],
    ),
  ];

  // ---------- Projects ----------
  static const List<Project> projects = [
    Project(
      id: 'delicart',
      name: 'Delicart',
      tagline: 'Multi-Service Delivery Super App',
      description:
          'A multi-service delivery platform supporting Food, Grocery, Pharmacy and Alcohol '
          'delivery, plus Cab and Room booking — with real-time tracking and integrated payments.',
      role:
          'Flutter Developer — architecture, API integration, real-time tracking',
      tech: [
        'Flutter',
        'GetX',
        'Firebase',
        'Google Maps',
        'Razorpay',
        'Stripe',
      ],
      features: [
        'Real-time order & rider tracking on live map',
        'Unified checkout across Food, Grocery, Pharmacy, Cab & Room booking',
        'Firebase Cloud Messaging for order status updates',
        'Secure multi-gateway payments',
      ],
      challenges:
          'Coordinating five distinct service verticals inside a single, consistent booking '
          'and order-tracking flow without fragmenting the codebase.',
      solutions:
          'Built a shared GetX controller layer and modular route/service architecture so each '
          'vertical reuses the same tracking, payment and notification core.',
      thumb: 'assets/img/01_delicart.png',
      gallery: [
        'assets/screenshots/delicart_1.png',
        'assets/screenshots/delicart_2.png',
        'assets/screenshots/delicart_3.png',
      ],
      android:
          'https://play.google.com/store/apps/details?id=com.delicart.user&pcampaignid=web_share',
      ios: 'https://apps.apple.com/in/app/delicart/id6736678172',
    ),

    Project(
      id: 'deliware',
      name: 'Deliware',
      tagline: 'Food Delivery Application',
      description:
          'A Flutter-based food delivery app covering customer ordering, restaurant management '
          'and live delivery tracking end to end.',
      role:
          'Flutter Developer — Google Maps integration, payments, state management',
      tech: [
        'Flutter',
        'GetX',
        'Firebase',
        'Google Maps',
        'Stripe',
        'Razorpay',
      ],
      features: [
        'Google Maps route optimization & live order tracking',
        'Firebase Cloud Messaging for real-time order updates',
        'Stripe & Razorpay payment gateways',
        'Optimized API handling with GetX',
      ],
      challenges:
          'Keeping order state and live location updates in sync in real time across customer, '
          'restaurant and rider views.',
      solutions:
          'Used a centralized reactive state layer with GetX observables and geolocation '
          'streaming to keep every screen in sync with minimal rebuilds.',
      thumb: 'assets/img/02_deliware.png',
      gallery: [
        'assets/screenshots/deliware_1.png',
        'assets/screenshots/deliware_2.png',
        'assets/screenshots/deliware_3.png',
      ],
      android:
          'https://play.google.com/store/apps/details?id=com.deliware.userapp&pcampaignid=web_share',
      ios: 'https://apps.apple.com/in/app/deliware-food-delivery/id1511539716',
    ),

    Project(
      id: 'delivery-rider',
      name: 'Delivery Rider',
      tagline: 'Rider Companion App',
      description:
          'A dedicated rider-side application for live order tracking, route navigation, ETA '
          'calculation and end-to-end order workflow management.',
      role: 'Flutter Developer — rider workflow, live tracking, navigation',
      tech: ['Flutter', 'GetX', 'Google Maps', 'Firebase'],
      features: [
        'Turn-by-turn route navigation',
        'Live ETA calculation',
        'Order acceptance & workflow state machine',
        'Background location tracking',
      ],
      challenges:
          'Refactoring a monolithic rider signup flow into a maintainable structure while '
          'chasing down layout crashes under scroll.',
      solutions:
          'Split the signup screen into a clean GetX controller/view architecture and resolved '
          'layout constraints so the flow renders reliably across devices.',
      thumb: 'assets/img/03_delivery_rider.png',
      gallery: [
        'assets/screenshots/rider_1.png',
        'assets/screenshots/rider_2.png',
      ],
      android:
          'https://play.google.com/store/apps/details?id=com.deliware.delicartdelivery&pcampaignid=web_share',
      ios: 'https://apps.apple.com/in/app/delicart-partner/id1519923845',
    ),
    Project(
      id: 'restaurant-admin',
      name: 'Restaurant Admin',
      tagline: 'Order, Menu & Inventory Console',
      description:
          'A Flutter-based admin application for Android phones, tablets, iPhone and iPad, '
          'giving restaurants a single console for orders, menus, inventory and operations.',
      role:
          'Flutter Developer — responsive multi-device layout, analytics dashboard',
      tech: ['Flutter', 'GetX', 'Firebase', 'REST APIs'],
      features: [
        'Real-time order management',
        'Sales analytics dashboard',
        'Push notifications',
        'Role-based access control',
        'Responsive layouts for phone, tablet & iPad',
      ],
      challenges:
          'One codebase needed to feel native across four very different screen sizes and '
          'input modes.',
      solutions:
          'Built adaptive layout breakpoints and reusable widget components so the same screens '
          'reflow cleanly from phone to tablet to iPad.',
      thumb: 'assets/img/04_restaurant_admin.png',
      gallery: [
        'assets/screenshots/restaurant_1.png',
        'assets/screenshots/restaurant_2.png',
      ],
      android:
          'https://play.google.com/store/apps/details?id=com.delicart.orders&pcampaignid=web_share',
      ios: 'https://apps.apple.com/in/app/delicart-orders/id6447287739',
    ),
    Project(
      id: 'noble-hospital',
      name: 'Noble Hospital',
      tagline: 'Hospital Management Application',
      description:
          'A healthcare application covering appointment booking, diagnostic test scheduling '
          'and family profile management.',
      role: 'Flutter Developer — booking flows, profile management',
      tech: ['Flutter', 'GetX', 'Firebase', 'REST APIs'],
      features: [
        'Appointment booking with slot selection',
        'Diagnostic test scheduling',
        'Family member profile management',
        'Appointment reminders via push notifications',
      ],
      challenges:
          'Modeling family accounts where one login manages several dependent patient profiles '
          'with separate histories.',
      solutions:
          'Designed a nested profile data model with a shared auth session, so switching '
          'between family members is instant and scoped correctly.',
      thumb: 'assets/img/05_noble_hospital.png',
      gallery: [
        'assets/screenshots/noble_1.png',
        'assets/screenshots/noble_2.png',
      ],
      android:
          'https://play.google.com/store/apps/details?id=com.noblehealthcare.mobile&pcampaignid=web_share',
      ios: 'https://apps.apple.com/in/app/noble-health-app/id6779511534',
    ),
    Project(
      id: 'matrimony',
      name: 'Chennai Matrimony & Tamil Varan',
      tagline: 'Matrimony Matching Platform',
      description:
          'A matrimony application for Android and iOS enabling profile creation, partner '
          'search with advanced filters, and secure connections.',
      role: 'Flutter Developer — auth, chat, subscriptions',
      tech: ['Flutter', 'Firebase', 'GetX', 'REST APIs'],
      features: [
        'Advanced partner preference filters',
        'Secure authentication',
        'Real-time chat',
        'Premium membership plans with in-app payments',
        'Push notifications',
      ],
      challenges:
          'Building a real-time chat and premium subscription system that stays secure and '
          'responsive at scale.',
      solutions:
          'Layered Firebase Firestore streams for chat with GetX reactive state, and gated '
          'premium features behind a clean subscription service.',
      thumb: 'assets/img/06_chennai_matrimony.png',
      gallery: [
        'assets/screenshots/matrimony_1.png',
        'assets/screenshots/matrimony_2.png',
      ],
      android:
          'https://play.google.com/store/apps/details?id=com.chennai.matrimony&pcampaignid=web_share',
      ios: 'https://apps.apple.com/in/app/chennai-matrimony/id6742679114',
    ),
    Project(
      id: 'snack-troop',
      name: 'Snack Troop',
      tagline: 'School Item Selling & Hamper Management App',
      description:
          'A school-focused item selling application where teachers create and manage '
          'snack hampers, scan and assign hamper kits to students, while students sell '
          'the assigned items and track their sales, earnings and hamper status in real time.',
      role:
          'Flutter Developer — application architecture, role-based authentication, '
          'QR/Barcode scanning, hamper management and real-time data tracking',
      tech: [
        'Flutter',
        'GetX',
        'Firebase',
        'REST APIs',
        'QR/Barcode Scanner',
        'Push Notifications',
      ],
      features: [
        'Separate Teacher and Student login flows',
        'Create and manage student snack hampers',
        'QR/Barcode scanning for hamper kit identification',
        'Scan and assign hamper kits directly to students',
        'Student-wise hamper and item sales tracking',
        'Real-time sales, stock and performance management',
        'Teacher dashboard with reports and analytics',
        'Student dashboard for hampers, sales and earnings',
        'Push notifications for hamper assignments and updates',
      ],
      challenges:
          'Managing two different user roles with separate workflows while keeping '
          'hamper assignments, QR scanning, inventory, student sales and reporting '
          'synchronized across the application.',
      solutions:
          'Built a role-based Flutter architecture using GetX with separate teacher '
          'and student modules. Implemented QR/Barcode scanning for unique hamper kits '
          'and centralized the hamper, assignment, sales and reporting data so teachers '
          'can monitor student activity while students can manage their assigned hampers '
          'and sales efficiently.',
      thumb: 'assets/img/image 2.png',
      gallery: [
        'assets/screenshots/snacktroop_1.png',
        'assets/screenshots/snacktroop_2.png',
        'assets/screenshots/snacktroop_3.png',
      ],
      android: '#',
      ios: '#',
    ),
  ];

  // ---------- Services ----------
  static const List<Service> services = [
    Service(
      title: 'Flutter App Development',
      icon: ServiceIcon.flutter,
      desc: 'End-to-end Flutter apps for Android & iOS from a single codebase.',
    ),
    Service(
      title: 'API & Firebase Integration',
      icon: ServiceIcon.api,
      desc: 'REST APIs, Firebase Auth, Firestore, Cloud Messaging and Storage.',
    ),
    Service(
      title: 'Payment Gateway Integration',
      icon: ServiceIcon.payment,
      desc: 'Razorpay, Stripe and in-app purchase flows, done securely.',
    ),
    Service(
      title: 'App Store Publishing',
      icon: ServiceIcon.publish,
      desc:
          'Play Store & App Store submissions, versioning and release management.',
    ),
    Service(
      title: 'UI Implementation',
      icon: ServiceIcon.ui,
      desc:
          'Pixel-accurate implementation from Figma designs, light & dark mode.',
    ),
    Service(
      title: 'Performance Optimization',
      icon: ServiceIcon.perf,
      desc:
          'Reducing rebuilds, jank and load time for a smoother app experience.',
    ),
  ];

  // ---------- Certifications (empty-friendly) ----------
  static const List<Certification> certifications = [
    // Certification(title: 'Certificate Name', issuer: 'Issuer', year: '2026'),
  ];

  // ---------- Education ----------
  static const List<Education> education = [
    Education(
      degree: 'B.E. Electrical & Electronics Engineering',
      school: 'Government College of Engineering, Trichy',
      meta: 'CGPA 7.01 · 2021',
    ),
    Education(
      degree: 'Higher Secondary Certificate (HSC)',
      school: 'Walker Higher Secondary School, TN State Board',
      meta: '93.5% · 2017',
    ),
    Education(
      degree: 'Secondary School Leaving Certificate (SSLC)',
      school: 'Walker Higher Secondary School, TN State Board',
      meta: '89.8% · 2015',
    ),
  ];
}
