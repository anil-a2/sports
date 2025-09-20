import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'dart:collection'; // For SplayTreeSet
import 'package:fl_chart/fl_chart.dart'; // Import fl_chart
import 'dart:math';

// -----------------------------------------------------------------------------
// TOP-LEVEL INITIAL DATA (Adhering to "initialized when constructing the data model, not in the build function(s)")
// -----------------------------------------------------------------------------

// Initial data for the current athlete profile
final AnthropometricData _currentUserAnthropometrics = AnthropometricData(
  heightCm: 175.5,
  weightKg: 72.3,
  bmi: 23.4,
);

final List<SportsHistoryEntry> _currentUserSportsHistory = <SportsHistoryEntry>[
  const SportsHistoryEntry(
      sportName: 'Football', period: '2010-2015', teamName: 'Local Club', achievements: 'Captain, Top Scorer'),
  const SportsHistoryEntry(
      sportName: 'Athletics (Sprint)', period: '2016-Present', teamName: 'University Team', achievements: 'National Level Medalist'),
];

final List<TrainingGoal> _currentUserTrainingGoals = <TrainingGoal>[
  const TrainingGoal(goalDescription: 'Improve 100m sprint time', targetDate: '2024-12-31', currentProgress: 9, targetValue: 10),
  const TrainingGoal(goalDescription: 'Increase vertical jump by 5cm', targetDate: '2024-10-15', currentProgress: 3, targetValue: 5),
];

final List<BadgeData> _currentUserBadges = <BadgeData>[
  BadgeData(title: 'Speedster', icon: Icons.fast_forward, color: Colors.blue.shade700),
  BadgeData(title: 'Endurance King', icon: Icons.directions_run, color: Colors.green.shade700),
  BadgeData(title: 'Top Jumper', icon: Icons.sports_gymnastics, color: Colors.purple.shade700),
  BadgeData(title: 'Iron Lungs', icon: Icons.spa, color: Colors.lightBlue.shade700),
  BadgeData(title: 'Precision Passer', icon: Icons.sports_soccer, color: Colors.orange.shade700),
  BadgeData(title: 'Tactical Genius', icon: Icons.military_tech, color: Colors.grey.shade700),
];

final List<AchievementData> _currentUserAchievements = <AchievementData>[
  AchievementData(
    title: 'National Gold Medal',
    description: 'Achieved 1st place in the 100m sprint at National Championships.',
    icon: Icons.emoji_events,
    color: Colors.amber.shade700,
  ),
  AchievementData(
    title: 'Personal Best - 30m Sprint',
    description: 'Set a new personal record of 3.8 seconds in the 30m sprint test.',
    icon: Icons.timer,
    color: Colors.green.shade700,
  ),
];

final List<PerformanceTestResult> _currentUserPerformanceResults = <PerformanceTestResult>[
  const PerformanceTestResult(
      testType: '30m Sprint', resultValue: 4.2, unit: 's', date: '2023-01-10', trendIcon: Icons.arrow_downward, trendColor: Colors.red, normalizedScore: 80),
  const PerformanceTestResult(
      testType: 'Vertical Jump', resultValue: 65, unit: 'cm', date: '2023-02-15', trendIcon: Icons.arrow_upward, trendColor: Colors.green, normalizedScore: 75, videoUrl: 'https://example.com/video1.mp4'),
  const PerformanceTestResult(
      testType: 'Agility Drill', resultValue: 7.8, unit: 's', date: '2023-03-20', trendIcon: Icons.arrow_downward, trendColor: Colors.red, normalizedScore: 82),
  const PerformanceTestResult(
      testType: 'Long Jump', resultValue: 5.5, unit: 'm', date: '2023-04-25', trendIcon: Icons.arrow_upward, trendColor: Colors.green, normalizedScore: 70),
  const PerformanceTestResult(
      testType: '30m Sprint', resultValue: 4.0, unit: 's', date: '2023-05-30', trendIcon: Icons.arrow_upward, trendColor: Colors.green, normalizedScore: 90, videoUrl: 'https://example.com/video2.mp4'),
  const PerformanceTestResult(
      testType: 'Vertical Jump', resultValue: 68, unit: 'cm', date: '2023-06-05', trendIcon: Icons.arrow_upward, trendColor: Colors.green, normalizedScore: 80),
  const PerformanceTestResult(
      testType: '30m Sprint', resultValue: 3.9, unit: 's', date: '2023-07-10', trendIcon: Icons.arrow_upward, trendColor: Colors.green, normalizedScore: 95, videoUrl: 'https://example.com/video3.mp4'),
  const PerformanceTestResult(
      testType: 'Endurance Run (2km)', resultValue: 8.5, unit: 'min', date: '2023-08-01', trendIcon: Icons.arrow_downward, trendColor: Colors.red, normalizedScore: 60),
  const PerformanceTestResult(
      testType: 'Agility Drill', resultValue: 7.5, unit: 's', date: '2023-09-05', trendIcon: Icons.arrow_upward, trendColor: Colors.green, normalizedScore: 85),
];

final List<MetricData> _currentUserMlMetrics = <MetricData>[
  MetricData(title: 'Avg Reaction Time', value: '0.15s', color: Colors.blue.shade700, icon: Icons.flash_on),
  MetricData(title: 'Explosive Power Index', value: '8.7', color: Colors.red.shade700, icon: Icons.local_fire_department),
  MetricData(title: 'Movement Efficiency', value: '85%', color: Colors.green.shade700, icon: Icons.speed),
];

final List<AnalysisPointData> _currentUserMlFeedback = <AnalysisPointData>[
  AnalysisPointData(
      title: 'Strength: Explosive Take-off',
      content: 'Your initial push-off in sprints and jumps is excellent, contributing significantly to early acceleration.',
      color: Colors.green.shade700),
  AnalysisPointData(
      title: 'Area to Improve: Endurance Stamina',
      content: 'While your anaerobic capacity is high, sustained aerobic performance shows room for improvement.',
      color: Colors.orange.shade700),
  AnalysisPointData(
      title: 'Strength: Agility & Quick Direction Change',
      content: 'The AI detected superior ability in rapid changes of direction without losing momentum.',
      color: Colors.green.shade700),
];

const AthletePerformanceStats _currentUserPerformanceStats = AthletePerformanceStats(
  lastScore: 95,
  improvementPercentage: 12,
  rank: 15,
  totalActivities: 78,
);

final Athlete _currentUser = Athlete(
  name: 'Priya Sharma',
  age: 20,
  gender: 'Female',
  region: 'Gurugram',
  email: 'priya.sharma@example.com',
  profilePictureUrl: 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
  anthropometrics: _currentUserAnthropometrics,
  sportsHistory: _currentUserSportsHistory,
  trainingGoals: _currentUserTrainingGoals,
  badges: _currentUserBadges,
  achievements: _currentUserAchievements,
  performanceResults: _currentUserPerformanceResults,
  mlMetrics: _currentUserMlMetrics,
  mlFeedback: _currentUserMlFeedback,
  performanceStats: _currentUserPerformanceStats,
  score: 950,
  totalActivities: 78,
  mainSport: 'Athletics',
);

// Other Athletes for Leaderboard
final List<Athlete> _allAthletes = <Athlete>[
  _currentUser,
  // Sample data for other athletes
  Athlete(
    name: 'Arjun Singh',
    age: 22,
    gender: 'Male',
    region: 'Delhi',
    email: 'arjun.singh@example.com',
    profilePictureUrl: 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
    anthropometrics: const AnthropometricData(heightCm: 180, weightKg: 78, bmi: 24),
    sportsHistory: const <SportsHistoryEntry>[],
    trainingGoals: const <TrainingGoal>[],
    badges: const <BadgeData>[],
    achievements: const <AchievementData>[],
    performanceResults: const <PerformanceTestResult>[
      PerformanceTestResult(testType: '30m Sprint', resultValue: 3.9, unit: 's', date: '2023-01-01', trendIcon: Icons.arrow_upward, trendColor: Colors.green, normalizedScore: 96),
      PerformanceTestResult(testType: 'Vertical Jump', resultValue: 70, unit: 'cm', date: '2023-01-01', trendIcon: Icons.arrow_upward, trendColor: Colors.green, normalizedScore: 85),
    ],
    mlMetrics: const <MetricData>[],
    mlFeedback: const <AnalysisPointData>[],
    performanceStats: const AthletePerformanceStats(lastScore: 96, improvementPercentage: 10, rank: 1, totalActivities: 50),
    score: 980,
    totalActivities: 50,
    mainSport: 'Football',
  ),
  Athlete(
    name: 'Fatima Ahmed',
    age: 19,
    gender: 'Female',
    region: 'Mumbai',
    email: 'fatima.ahmed@example.com',
    profilePictureUrl: 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
    anthropometrics: const AnthropometricData(heightCm: 168, weightKg: 60, bmi: 21),
    sportsHistory: const <SportsHistoryEntry>[],
    trainingGoals: const <TrainingGoal>[],
    badges: const <BadgeData>[],
    achievements: const <AchievementData>[],
    performanceResults: const <PerformanceTestResult>[
      PerformanceTestResult(testType: '30m Sprint', resultValue: 4.1, unit: 's', date: '2023-01-01', trendIcon: Icons.arrow_upward, trendColor: Colors.green, normalizedScore: 90),
      PerformanceTestResult(testType: 'Agility Drill', resultValue: 7.0, unit: 's', date: '2023-01-01', trendIcon: Icons.arrow_upward, trendColor: Colors.green, normalizedScore: 92),
    ],
    mlMetrics: const <MetricData>[],
    mlFeedback: const <AnalysisPointData>[],
    performanceStats: const AthletePerformanceStats(lastScore: 92, improvementPercentage: 8, rank: 2, totalActivities: 60),
    score: 930,
    totalActivities: 60,
    mainSport: 'Badminton',
  ),
  Athlete(
    name: 'David Lee',
    age: 21,
    gender: 'Male',
    region: 'Seoul',
    email: 'david.lee@example.com',
    profilePictureUrl: 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
    anthropometrics: const AnthropometricData(heightCm: 178, weightKg: 75, bmi: 23.6),
    sportsHistory: const <SportsHistoryEntry>[],
    trainingGoals: const <TrainingGoal>[],
    badges: const <BadgeData>[],
    achievements: const <AchievementData>[],
    performanceResults: const <PerformanceTestResult>[
      PerformanceTestResult(testType: '30m Sprint', resultValue: 4.0, unit: 's', date: '2023-01-01', trendIcon: Icons.arrow_upward, trendColor: Colors.green, normalizedScore: 93),
      PerformanceTestResult(testType: 'Vertical Jump', resultValue: 67, unit: 'cm', date: '2023-01-01', trendIcon: Icons.arrow_upward, trendColor: Colors.green, normalizedScore: 80),
    ],
    mlMetrics: const <MetricData>[],
    mlFeedback: const <AnalysisPointData>[],
    performanceStats: const AthletePerformanceStats(lastScore: 93, improvementPercentage: 7, rank: 3, totalActivities: 45),
    score: 920,
    totalActivities: 45,
    mainSport: 'Basketball',
  ),
  Athlete(
    name: 'Emily Chen',
    age: 17,
    gender: 'Female',
    region: 'Tokyo',
    email: 'emily.chen@example.com',
    profilePictureUrl: 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
    anthropometrics: const AnthropometricData(heightCm: 160, weightKg: 55, bmi: 21.5),
    sportsHistory: const <SportsHistoryEntry>[],
    trainingGoals: const <TrainingGoal>[],
    badges: const <BadgeData>[],
    achievements: const <AchievementData>[],
    performanceResults: const <PerformanceTestResult>[
      PerformanceTestResult(testType: '30m Sprint', resultValue: 4.3, unit: 's', date: '2023-01-01', trendIcon: Icons.arrow_upward, trendColor: Colors.green, normalizedScore: 88),
      PerformanceTestResult(testType: 'Endurance Run (2km)', resultValue: 8.0, unit: 'min', date: '2023-01-01', trendIcon: Icons.arrow_upward, trendColor: Colors.green, normalizedScore: 70),
    ],
    mlMetrics: const <MetricData>[],
    mlFeedback: const <AnalysisPointData>[],
    performanceStats: const AthletePerformanceStats(lastScore: 88, improvementPercentage: 5, rank: 4, totalActivities: 30),
    score: 880,
    totalActivities: 30,
    mainSport: 'Athletics',
  ),
  Athlete(
    name: 'Rahul Kumar',
    age: 25,
    gender: 'Male',
    region: 'Bengaluru',
    email: 'rahul.kumar@example.com',
    profilePictureUrl: 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
    anthropometrics: const AnthropometricData(heightCm: 170, weightKg: 70, bmi: 24.2),
    sportsHistory: const <SportsHistoryEntry>[],
    trainingGoals: const <TrainingGoal>[],
    badges: const <BadgeData>[],
    achievements: const <AchievementData>[],
    performanceResults: const <PerformanceTestResult>[
      PerformanceTestResult(testType: 'Vertical Jump', resultValue: 60, unit: 'cm', date: '2023-01-01', trendIcon: Icons.arrow_upward, trendColor: Colors.green, normalizedScore: 70),
      PerformanceTestResult(testType: 'Agility Drill', resultValue: 8.5, unit: 's', date: '2023-01-01', trendIcon: Icons.arrow_upward, trendColor: Colors.green, normalizedScore: 75),
    ],
    mlMetrics: const <MetricData>[],
    mlFeedback: const <AnalysisPointData>[],
    performanceStats: const AthletePerformanceStats(lastScore: 75, improvementPercentage: 3, rank: 5, totalActivities: 20),
    score: 800,
    totalActivities: 20,
    mainSport: 'Cricket',
  ),
  Athlete(
    name: 'Sophia Miller',
    age: 16,
    gender: 'Female',
    region: 'California',
    email: 'sophia.miller@example.com',
    profilePictureUrl: 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
    anthropometrics: const AnthropometricData(heightCm: 165, weightKg: 58, bmi: 21.3),
    sportsHistory: const <SportsHistoryEntry>[],
    trainingGoals: const <TrainingGoal>[],
    badges: const <BadgeData>[],
    achievements: const <AchievementData>[],
    performanceResults: const <PerformanceTestResult>[
      PerformanceTestResult(testType: '30m Sprint', resultValue: 4.5, unit: 's', date: '2023-01-01', trendIcon: Icons.arrow_upward, trendColor: Colors.green, normalizedScore: 85),
      PerformanceTestResult(testType: 'Endurance Run (2km)', resultValue: 7.8, unit: 'min', date: '2023-01-01', trendIcon: Icons.arrow_upward, trendColor: Colors.green, normalizedScore: 72),
    ],
    mlMetrics: const <MetricData>[],
    mlFeedback: const <AnalysisPointData>[],
    performanceStats: const AthletePerformanceStats(lastScore: 85, improvementPercentage: 6, rank: 6, totalActivities: 25),
    score: 860,
    totalActivities: 25,
    mainSport: 'Tennis',
  ),
  Athlete(
    name: 'Omar Hassan',
    age: 23,
    gender: 'Male',
    region: 'Cairo',
    email: 'omar.hassan@example.com',
    profilePictureUrl: 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
    anthropometrics: const AnthropometricData(heightCm: 185, weightKg: 85, bmi: 24.8),
    sportsHistory: const <SportsHistoryEntry>[],
    trainingGoals: const <TrainingGoal>[],
    badges: const <BadgeData>[],
    achievements: const <AchievementData>[],
    performanceResults: const <PerformanceTestResult>[
      PerformanceTestResult(testType: 'Vertical Jump', resultValue: 72, unit: 'cm', date: '2023-01-01', trendIcon: Icons.arrow_upward, trendColor: Colors.green, normalizedScore: 88),
      PerformanceTestResult(testType: '30m Sprint', resultValue: 4.0, unit: 's', date: '2023-01-01', trendIcon: Icons.arrow_upward, trendColor: Colors.green, normalizedScore: 93),
    ],
    mlMetrics: const <MetricData>[],
    mlFeedback: const <AnalysisPointData>[],
    performanceStats: const AthletePerformanceStats(lastScore: 93, improvementPercentage: 9, rank: 7, totalActivities: 40),
    score: 910,
    totalActivities: 40,
    mainSport: 'Basketball',
  ),
  Athlete(
    name: 'Maria Rodriguez',
    age: 18,
    gender: 'Female',
    region: 'Buenos Aires',
    email: 'maria.rodriguez@example.com',
    profilePictureUrl: 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
    anthropometrics: const AnthropometricData(heightCm: 170, weightKg: 62, bmi: 21.5),
    sportsHistory: const <SportsHistoryEntry>[],
    trainingGoals: const <TrainingGoal>[],
    badges: const <BadgeData>[],
    achievements: const <AchievementData>[],
    performanceResults: const <PerformanceTestResult>[
      PerformanceTestResult(testType: 'Agility Drill', resultValue: 7.2, unit: 's', date: '2023-01-01', trendIcon: Icons.arrow_upward, trendColor: Colors.green, normalizedScore: 90),
      PerformanceTestResult(testType: '30m Sprint', resultValue: 4.2, unit: 's', date: '2023-01-01', trendIcon: Icons.arrow_upward, trendColor: Colors.green, normalizedScore: 88),
    ],
    mlMetrics: const <MetricData>[],
    mlFeedback: const <AnalysisPointData>[],
    performanceStats: const AthletePerformanceStats(lastScore: 90, improvementPercentage: 7, rank: 8, totalActivities: 35),
    score: 890,
    totalActivities: 35,
    mainSport: 'Football',
  ),
  Athlete(
    name: 'Kenji Tanaka',
    age: 20,
    gender: 'Male',
    region: 'Osaka',
    email: 'kenji.tanaka@example.com',
    profilePictureUrl: 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
    anthropometrics: const AnthropometricData(heightCm: 172, weightKg: 68, bmi: 23),
    sportsHistory: const <SportsHistoryEntry>[],
    trainingGoals: const <TrainingGoal>[],
    badges: const <BadgeData>[],
    achievements: const <AchievementData>[],
    performanceResults: const <PerformanceTestResult>[
      PerformanceTestResult(testType: '30m Sprint', resultValue: 4.1, unit: 's', date: '2023-01-01', trendIcon: Icons.arrow_upward, trendColor: Colors.green, normalizedScore: 91),
      PerformanceTestResult(testType: 'Vertical Jump', resultValue: 63, unit: 'cm', date: '2023-01-01', trendIcon: Icons.arrow_upward, trendColor: Colors.green, normalizedScore: 78),
    ],
    mlMetrics: const <MetricData>[],
    mlFeedback: const <AnalysisPointData>[],
    performanceStats: const AthletePerformanceStats(lastScore: 91, improvementPercentage: 6, rank: 9, totalActivities: 32),
    score: 875,
    totalActivities: 32,
    mainSport: 'Badminton',
  ),
  Athlete(
    name: 'Isabella Rossi',
    age: 17,
    gender: 'Female',
    region: 'Munich',
    email: 'isabella.rossi@example.com',
    profilePictureUrl: 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
    anthropometrics: const AnthropometricData(heightCm: 168, weightKg: 60, bmi: 21.3),
    sportsHistory: const <SportsHistoryEntry>[],
    trainingGoals: const <TrainingGoal>[],
    badges: const <BadgeData>[],
    achievements: const <AchievementData>[],
    performanceResults: const <PerformanceTestResult>[
      PerformanceTestResult(testType: 'Endurance Run (2km)', resultValue: 7.5, unit: 'min', date: '2023-01-01', trendIcon: Icons.arrow_upward, trendColor: Colors.green, normalizedScore: 75),
      PerformanceTestResult(testType: 'Agility Drill', resultValue: 7.5, unit: 's', date: '2023-01-01', trendIcon: Icons.arrow_upward, trendColor: Colors.green, normalizedScore: 85),
    ],
    mlMetrics: const <MetricData>[],
    mlFeedback: const <AnalysisPointData>[],
    performanceStats: const AthletePerformanceStats(lastScore: 85, improvementPercentage: 4, rank: 10, totalActivities: 28),
    score: 850,
    totalActivities: 28,
    mainSport: 'Athletics',
  ),
];

// Initial Notifications
final List<NotificationData> _initialNotifications = <NotificationData>[
  NotificationData(
      title: 'New Opportunity: Talent Scout Camp', time: '2 hours ago', icon: Icons.sports_handball),
  NotificationData(
      title: 'Challenge Completed: 30-Day Speed Boost!', time: 'Yesterday', icon: Icons.emoji_events, isRead: true),
  NotificationData(
      title: 'Performance Report Ready: May 2024', time: '2 days ago', icon: Icons.trending_up),
  NotificationData(
      title: 'Upcoming Training Session Reminder', time: '3 days ago', icon: Icons.calendar_today, isRead: true),
  NotificationData(
      title: 'Your rank improved to 15!', time: '4 days ago', icon: Icons.leaderboard),
];

// Initial Opportunities
final Map<String, List<OpportunityData>> _initialOpportunities = <String, List<OpportunityData>>{
  'Athlete Development Programs': <OpportunityData>[
    OpportunityData(
        title: 'National Football Academy Trials',
        category: 'Football Development',
        status: 'Application Open',
        color: Colors.blue.shade700,
        description: 'Elite training program for aspiring football players aged 16-20.',
        location: 'Delhi, India',
        dates: 'August 1-10, 2024',
        eligibility: 'Ages 16-20, Indian citizen',
        registrationLink: 'https://example.com/football_trials'),
    OpportunityData(
        title: 'Youth Athletics Development Camp',
        category: 'Track & Field',
        status: 'Application Open',
        color: Colors.green.shade700,
        description: 'Intensive camp focused on sprint and jump techniques for athletes 14-18.',
        location: 'Bengaluru, India',
        dates: 'July 15-25, 2024',
        eligibility: 'Ages 14-18',
        registrationLink: 'https://example.com/athletics_camp'),
  ],
  'Talent Identification Scouting': <OpportunityData>[
    OpportunityData(
        title: 'Basketball League Scout Day',
        category: 'Professional Scouting',
        status: 'Invites Only',
        color: Colors.purple.shade700,
        description: 'Scouting event for top basketball prospects by national league teams.',
        location: 'Mumbai, India',
        dates: 'September 5, 2024',
        eligibility: 'Invitation required',
        registrationLink: 'https://example.com/basketball_scout'),
  ],
  'Scholarship Programs': <OpportunityData>[
    OpportunityData(
        title: 'University Sports Scholarship',
        category: 'Academic & Sports',
        status: 'Application Open',
        color: Colors.amber.shade700,
        description: 'Scholarship opportunities for student-athletes seeking higher education.',
        location: 'Various Universities',
        dates: 'Applications close October 30, 2024',
        eligibility: 'High school graduates with strong academic and sports records',
        registrationLink: 'https://example.com/scholarship'),
  ],
  'Camps & Workshops': <OpportunityData>[
    OpportunityData(
        title: 'Nutrition for Athletes Workshop',
        category: 'Wellness & Education',
        status: 'Enrollment Open',
        color: Colors.teal.shade700,
        description: 'Learn about optimal nutrition for peak athletic performance.',
        location: 'Online',
        dates: 'June 20, 2024',
        eligibility: 'All athletes',
        registrationLink: 'https://example.com/nutrition_workshop'),
  ],
};

// Initial Challenges
final List<ChallengeData> _initialChallenges = <ChallengeData>[
  ChallengeData(
      title: '30-Day Core Strength Challenge',
      description: 'Strengthen your core for better stability and power.',
      currentProgress: 18,
      targetProgress: 30,
      color: Colors.green.shade700),
  ChallengeData(
      title: 'Sprint Acceleration Boost',
      description: 'Improve your initial burst and 0-30m times.',
      currentProgress: 5,
      targetProgress: 7,
      color: Colors.blue.shade700),
  ChallengeData(
      title: 'Flexibility for Injury Prevention',
      description: 'Daily stretching routine to increase range of motion.',
      currentProgress: 10,
      targetProgress: 20,
      color: Colors.purple.shade700),
];

// Initial Instructions for onboarding
final List<InstructionItem> _initialInstructions = <InstructionItem>[
  InstructionItem(
    icon: Icons.person_outline,
    title: 'Your Personalized Profile',
    description: 'Track your personal details, anthropometrics, sports history, and training goals all in one place.',
  ),
  InstructionItem(
    icon: Icons.insights,
    title: 'AI-Powered Performance Insights',
    description: 'Get detailed AI feedback, performance metrics, and analyze your progress with intuitive charts.',
  ),
  InstructionItem(
    icon: Icons.emoji_events_outlined,
    title: 'Challenges & Achievements',
    description: 'Engage in training challenges, earn badges, and celebrate your milestones.',
  ),
  InstructionItem(
    icon: Icons.trending_up,
    title: 'Leaderboard & Opportunities',
    description: 'Compete with other athletes, filter by age and region, and discover new career opportunities.',
  ),
  InstructionItem(
    icon: Icons.videocam_outlined,
    title: 'Record & Analyze Videos',
    description: 'Use the floating action button to record your performance and upload videos for deeper analysis.',
  ),
];

// Video Recording Instructions
final List<VideoRecordingInstruction> _initialVideoRecordingInstructions = <VideoRecordingInstruction>[
  const VideoRecordingInstruction(
    icon: Icons.lightbulb_outline,
    title: 'Good Lighting',
    description: 'Ensure good, even lighting from the front. Avoid harsh backlighting or shadows.',
  ),
  const VideoRecordingInstruction(
    icon: Icons.camera_alt_outlined,
    title: 'Stable Camera',
    description: 'Keep your camera steady. Use a tripod or a stable surface to prevent shaky footage.',
  ),
  const VideoRecordingInstruction(
    icon: Icons.aspect_ratio,
    title: 'Full Body View',
    description: 'Ensure the entire body is visible within the frame throughout the exercise or test.',
  ),
  const VideoRecordingInstruction(
    icon: Icons.clear_all,
    title: 'Clear Background',
    description: 'Use a clear, uncluttered background to help AI analysis focus on your movements.',
  ),
  const VideoRecordingInstruction(
    icon: Icons.speaker_phone,
    title: 'Sound On',
    description: 'Keep sound on to capture audio cues, instructions, or sounds relevant to the performance.',
  ),
  const VideoRecordingInstruction(
    icon: Icons.timer,
    title: 'Record Full Duration',
    description: 'Record the entire duration of the test or exercise without interruption for complete analysis.',
  ),
  const VideoRecordingInstruction(
    icon: Icons.rotate_right,
    title: 'Landscape Orientation',
    description: 'Always record in landscape mode for optimal viewing and analysis.',
  ),
];

// Initial Example Videos
final List<ExampleVideoData> _initialExampleVideos = <ExampleVideoData>[
  ExampleVideoData(
    title: 'Perfect Sprint Start',
    description: 'Demonstration of an explosive 100m sprint start technique.',
    videoUrl: 'https://example.com/sprint_start.mp4',
    thumbnailUrl: 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
  ),
  ExampleVideoData(
    title: 'Vertical Jump Technique',
    description: 'Detailed breakdown of proper vertical jump form for maximum height.',
    videoUrl: 'https://example.com/vertical_jump.mp4',
    thumbnailUrl: 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
  ),
  ExampleVideoData(
    title: 'Agility Ladder Drills',
    description: 'Essential agility ladder drills to improve quickness and coordination.',
    videoUrl: 'https://example.com/agility_drills.mp4',
    thumbnailUrl: 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
  ),
  ExampleVideoData(
    title: 'Long Jump Approach & Takeoff',
    description: 'Mastering the approach run and takeoff for an effective long jump.',
    videoUrl: 'https://example.com/long_jump.mp4',
    thumbnailUrl: 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
  ),
  ExampleVideoData(
    title: 'Endurance Running Form',
    description: 'Tips for maintaining efficient running form during long-distance efforts.',
    videoUrl: 'https://example.com/endurance_run.mp4',
    thumbnailUrl: 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
  ),
];

// The main function, which is the entry point of the application.
void main() {
  runApp(const MyApp());
}

// -----------------------------------------------------------------------------
// MAIN APPLICATION WIDGET
// -----------------------------------------------------------------------------

/// The root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<AthleteProvider>(
          create: (BuildContext context) => AthleteProvider(
            initialAthletes: _allAthletes,
            currentUserName: _currentUser.name,
          ),
        ),
        ChangeNotifierProvider<LeaderboardData>(
          create: (BuildContext context) => LeaderboardData(
            Provider.of<AthleteProvider>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider<OpportunitiesData>(
          create: (BuildContext context) => OpportunitiesData(
            initialOpportunities: _initialOpportunities,
          ),
        ),
        ChangeNotifierProvider<NotificationScreenData>(
          create: (BuildContext context) => NotificationScreenData(
            initialNotifications: _initialNotifications,
          ),
        ),
      ],
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          title: 'Athlete Performance Tracker',
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.deepOrange.shade700,
              foregroundColor: Colors.white,
              elevation: 4,
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: InstructionsScreen(
            instructions: _initialInstructions,
            onGetStarted: (BuildContext screenContext) {
              Navigator.pushReplacement<void, void>(
                screenContext, // Use the context from the InstructionsScreen
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => MainScreen(
                    initialChallenges: _initialChallenges,
                    initialVideoInstructions: _initialVideoRecordingInstructions,
                    initialExampleVideos: _initialExampleVideos,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// DATA_MODEL
// -----------------------------------------------------------------------------

/// Represents athlete's overall performance statistics.
class AthletePerformanceStats {
  final int lastScore;
  final int improvementPercentage;
  final int rank;
  final int totalActivities;

  const AthletePerformanceStats({
    required this.lastScore,
    required this.improvementPercentage,
    required this.rank,
    required this.totalActivities,
  });
}

/// Represents a notification item.
class NotificationData {
  final String title;
  final String time;
  final IconData icon;
  final bool isRead;

  const NotificationData({
    required this.title,
    required this.time,
    required this.icon,
    this.isRead = false,
  });

  NotificationData copyWith({
    bool? isRead,
  }) {
    return NotificationData(
      title: title,
      time: time,
      icon: icon,
      isRead: isRead ?? this.isRead,
    );
  }
}

/// Represents a career or program opportunity for an athlete.
class OpportunityData {
  final String title;
  final String category; // Represents the sports league/development category
  final String status;
  final Color color;
  final String description;
  final String location;
  final String dates;
  final String eligibility;
  final String registrationLink;

  OpportunityData({
    required this.title,
    required this.category,
    required this.status,
    required this.color,
    required this.description,
    required this.location,
    required this.dates,
    required this.eligibility,
    required this.registrationLink,
  });
}

/// Represents an entry in the athlete leaderboard.
class LeaderboardEntry {
  final int rank;
  final String name;
  final int score;
  final int age;
  final String region; // Can represent various levels (country, state, city, club)
  final int totalActivities;
  final bool isCurrentUser;
  final String profilePictureUrl;
  final String gender; // Added gender for gender-category ranking

  LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.score,
    required this.age,
    required this.region,
    required this.totalActivities,
    this.isCurrentUser = false,
    this.profilePictureUrl =
        'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg', // Default placeholder
    this.gender = 'All',
  });
}

/// Represents an active training challenge.
class ChallengeData {
  final String title;
  final String description;
  final int currentProgress;
  final int targetProgress;
  final Color color;

  ChallengeData({
    required this.title,
    required this.description,
    required this.currentProgress,
    required this.targetProgress,
    required this.color,
  });
}

/// Represents a badge achieved by the athlete.
class BadgeData {
  final String title;
  final IconData icon;
  final Color color;

  BadgeData({
    required this.title,
    required this.icon,
    required this.color,
  });
}

/// Represents a single performance test result in the athlete's history.
class PerformanceTestResult {
  final String testType;
  final double resultValue; // Raw measured value, e.g., 7.2 for 30m sprint, 65 for vertical jump
  final String unit; // e.g., "s", "cm", "reps", "m"
  final String date;
  final IconData trendIcon;
  final Color trendColor;
  final String? videoUrl;

  // Normalized score for charting and leaderboard calculations (higher is better)
  final int normalizedScore;

  const PerformanceTestResult({
    required this.testType,
    required this.resultValue,
    required this.unit,
    required this.date,
    required this.trendIcon,
    required this.trendColor,
    this.videoUrl,
    required this.normalizedScore,
  });
}

/// Represents an achievement or milestone for an athlete.
class AchievementData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  AchievementData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

/// Represents a performance metric shown in AI feedback for athletes.
class MetricData {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  MetricData({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });
}

/// Represents an analysis point (strength or area to improve) in AI feedback for athletes.
class AnalysisPointData {
  final String title;
  final String content;
  final Color color;

  AnalysisPointData({
    required this.title,
    required this.content,
    required this.color,
  });
}

/// Represents an entry in an athlete's sports and training history.
class SportsHistoryEntry {
  final String sportName;
  final String period;
  final String teamName;
  final String achievements;

  const SportsHistoryEntry({
    required this.sportName,
    required this.period,
    required this.teamName,
    required this.achievements,
  });
}

/// Represents an athlete's training goal.
class TrainingGoal {
  final String goalDescription;
  final String targetDate;
  final int currentProgress;
  final int targetValue;

  const TrainingGoal({
    required this.goalDescription,
    required this.targetDate,
    required this.currentProgress,
    required this.targetValue,
  });
}

/// Represents an athlete's anthropometric data.
class AnthropometricData {
  final double heightCm;
  final double weightKg;
  final double bmi;

  const AnthropometricData({
    required this.heightCm,
    required this.weightKg,
    required this.bmi,
  });
}

/// Represents all comprehensive profile data for an athlete, including performance metrics.
class Athlete {
  final String name;
  final int age;
  final String gender;
  final String region;
  final String email;
  final String profilePictureUrl;
  final AnthropometricData anthropometrics;
  final List<SportsHistoryEntry> sportsHistory;
  final List<TrainingGoal> trainingGoals;
  final List<BadgeData> badges;
  final List<AchievementData> achievements;
  final List<PerformanceTestResult> performanceResults; // Includes videoUrls
  final List<MetricData> mlMetrics;
  final List<AnalysisPointData> mlFeedback;
  final AthletePerformanceStats performanceStats; // Calculated summary stats

  // Fields primarily for leaderboard and general athlete identity
  final int score; // Overall fitness score for ranking
  final int totalActivities;
  final String mainSport; // The primary sport for filtering/display

  const Athlete({
    required this.name,
    required this.age,
    required this.gender,
    required this.region,
    required this.email,
    required this.profilePictureUrl,
    required this.anthropometrics,
    required this.sportsHistory,
    required this.trainingGoals,
    required this.badges,
    required this.achievements,
    required this.performanceResults,
    required this.mlMetrics,
    required this.mlFeedback,
    required this.performanceStats,
    required this.score,
    required this.totalActivities,
    required this.mainSport,
  });

  /// Creates a [LeaderboardEntry] from this [Athlete] object for display in leaderboards.
  LeaderboardEntry toLeaderboardEntry({int rank = 0, bool isCurrentUser = false}) {
    return LeaderboardEntry(
      rank: rank,
      name: name,
      score: score,
      age: age,
      region: region,
      totalActivities: totalActivities,
      isCurrentUser: isCurrentUser,
      profilePictureUrl: profilePictureUrl,
      gender: gender,
    );
  }
}

/// Represents a single instruction item for the onboarding screen.
class InstructionItem {
  final IconData icon;
  final String title;
  final String description;

  const InstructionItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}

/// Represents a single instruction or rule for video recording.
class VideoRecordingInstruction {
  final IconData icon;
  final String title;
  final String description;

  const VideoRecordingInstruction({
    required this.icon,
    required this.title,
    required this.description,
  });
}

/// Represents a single example video item.
class ExampleVideoData {
  final String title;
  final String description;
  final String videoUrl;
  final String thumbnailUrl;

  const ExampleVideoData({
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnailUrl,
  });
}

/// Manages a collection of [Athlete] objects, including the current logged-in user.
class AthleteProvider extends ChangeNotifier {
  final List<Athlete> _allAthletes;
  Athlete? _currentAthlete; // The logged-in user

  AthleteProvider({required List<Athlete> initialAthletes, required String currentUserName})
      : _allAthletes = initialAthletes {
    _currentAthlete = _allAthletes.firstWhere((Athlete athlete) => athlete.name == currentUserName);
  }

  List<Athlete> get allAthletes => List<Athlete>.unmodifiable(_allAthletes);
  Athlete get currentAthlete => _currentAthlete!; // Should always be set
}

// State management for Leaderboard with hierarchical region filtering
class LeaderboardData extends ChangeNotifier {
  final AthleteProvider _athleteProvider; // Dependency on AthleteProvider
  String? _selectedAgeGroup = 'All';
  bool _showAgeGroupFilters = false;
  bool _showRegionFilters = false;

  final List<String> _regionPath = <String>[];
  String? _currentSelectedRegionFilter = 'All';

  static const List<String> _ageGroupOptions = <String>['All', 'u10', 'u12', 'u14', 'u17', 'u19', 'u21', 'u21+'];

  static final Map<String, List<String>> _regionChildrenMap = <String, List<String>>{
    'All': <String>['Global'],
    'Global': <String>[
      'India',
      'Iran',
      'Pakistan',
      'Bangladesh',
      'South Korea',
      'Japan',
      'Kenya',
      'Argentina',
      'England',
      'USA', // Added more nations
      'Canada',
      'Australia',
      'Germany',
      'Brazil',
      'Nigeria',
      'Egypt',
      'Indonesia',
    ],
    'India': <String>[
      'Haryana',
      'Punjab',
      'Andhra Pradesh',
      'Uttar Pradesh',
      'Maharashtra',
      'Tamil Nadu',
      'Himachal Pradesh',
      'Delhi',
      'Rajasthan',
      'Gujarat',
      'Karnataka',
      'Kerala',
      'West Bengal',
    ],
    'Iran': <String>[],
    'Pakistan': <String>['Sindh', 'Punjab (PK)'],
    'Bangladesh': <String>[],
    'South Korea': <String>['Seoul', 'Busan'],
    'Japan': <String>['Tokyo', 'Osaka'],
    'Kenya': <String>['Nairobi', 'Mombasa'],
    'Argentina': <String>['Buenos Aires', 'Cordoba'],
    'England': <String>['London', 'Manchester'],
    'USA': <String>['California', 'Texas', 'New York'],
    'Canada': <String>['Ontario', 'British Columbia'],
    'Australia': <String>['Sydney', 'Melbourne'],
    'Germany': <String>['Bavaria', 'Berlin'],
    'Brazil': <String>['Sao Paulo', 'Rio de Janeiro'],
    'Nigeria': <String>['Lagos', 'Abuja'],
    'Egypt': <String>['Cairo', 'Alexandria'],
    'Indonesia': <String>['Jakarta', 'Bali'],
    'Haryana': <String>['Gurugram', 'Faridabad'],
    'Punjab': <String>['Ludhiana', 'Amritsar'],
    'Andhra Pradesh': <String>['Hyderabad'],
    'Uttar Pradesh': <String>['Lucknow', 'Kanpur'],
    'Maharashtra': <String>['Mumbai', 'Pune'],
    'Tamil Nadu': <String>['Chennai', 'Coimbatore'],
    'Himachal Pradesh': <String>[],
    'Delhi': <String>[],
    'Rajasthan': <String>['Jaipur'],
    'Gujarat': <String>['Ahmedabad'],
    'Gurugram': <String>['Sohna', 'Manesar'],
    'Sohna': <String>['Damdama'],
    'Damdama': <String>[],
    'Sindh': <String>['Karachi'],
    'Punjab (PK)': <String>['Lahore'],
    'California': <String>['Los Angeles', 'San Francisco'],
    'Ontario': <String>['Toronto'],
    'Bavaria': <String>['Munich'],
    'Sao Paulo': <String>[],
    'Lagos': <String>[],
  };

  static final Map<String, String> _childToParentMap = _createChildToParentMap(_regionChildrenMap);

  static Map<String, String> _createChildToParentMap(Map<String, List<String>> childrenMap) {
    final Map<String, String> reverseMap = <String, String>{};
    childrenMap.forEach((String parent, List<String> children) {
      for (final String child in children) {
        if (child != 'All') {
          reverseMap[child] = parent;
        }
      }
    });
    return reverseMap;
  }

  LeaderboardData(this._athleteProvider);

  String? get selectedAgeGroup => _selectedAgeGroup;
  bool get showAgeGroupFilters => _showAgeGroupFilters;
  bool get showRegionFilters => _showRegionFilters;

  String? get activeRegionFilter => _currentSelectedRegionFilter;
  List<String> get regionPath => List<String>.unmodifiable(_regionPath);

  String get currentRegionPathParent {
    if (_regionPath.isEmpty) return 'All';
    return _regionPath.last;
  }

  List<String> get regionOptions {
    final SplayTreeSet<String> options = SplayTreeSet<String>();
    options.add('All');

    final List<String> children = _regionChildrenMap[currentRegionPathParent] ?? <String>[];

    final SplayTreeSet<String> uniqueRegionsInUsers = SplayTreeSet<String>();
    for (final Athlete athlete in _athleteProvider.allAthletes) {
      uniqueRegionsInUsers.add(athlete.region);
      String? currentParent = _childToParentMap[athlete.region];
      while (currentParent != null && currentParent != 'All') {
        uniqueRegionsInUsers.add(currentParent);
        currentParent = _childToParentMap[currentParent];
      }
    }

    for (final String child in children) {
      if (uniqueRegionsInUsers.contains(child) ||
          (_regionChildrenMap.containsKey(child) && _regionChildrenMap[child]!.isNotEmpty)) {
        options.add(child);
      }
    }
    return options.toList();
  }

  List<String> get ageGroupOptions => _ageGroupOptions;

  List<LeaderboardEntry> get leaderboardEntries {
    // Create a modifiable copy of the athletes list before filtering and sorting.
    List<Athlete> filteredAthletes = List<Athlete>.from(_athleteProvider.allAthletes);

    if (_selectedAgeGroup != null && _selectedAgeGroup != 'All') {
      filteredAthletes = filteredAthletes.where((Athlete athlete) {
        return _getAgeGroupString(athlete.age) == _selectedAgeGroup;
      }).toList();
    }

    if (_currentSelectedRegionFilter != null && _currentSelectedRegionFilter != 'All') {
      filteredAthletes = filteredAthletes.where((Athlete athlete) {
        return _isDescendantOf(athlete.region, _currentSelectedRegionFilter!);
      }).toList();
    }

    filteredAthletes.sort((Athlete a, Athlete b) => b.score.compareTo(a.score));

    return List<LeaderboardEntry>.generate(filteredAthletes.length, (int i) {
      final Athlete athlete = filteredAthletes[i];
      final bool isCurrentUser = athlete.name == _athleteProvider.currentAthlete.name;
      return athlete.toLeaderboardEntry(rank: i + 1, isCurrentUser: isCurrentUser);
    });
  }

  void onAgeGroupSelected(String? ageGroup) {
    if (_selectedAgeGroup != ageGroup) {
      _selectedAgeGroup = ageGroup;
      notifyListeners();
    }
  }

  void toggleAgeGroupFilters() {
    _showAgeGroupFilters = !_showAgeGroupFilters;
    if (_showAgeGroupFilters) {
      _showRegionFilters = false;
    }
    notifyListeners();
  }

  void toggleRegionFilters() {
    _showRegionFilters = !_showRegionFilters;
    if (_showRegionFilters) {
      _showAgeGroupFilters = false;
    }
    notifyListeners();
  }

  void onSelectRegionOption(String? region) {
    if (region == null || region == 'All') {
      _regionPath.clear();
      _currentSelectedRegionFilter = 'All';
    } else {
      if (_regionChildrenMap.containsKey(region) && _regionChildrenMap[region]!.isNotEmpty) {
        if (_regionPath.isEmpty || (_regionPath.last == _childToParentMap[region])) {
          _regionPath.add(region);
        } else if (_childToParentMap.containsKey(region) && _childToParentMap[region] == 'Global') {
          _regionPath.clear();
          _regionPath.add(region);
        }
        _currentSelectedRegionFilter = region;
      } else {
        _regionPath.clear();
        String? tempRegion = region;
        List<String> tempPath = <String>[];
        while (tempRegion != null && tempRegion != 'All') {
          tempPath.add(tempRegion);
          tempRegion = _childToParentMap[tempRegion];
        }
        _regionPath.addAll(tempPath.reversed);
        _currentSelectedRegionFilter = region;
      }
    }
    notifyListeners();
  }

  void goBackRegionHierarchy() {
    if (_regionPath.isNotEmpty) {
      _regionPath.removeLast();
      _currentSelectedRegionFilter = _regionPath.isEmpty ? 'All' : _regionPath.last;
    } else {
      _currentSelectedRegionFilter = 'All';
    }
    notifyListeners();
  }

  String _getAgeGroupString(int age) {
    if (age <= 10) {
      return 'u10';
    } else if (age <= 12) {
      return 'u12';
    } else if (age <= 14) {
      return 'u14';
    } else if (age <= 17) {
      return 'u17';
    } else if (age <= 19) {
      return 'u19';
    } else if (age <= 21) {
      return 'u21';
    } else {
      return 'u21+';
    }
  }

  bool _isDescendantOf(String potentialChild, String potentialParent) {
    if (potentialChild == potentialParent) return true;
    if (potentialParent == 'All') return true;

    String? currentParent = _childToParentMap[potentialChild];
    while (currentParent != null) {
      if (currentParent == potentialParent) return true;
      currentParent = _childToParentMap[currentParent];
    }
    return false;
  }
}

// State management for Opportunities
class OpportunitiesData extends ChangeNotifier {
  final List<String> _categories = <String>[
    'Athlete Development Programs',
    'Talent Identification Scouting',
    'Scholarship Programs',
    'Camps & Workshops',
  ];

  final Map<String, List<OpportunityData>> _allOpportunities;

  OpportunitiesData({required Map<String, List<OpportunityData>> initialOpportunities})
      : _allOpportunities = initialOpportunities;

  List<String> get categories => _categories;
  Map<String, List<OpportunityData>> get allGroupedOpportunities => _allOpportunities;
}

class NotificationScreenData extends ChangeNotifier {
  List<NotificationData> _notifications;

  NotificationScreenData({required List<NotificationData> initialNotifications}) : _notifications = initialNotifications;

  List<NotificationData> get notifications => List<NotificationData>.unmodifiable(_notifications);

  void markAsRead(int index) {
    if (index >= 0 && index < _notifications.length) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }
}

// -----------------------------------------------------------------------------
// ATOMIC WIDGETS
// -----------------------------------------------------------------------------

/// Displays a single athlete performance statistic with an icon, value, and title.
class DashboardStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const DashboardStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Icon(icon, size: 30, color: Colors.deepOrange[600]),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}

/// Displays a single notification item.
class NotificationCard extends StatelessWidget {
  final NotificationData notification;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: notification.isRead ? Colors.grey[100] : Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 20,
                backgroundColor: notification.isRead ? Colors.grey[200] : Colors.deepOrange[50],
                child: Icon(notification.icon, color: Colors.deepOrange[600], size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      notification.title,
                      style: TextStyle(
                          fontWeight: notification.isRead ? FontWeight.normal : FontWeight.w500,
                          color: notification.isRead ? Colors.grey[700] : Colors.black87),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(notification.time, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
              ),
              if (!notification.isRead)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.deepOrange,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Displays a single opportunity item.
class OpportunityCard extends StatelessWidget {
  final OpportunityData opportunity;
  final VoidCallback onTap;

  const OpportunityCard({
    super.key,
    required this.opportunity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: opportunity.color.withAlpha((0.05 * 255).round()),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              Container(
                width: 4,
                height: 40,
                color: opportunity.color,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      opportunity.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      opportunity.category,
                      style: TextStyle(color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      opportunity.status,
                      style: TextStyle(color: opportunity.color, fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A filter chip widget for categories.
class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: Colors.deepOrange[100],
      checkmarkColor: Colors.deepOrange[700],
      labelStyle: TextStyle(
        color: isSelected ? Colors.deepOrange[700] : Colors.black87,
      ),
    );
  }
}

/// Displays a single leaderboard entry.
class LeaderboardItemWidget extends StatelessWidget {
  final LeaderboardEntry entry;
  final Athlete athlete; // Pass the full Athlete object for navigation

  const LeaderboardItemWidget({
    super.key,
    required this.entry,
    required this.athlete,
  });

  static const String _defaultProfilePictureUrl =
      'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg';

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: entry.isCurrentUser ? Colors.deepOrange[50] : null,
      child: InkWell(
        onTap: () {
          Navigator.push<void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext dialogContext) {
                return AthleteProfilePage(athlete: athlete);
              },
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: entry.rank <= 3 ? Colors.amber[700] : Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${entry.rank}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: entry.rank <= 3 ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.deepOrange[100],
                child: entry.profilePictureUrl != _defaultProfilePictureUrl
                    ? ClipOval(
                        child: Image.network(
                          entry.profilePictureUrl,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                            return Text(
                              entry.name[0],
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                            );
                          },
                        ),
                      )
                    : Text(
                        entry.name[0],
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      entry.name,
                      style: TextStyle(
                        fontWeight: entry.isCurrentUser ? FontWeight.bold : FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Age: ${entry.age} years, ${entry.gender}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          entry.region,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${entry.score}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Displays a single challenge card with progress indicator.
class ChallengeProgressCard extends StatelessWidget {
  final ChallengeData challenge;

  const ChallengeProgressCard({
    super.key,
    required this.challenge,
  });

  @override
  Widget build(BuildContext context) {
    double progress = challenge.currentProgress / challenge.targetProgress;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        challenge.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        challenge.description,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Text('${challenge.currentProgress}/${challenge.targetProgress}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(challenge.color),
            ),
          ],
        ),
      ),
    );
  }
}

/// Displays a single badge.
class BadgeDisplay extends StatelessWidget {
  final BadgeData badge;

  const BadgeDisplay({
    super.key,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 30,
            backgroundColor: badge.color.withAlpha((0.2 * 255).round()),
            child: Icon(badge.icon, color: badge.color, size: 30),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 70,
            child: Text(
              badge.title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Displays a single statistic for the profile summary.
class ProfileSummaryStat extends StatelessWidget {
  final String title;
  final String value;

  const ProfileSummaryStat({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepOrange[700])),
        Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}

/// Displays a single performance history entry.
class PerformanceHistoryEntryCard extends StatelessWidget {
  final PerformanceTestResult testResult;

  const PerformanceHistoryEntryCard({
    super.key,
    required this.testResult,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            // Show the normalized score in a circle
            CircleAvatar(
              backgroundColor: Colors.deepOrange[100],
              child: Text('${testResult.normalizedScore}', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    testResult.testType,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(testResult.date, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text('${testResult.resultValue.toStringAsFixed(1)} ${testResult.unit}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Icon(
                  testResult.trendIcon,
                  color: testResult.trendColor,
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Displays an achievement item.
class AchievementDisplayCard extends StatelessWidget {
  final AchievementData achievement;

  const AchievementDisplayCard({
    super.key,
    required this.achievement,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: achievement.color.withAlpha((0.1 * 255).round()),
              child: Icon(achievement.icon, color: achievement.color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    achievement.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    achievement.description,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Displays a single metric in the AI feedback section.
class MetricDisplayCard extends StatelessWidget {
  final MetricData metric;

  const MetricDisplayCard({
    super.key,
    required this.metric,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: metric.color.withAlpha((0.1 * 255).round()),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(metric.icon, color: metric.color, size: 24),
            const SizedBox(height: 8),
            Text(
              metric.value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              metric.title,
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// Displays a single analysis point (strength or area to improve) in AI feedback.
class AnalysisPointCard extends StatelessWidget {
  final AnalysisPointData analysisPoint;

  const AnalysisPointCard({
    super.key,
    required this.analysisPoint,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: analysisPoint.color.withAlpha((0.05 * 255).round()),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              analysisPoint.title,
              style: TextStyle(fontWeight: FontWeight.bold, color: analysisPoint.color),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(analysisPoint.content, style: TextStyle(color: Colors.grey[700])),
          ],
        ),
      ),
    );
  }
}

/// Displays a line chart of athlete performance scores over sessions.
class PerformanceScoreChart extends StatelessWidget {
  final List<PerformanceTestResult> performanceResults;

  const PerformanceScoreChart({
    super.key,
    required this.performanceResults,
  });

  @override
  Widget build(BuildContext context) {
    if (performanceResults.isEmpty) {
      return const Center(child: Text('No performance data available to display chart.'));
    }

    // Use normalizedScore for chart
    final int maxScore = performanceResults.map<int>((PerformanceTestResult e) => e.normalizedScore).fold(0, max);
    final double maxY = max(100, maxScore + 10).toDouble(); // Ensure Y axis scales properly

    return AspectRatio(
      aspectRatio: 1.7,
      child: Padding(
        padding: const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(
              show: false,
            ),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: 1,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    final int index = value.toInt();
                    if (index >= 0 && index < performanceResults.length) {
                      return Text(
                        'Session ${index + 1}',
                        style: const TextStyle(
                          color: Color(0xff68737d),
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 20, // Adjust interval based on new score range
                  getTitlesWidget: (double value, TitleMeta meta) {
                    return Text(
                      '${value.toInt()}',
                      style: const TextStyle(
                        color: Color(0xff67727d),
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.left,
                    );
                  },
                  reservedSize: 30,
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: const Color(0xff37434d), width: 1),
            ),
            minX: 0,
            maxX: (performanceResults.length - 1).toDouble(),
            minY: 0,
            maxY: maxY,
            lineBarsData: <LineChartBarData>[
              LineChartBarData(
                spots: performanceResults.asMap().entries.map<FlSpot>((MapEntry<int, PerformanceTestResult> entry) {
                  return FlSpot(entry.key.toDouble(), entry.value.normalizedScore.toDouble());
                }).toList(),
                isCurved: true,
                gradient: LinearGradient(
                  colors: <Color>[
                    Colors.deepOrange.shade400,
                    Colors.deepOrange.shade800,
                  ],
                ),
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (FlSpot spot, double percent, LineChartBarData bar, int index) => FlDotCirclePainter(
                    radius: 3,
                    color: Colors.deepOrange,
                    strokeColor: Colors.deepOrange,
                  ),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: <Color>[
                      Colors.deepOrange.shade400.withOpacity(0.3),
                      Colors.deepOrange.shade800.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OpportunityDetailScreen extends StatelessWidget {
  final OpportunityData opportunity;

  const OpportunityDetailScreen({super.key, required this.opportunity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opportunity Details'),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              opportunity.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              opportunity.category,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildDetailRow(Icons.info_outline, 'Status', opportunity.status, opportunity.color),
                    _buildDetailRow(Icons.description, 'Description', opportunity.description),
                    _buildDetailRow(Icons.location_on, 'Location', opportunity.location),
                    _buildDetailRow(Icons.calendar_today, 'Dates', opportunity.dates),
                    _buildDetailRow(Icons.check_circle_outline, 'Eligibility', opportunity.eligibility),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // No pop-up needed, user can navigate to link if provided.
                  // For a real app, this would use url_launcher or similar.
                },
                icon: const Icon(Icons.app_registration),
                label: const Text('Apply / Register Now'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, [Color? valueColor]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: Colors.deepOrange[700], size: 24),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: valueColor ?? Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

/// Displays a single instruction item on the InstructionsScreen.
class InstructionCard extends StatelessWidget {
  final InstructionItem instruction;

  const InstructionCard({
    super.key,
    required this.instruction,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(instruction.icon, size: 36, color: Colors.deepOrange[700]),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    instruction.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    instruction.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Displays a single video recording instruction item.
class VideoRecordingInstructionCard extends StatelessWidget {
  final VideoRecordingInstruction instruction;

  const VideoRecordingInstructionCard({
    super.key,
    required this.instruction,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(instruction.icon, size: 36, color: Colors.deepOrange[700]),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    instruction.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    instruction.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Displays a single example video item.
class ExampleVideoCard extends StatelessWidget {
  final ExampleVideoData video;

  const ExampleVideoCard({
    super.key,
    required this.video,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      child: InkWell(
        onTap: () {
          // In a real app, this would open a video player. No SnackBar needed.
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                  child: Image.network(
                    video.thumbnailUrl,
                    fit: BoxFit.cover,
                    height: 180,
                    width: double.infinity,
                    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                      return Container(
                        height: 180,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: Icon(Icons.broken_image, color: Colors.grey[600], size: 40),
                      );
                    },
                  ),
                ),
                Icon(Icons.play_circle_fill, size: 60, color: Colors.white.withOpacity(0.8)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    video.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    video.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// COMPOUND WIDGETS
// -----------------------------------------------------------------------------

/// Section for displaying notifications.
class NotificationsOverviewSection extends StatelessWidget {
  final List<NotificationData> notifications;

  const NotificationsOverviewSection({
    super.key,
    required this.notifications,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Latest Notifications',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to full notifications screen
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const NotificationsPage(),
                      ),
                    );
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (notifications.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No new notifications.'),
                ),
              )
            else
              ...notifications.take(3).map<Widget>((NotificationData n) => NotificationCard(
                    notification: n,
                    onTap: () {
                      // No pop-up needed for tapping notifications in summary.
                    },
                  )).toList(),
          ],
        ),
      ),
    );
  }
}

/// Section for displaying career and program opportunities.
class OpportunitiesSection extends StatelessWidget {
  final bool isSummary;

  const OpportunitiesSection({super.key, this.isSummary = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  isSummary ? 'Upcoming Opportunities' : 'Athlete Opportunities Hub',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (isSummary)
                  TextButton(
                    onPressed: () {
                      final TabController? tabController = DefaultTabController.maybeOf(context);
                      if (tabController != null) {
                        tabController.animateTo(4); // Opportunities tab index (now 4)
                      }
                    },
                    child: const Text('View All'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Consumer<OpportunitiesData>(
              builder: (BuildContext context, OpportunitiesData opportunitiesData, Widget? child) {
                final List<Widget> opportunityWidgets = <Widget>[];
                int count = 0;

                for (final String category in opportunitiesData.categories) {
                  final List<OpportunityData>? opportunitiesForCategory =
                      opportunitiesData.allGroupedOpportunities[category];

                  if (opportunitiesForCategory != null && opportunitiesForCategory.isNotEmpty) {
                    if (isSummary && count >= 3) break; // Limit to 3 for summary

                    opportunityWidgets.add(
                      Padding(
                        padding: EdgeInsets.only(top: count == 0 ? 0.0 : 16.0, bottom: 8.0),
                        child: Text(
                          category,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange[700],
                          ),
                        ),
                      ),
                    );
                    opportunityWidgets.addAll(
                      opportunitiesForCategory.take(isSummary ? 1 : opportunitiesForCategory.length).map<Widget>((OpportunityData o) {
                        count++;
                        return OpportunityCard(
                          opportunity: o,
                          onTap: () {
                            Navigator.push<void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext dialogContext) {
                                  return OpportunityDetailScreen(opportunity: o);
                                },
                              ),
                            );
                          },
                        );
                      }).toList(),
                    );
                    if (isSummary && count >= 3) break;
                  }
                }
                if (opportunityWidgets.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No opportunities available at the moment.'),
                    ),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: opportunityWidgets,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Section for displaying the leaderboard with hierarchical region filters.
class LeaderboardSection extends StatelessWidget {
  final bool isSummary;

  const LeaderboardSection({super.key, this.isSummary = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  isSummary ? 'Top Performers' : 'Global Athlete Leaderboard',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (isSummary)
                  TextButton(
                    onPressed: () {
                      final TabController? tabController = DefaultTabController.maybeOf(context);
                      if (tabController != null) {
                        tabController.animateTo(3); // Leaderboard tab index (now 3)
                      }
                    },
                    child: const Text('View All'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Consumer<LeaderboardData>(
              builder: (BuildContext context, LeaderboardData leaderboardData, Widget? child) {
                final AthleteProvider athleteProvider = Provider.of<AthleteProvider>(context, listen: false);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (!isSummary) ...<Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => leaderboardData.toggleAgeGroupFilters(),
                              icon: Icon(leaderboardData.showAgeGroupFilters ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                              label: const Text('Age'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrange[100],
                                foregroundColor: Colors.deepOrange[700],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => leaderboardData.toggleRegionFilters(),
                              icon: Icon(leaderboardData.showRegionFilters ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                              label: const Text('Region'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrange[100],
                                foregroundColor: Colors.deepOrange[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (leaderboardData.showAgeGroupFilters) _buildFilterChips(
                        label: 'Filter by Age Group:',
                        options: leaderboardData.ageGroupOptions,
                        selectedOption: leaderboardData.selectedAgeGroup,
                        onSelected: leaderboardData.onAgeGroupSelected,
                      ),
                      if (leaderboardData.showRegionFilters)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      'Current Region: ${leaderboardData.activeRegionFilter}',
                                      style: const TextStyle(fontWeight: FontWeight.w500),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                if (leaderboardData.regionPath.isNotEmpty && leaderboardData.activeRegionFilter != 'All')
                                  IconButton(
                                    icon: const Icon(Icons.arrow_back),
                                    onPressed: leaderboardData.goBackRegionHierarchy,
                                    tooltip: 'Go back to parent region',
                                  ),
                              ],
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: leaderboardData.regionOptions.map<Widget>((String region) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    child: FilterChipWidget(
                                      label: region,
                                      isSelected: leaderboardData.activeRegionFilter == region,
                                      onSelected: (bool selected) {
                                        leaderboardData.onSelectRegionOption(selected ? region : 'All');
                                      },
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 16),
                    ],
                    if (leaderboardData.leaderboardEntries.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('No athletes found matching the current filters.'),
                        ),
                      )
                    else
                      Column(
                        children: leaderboardData.leaderboardEntries
                            .take(isSummary ? 5 : leaderboardData.leaderboardEntries.length)
                            .map<Widget>((LeaderboardEntry entry) {
                          final Athlete correspondingAthlete = athleteProvider.allAthletes.firstWhere((Athlete a) => a.name == entry.name);
                          return LeaderboardItemWidget(
                            entry: entry,
                            athlete: correspondingAthlete,
                          );
                        }).toList(),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips({
    required String label,
    required List<String> options,
    required String? selectedOption,
    required ValueChanged<String?> onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: options.map<Widget>((String option) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: FilterChipWidget(
                  label: option,
                  isSelected: selectedOption == option,
                  onSelected: (bool selected) {
                    onSelected(selected ? option : 'All');
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

/// Section for displaying active challenges.
class ChallengesSection extends StatelessWidget {
  final List<ChallengeData> challenges;
  final bool isSummary;

  const ChallengesSection({
    super.key,
    required this.challenges,
    this.isSummary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  isSummary ? 'Current Challenges' : 'Active Training Challenges',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (!isSummary) // Only show "View All" if not a summary, and there's no longer a Challenges tab
                  TextButton(
                    onPressed: () {
                      // If the tab is removed, this might navigate to a separate screen or be removed
                      // For now, removing the navigation if not in summary view and no tab
                    },
                    child: const Text('View All'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (challenges.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No active challenges.'),
                ),
              )
            else
              ...challenges.take(isSummary ? 2 : challenges.length).map<Widget>((ChallengeData c) => ChallengeProgressCard(challenge: c)).toList(),
          ],
        ),
      ),
    );
  }
}

/// Section for displaying badges earned.
class BadgesSection extends StatelessWidget {
  final List<BadgeData> badges;
  final bool isSummary;

  const BadgesSection({
    super.key,
    required this.badges,
    this.isSummary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  isSummary ? 'Recent Badges' : 'Your Accomplished Badges',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (isSummary)
                  TextButton(
                    onPressed: () {
                      final TabController? tabController = DefaultTabController.maybeOf(context);
                      if (tabController != null) {
                        tabController.animateTo(0); // Profile tab index
                      }
                    },
                    child: const Text('View All'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (badges.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No badges earned yet.'),
                ),
              )
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: badges.take(isSummary ? 4 : badges.length).map<Widget>((BadgeData b) => BadgeDisplay(badge: b)).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Section for displaying test history.
class PerformanceHistorySection extends StatelessWidget {
  final List<PerformanceTestResult> performanceResults;
  final bool isSummary;

  const PerformanceHistorySection({
    super.key,
    required this.performanceResults,
    this.isSummary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  isSummary ? 'Latest Performances' : 'Performance Evaluation History',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (isSummary)
                  TextButton(
                    onPressed: () {
                      final TabController? tabController = DefaultTabController.maybeOf(context);
                      if (tabController != null) {
                        tabController.animateTo(0); // Profile tab index
                      }
                    },
                    child: const Text('View All'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (performanceResults.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No performance history to display.'),
                ),
              )
            else
              ...performanceResults.take(isSummary ? 3 : performanceResults.length)
                  .map<Widget>((PerformanceTestResult tr) => PerformanceHistoryEntryCard(testResult: tr))
                  .toList(),
          ],
        ),
      ),
    );
  }
}

/// Section for displaying achievements.
class AchievementsSection extends StatelessWidget {
  final List<AchievementData> achievements;
  final bool isSummary;

  const AchievementsSection({
    super.key,
    required this.achievements,
    this.isSummary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  isSummary ? 'Key Achievements' : 'Your Milestones & Achievements',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (isSummary)
                  TextButton(
                    onPressed: () {
                      final TabController? tabController = DefaultTabController.maybeOf(context);
                      if (tabController != null) {
                        tabController.animateTo(0); // Profile tab index
                      }
                    },
                    child: const Text('View All'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (achievements.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No achievements unlocked yet.'),
                ),
              )
            else
              ...achievements.take(isSummary ? 2 : achievements.length).map<Widget>((AchievementData a) => AchievementDisplayCard(achievement: a)).toList(),
          ],
        ),
      ),
    );
  }
}

/// Section for displaying AI feedback metrics and analysis.
class MLFeedbackSection extends StatelessWidget {
  final List<MetricData> metrics;
  final List<AnalysisPointData> feedback;
  final bool isSummary;

  const MLFeedbackSection({
    super.key,
    required this.metrics,
    required this.feedback,
    this.isSummary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              isSummary ? 'AI Insights Summary' : 'AI Performance Insights',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: isSummary ? min(3, metrics.length) : metrics.length,
                itemBuilder: (BuildContext context, int index) {
                  return MetricDisplayCard(metric: metrics[index]);
                },
              ),
            ),
            const SizedBox(height: 16),
            ...feedback.take(isSummary ? 2 : feedback.length).map<Widget>((AnalysisPointData a) => AnalysisPointCard(analysisPoint: a)).toList(),
          ],
        ),
      ),
    );
  }
}

/// Displays athlete's personal details section.
class PersonalDetailsSection extends StatelessWidget {
  final Athlete athlete;
  final bool showEditButton;

  const PersonalDetailsSection({super.key, required this.athlete, this.showEditButton = true});

  static const String _defaultProfilePictureUrl =
      'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg';

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Personal Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.deepOrange[400],
                  child: athlete.profilePictureUrl != _defaultProfilePictureUrl
                      ? ClipOval(
                          child: Image.network(
                            athlete.profilePictureUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                              return Text(
                                athlete.name[0],
                                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                              );
                            },
                          ),
                        )
                      : Text(
                          athlete.name[0],
                          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildDetailRow(Icons.person, 'Name', athlete.name),
                      _buildDetailRow(Icons.cake, 'Age', '${athlete.age} years'),
                      _buildDetailRow(Icons.wc, 'Gender', athlete.gender),
                      _buildDetailRow(Icons.location_on, 'Location', athlete.region),
                      _buildDetailRow(Icons.email, 'Email', athlete.email),
                    ],
                  ),
                ),
              ],
            ),
            if (showEditButton)
              const SizedBox(height: 16),
            if (showEditButton)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    // No pop-up needed. In a real app, this would navigate to an edit profile screen.
                  },
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Edit Profile'),
                  style: TextButton.styleFrom(foregroundColor: Colors.deepOrange[700]),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: <Widget>[
          Icon(icon, color: Colors.grey[600], size: 16),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
          Expanded(child: Text(value, maxLines: 1, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}

/// Displays athlete's anthropometric data section.
class AnthropometricDataSection extends StatelessWidget {
  final Athlete athlete;
  const AnthropometricDataSection({super.key, required this.athlete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Anthropometric Data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ProfileSummaryStat(title: 'Height', value: '${athlete.anthropometrics.heightCm.toStringAsFixed(1)} cm'),
                ProfileSummaryStat(title: 'Weight', value: '${athlete.anthropometrics.weightKg.toStringAsFixed(1)} kg'),
                ProfileSummaryStat(title: 'BMI', value: '${athlete.anthropometrics.bmi.toStringAsFixed(1)}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Displays athlete's sports & training history section.
class SportsTrainingHistorySection extends StatelessWidget {
  final Athlete athlete;
  const SportsTrainingHistorySection({super.key, required this.athlete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Sports & Training History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (athlete.sportsHistory.isEmpty)
              const Center(child: Text('No sports history recorded.'))
            else
              ...athlete.sportsHistory.map<Widget>((SportsHistoryEntry entry) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  color: Colors.blueGrey[50],
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(entry.sportName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('Period: ${entry.period}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        Text('Team: ${entry.teamName}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        Text('Achievements: ${entry.achievements}',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      ],
                    ),
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }
}

/// Displays athlete's training schedule & goals section.
class TrainingScheduleGoalsSection extends StatelessWidget {
  final Athlete athlete;
  const TrainingScheduleGoalsSection({super.key, required this.athlete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Training Schedule & Goals',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (athlete.trainingGoals.isEmpty)
              const Center(child: Text('No training goals set.'))
            else
              ...athlete.trainingGoals.map<Widget>((TrainingGoal goal) {
                double progress = goal.currentProgress / goal.targetValue;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  color: Colors.deepOrange[50],
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(goal.goalDescription, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('Target Date: ${goal.targetDate}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange[700]!),
                        ),
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text('${goal.currentProgress}/${goal.targetValue}',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }
}

/// Displays uploaded videos of past tests section.
class UploadedVideosSection extends StatelessWidget {
  final List<PerformanceTestResult> performanceResults;

  const UploadedVideosSection({super.key, required this.performanceResults});

  @override
  Widget build(BuildContext context) {
    final List<PerformanceTestResult> videos =
        performanceResults.where((PerformanceTestResult result) => result.videoUrl != null).toList();
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Uploaded Videos of Past Tests',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (videos.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No videos uploaded yet.'),
                ),
              )
            else
              SizedBox(
                height: 150, // Fixed height for horizontal list
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: videos.length,
                  itemBuilder: (BuildContext context, int index) {
                    final PerformanceTestResult videoEntry = videos[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: 150,
                            height: 100,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.play_circle_fill, size: 40, color: Colors.grey),
                            ),
                          ),
                          const SizedBox(height: 4),
                          SizedBox(
                            width: 150,
                            child: Text(
                              videoEntry.testType,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
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

// -----------------------------------------------------------------------------
// SCREENS
// -----------------------------------------------------------------------------

/// Full page to display detailed information about a selected athlete from the leaderboard.
class AthleteProfilePage extends StatelessWidget {
  final Athlete athlete;

  const AthleteProfilePage({
    super.key,
    required this.athlete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(athlete.name),
        backgroundColor: Colors.deepOrange,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // No pop-up needed for share button. In a real app, this would trigger a share intent.
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            PersonalDetailsSection(athlete: athlete, showEditButton: false),
            AnthropometricDataSection(athlete: athlete),
            SportsTrainingHistorySection(athlete: athlete),
            TrainingScheduleGoalsSection(athlete: athlete),
            BadgesSection(badges: athlete.badges, isSummary: false),
            AchievementsSection(achievements: athlete.achievements, isSummary: false),
            MLFeedbackSection(metrics: athlete.mlMetrics, feedback: athlete.mlFeedback, isSummary: false),
            PerformanceHistorySection(performanceResults: athlete.performanceResults, isSummary: false),
            UploadedVideosSection(performanceResults: athlete.performanceResults),
            PerformanceScoreChart(performanceResults: athlete.performanceResults),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

/// Dedicated screen for Notifications.
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Consumer<NotificationScreenData>(
        builder: (BuildContext context, NotificationScreenData notificationData, Widget? child) {
          final List<NotificationData> allNotifications = notificationData.notifications;
          if (allNotifications.isEmpty) {
            return const Center(
              child: Text('No notifications to display.'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: allNotifications.length,
            itemBuilder: (BuildContext context, int index) {
              final NotificationData notification = allNotifications[index];
              return NotificationCard(
                notification: notification,
                onTap: () => notificationData.markAsRead(index),
              );
            },
          );
        },
      ),
    );
  }
}


/// Placeholder screen for Settings.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.deepOrange,
      ),
      body: const Center(
        child: Text(
          'Settings content here',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

/// Placeholder screen for Support.
class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support'),
        backgroundColor: Colors.deepOrange,
      ),
      body: const Center(
        child: Text(
          'Support content here',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

/// Placeholder screen for Logout.
class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logout'),
        backgroundColor: Colors.deepOrange,
      ),
      body: const Center(
        child: Text(
          'Logging out...',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

/// Placeholder screen for Messenger.
class MessengerScreen extends StatelessWidget {
  const MessengerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messenger'),
        backgroundColor: Colors.deepOrange,
      ),
      body: const Center(
        child: Text(
          'Messenger content here',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

/// The initial screen displaying app instructions.
class InstructionsScreen extends StatelessWidget {
  final List<InstructionItem> instructions;
  final Function(BuildContext) onGetStarted; // Modified to accept BuildContext

  const InstructionsScreen({
    super.key,
    required this.instructions,
    required this.onGetStarted,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Athlete Hub!'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: instructions.length,
              itemBuilder: (BuildContext context, int index) {
                return InstructionCard(instruction: instructions[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => onGetStarted(context), // Pass the screen's context
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50), // Make button full width
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Get Started'),
            ),
          ),
        ],
      ),
    );
  }
}

/// A screen to display guidelines for video recording.
class VideoRecordingInstructionsScreen extends StatelessWidget {
  final List<VideoRecordingInstruction> instructions;

  const VideoRecordingInstructionsScreen({
    super.key,
    required this.instructions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Recording Guidelines'),
        backgroundColor: Colors.deepOrange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: instructions.length,
              itemBuilder: (BuildContext context, int index) {
                return VideoRecordingInstructionCard(instruction: instructions[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // For now, just pop. In a real application, this might lead to a recording screen.
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Got It! Start Recording'),
            ),
          ),
        ],
      ),
    );
  }
}

/// A screen to display example videos for athletes.
class ExampleVideosScreen extends StatelessWidget {
  final List<ExampleVideoData> exampleVideos;

  const ExampleVideosScreen({
    super.key,
    required this.exampleVideos,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: exampleVideos.isEmpty
          ? const Center(
              child: Text(
                'No example videos available at the moment.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: exampleVideos.length,
              itemBuilder: (BuildContext context, int index) {
                return ExampleVideoCard(video: exampleVideos[index]);
              },
            ),
    );
  }
}

/// The main screen of the application with multiple tabs for navigation.
class MainScreen extends StatefulWidget {
  final List<ChallengeData> initialChallenges;
  final List<VideoRecordingInstruction> initialVideoInstructions;
  final List<ExampleVideoData> initialExampleVideos;

  const MainScreen({
    super.key,
    required this.initialChallenges,
    required this.initialVideoInstructions,
    required this.initialExampleVideos,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Adjusted length to 5 after removing Challenges tab
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AthleteProvider athleteProvider = Provider.of<AthleteProvider>(context);
    final Athlete currentAthlete = athleteProvider.currentAthlete;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Athlete Hub'),
        centerTitle: true, // CENTERED TITLE
        actions: <Widget>[
          // Messenger icon (moved to left of notifications)
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: () {
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(builder: (BuildContext context) => const MessengerScreen()),
              );
            },
            tooltip: 'Messenger',
          ),
          // Notifications icon
          Consumer<NotificationScreenData>(
              builder: (BuildContext context, NotificationScreenData notificationData, Widget? child) {
                  final int unreadCount = notificationData.notifications.where((NotificationData n) => !n.isRead).length;
                  return Stack(
                      children: <Widget>[
                          IconButton(
                              icon: const Icon(Icons.notifications),
                              onPressed: () {
                                  Navigator.push<void>( // Navigate to a dedicated NotificationsPage
                                      context,
                                      MaterialPageRoute<void>(builder: (BuildContext context) => const NotificationsPage()),
                                  );
                              },
                              tooltip: 'Notifications',
                          ),
                          if (unreadCount > 0)
                              Positioned(
                                  right: 8,
                                  top: 8,
                                  child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(6),
                                      ),
                                      constraints: const BoxConstraints(
                                          minWidth: 14,
                                          minHeight: 14,
                                      ),
                                      child: Text(
                                          '$unreadCount',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 8,
                                          ),
                                          textAlign: TextAlign.center,
                                      ),
                                  ),
                              ),
                      ],
                  );
              },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu), // Three lines icon
            onSelected: (String value) {
              switch (value) {
                case 'Settings':
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(builder: (BuildContext context) => const SettingsScreen()),
                  );
                  break;
                case 'Support':
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(builder: (BuildContext context) => const SupportScreen()),
                  );
                  break;
                case 'Logout':
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(builder: (BuildContext context) => const LogoutScreen()),
                  );
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Settings',
                child: Row(
                  children: <Widget>[
                    Icon(Icons.settings),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Support',
                child: Row(
                  children: <Widget>[
                    Icon(Icons.help_outline),
                    SizedBox(width: 8),
                    Text('Support'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Logout',
                child: Row(
                  children: <Widget>[
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false, // Changed to false to distribute tabs evenly
          tabs: const <Widget>[
            Tab(icon: Icon(Icons.person), text: 'Profile'),
            Tab(icon: Icon(Icons.dashboard), text: 'Dashboard'),
            Tab(icon: Icon(Icons.videocam), text: 'Videos'),
            Tab(icon: Icon(Icons.leaderboard), text: 'Leaderboard'), // Now at index 3
            Tab(icon: Icon(Icons.emoji_events), text: 'Opportunities'), // Now at index 4
          ],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          // Profile Tab (Index 0)
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                PersonalDetailsSection(athlete: currentAthlete),
                AnthropometricDataSection(athlete: currentAthlete),
                SportsTrainingHistorySection(athlete: currentAthlete),
                TrainingScheduleGoalsSection(athlete: currentAthlete),
                BadgesSection(badges: currentAthlete.badges, isSummary: false),
                AchievementsSection(achievements: currentAthlete.achievements, isSummary: false),
                MLFeedbackSection(metrics: currentAthlete.mlMetrics, feedback: currentAthlete.mlFeedback, isSummary: false),
                PerformanceHistorySection(performanceResults: currentAthlete.performanceResults, isSummary: false),
                UploadedVideosSection(performanceResults: currentAthlete.performanceResults),
                PerformanceScoreChart(performanceResults: currentAthlete.performanceResults),
                const SizedBox(height: 16),
              ],
            ),
          ),
          // Dashboard Tab (Index 1)
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Welcome back, ${currentAthlete.name.split(' ')[0]}!',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Here\'s your performance overview:',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 20),
                      Card(
                        elevation: 2,
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              DashboardStatCard(
                                  title: 'Last Score', value: '${currentAthlete.performanceStats.lastScore}', icon: Icons.score),
                              DashboardStatCard(
                                  title: 'Improvement',
                                  value: '${currentAthlete.performanceStats.improvementPercentage}%',
                                  icon: Icons.trending_up),
                              DashboardStatCard(title: 'Rank', value: '#${currentAthlete.performanceStats.rank}', icon: Icons.leaderboard),
                              DashboardStatCard(
                                  title: 'Activities',
                                  value: '${currentAthlete.performanceStats.totalActivities}',
                                  icon: Icons.run_circle),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                NotificationsOverviewSection(notifications: Provider.of<NotificationScreenData>(context).notifications.where((NotificationData n) => !n.isRead).toList()),
                ChallengesSection(challenges: widget.initialChallenges, isSummary: true), // Challenges summary remains
                PerformanceHistorySection(performanceResults: currentAthlete.performanceResults, isSummary: true),
                BadgesSection(badges: currentAthlete.badges, isSummary: true),
                AchievementsSection(achievements: currentAthlete.achievements, isSummary: true),
                MLFeedbackSection(metrics: currentAthlete.mlMetrics, feedback: currentAthlete.mlFeedback, isSummary: true),
                LeaderboardSection(isSummary: true),
                OpportunitiesSection(isSummary: true),
                const SizedBox(height: 16),
              ],
            ),
          ),
          // Videos Tab (Index 2)
          ExampleVideosScreen(exampleVideos: widget.initialExampleVideos),
          // Leaderboard Tab (Index 3, adjusted from 4)
          const SingleChildScrollView(
            child: LeaderboardSection(isSummary: false),
          ),
          // Opportunities Tab (Index 4, adjusted from 5)
          const SingleChildScrollView(
            child: OpportunitiesSection(isSummary: false),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // When the record button is clicked, show video recording guidelines.
          Navigator.push<void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => VideoRecordingInstructionsScreen(
                instructions: widget.initialVideoInstructions,
              ),
            ),
          );
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.videocam, color: Colors.white),
      ),
    );
  }
}
