import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:collection'; // For SplayTreeSet
import 'package:fl_chart/fl_chart.dart'; // Import fl_chart
import 'dart:math';

import 'package:provider/single_child_widget.dart'; // For max function

// The main function, which is the entry point of the application.
void main() {
  runApp(const MyApp());
}

// -----------------------------------------------------------------------------
// DATA_MODEL
// -----------------------------------------------------------------------------

/// Represents player's overall performance statistics in Kabaddi.
class PlayerStats {
  final int lastScore;
  final int improvementPercentage;
  final int rank;
  final int totalTests;

  const PlayerStats({
    required this.lastScore,
    required this.improvementPercentage,
    required this.rank,
    required this.totalTests,
  });
}

/// Represents a notification item.
class NotificationData {
  final String title;
  final String time;
  final IconData icon;

  const NotificationData({
    required this.title,
    required this.time,
    required this.icon,
  });
}

/// Represents a career or program opportunity specifically in Kabaddi.
class OpportunityData {
  final String title;
  final String category; // Represents the Kabaddi league/development category
  final String status;
  final Color color;

  const OpportunityData({
    required this.title,
    required this.category,
    required this.status,
    required this.color,
  });
}

/// Represents an entry in the Kabaddi leaderboard.
class LeaderboardUserData {
  final int rank;
  final String name;
  final int score;
  final int age; // New field
  final String region; // New field, now can represent various levels
  final int totalMatchesPlayed; // New field: How many matches the player has played
  final bool isCurrentUser;
  final String profilePictureUrl; // Added profile picture URL

  const LeaderboardUserData({
    required this.rank,
    required this.name,
    required this.score,
    required this.age,
    required this.region,
    required this.totalMatchesPlayed,
    this.isCurrentUser = false,
    this.profilePictureUrl = 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg', // Default placeholder
  });
}

/// Represents an active Kabaddi challenge.
class ChallengeData {
  final String title;
  final String description;
  final int currentProgress;
  final int targetProgress;
  final Color color;

  const ChallengeData({
    required this.title,
    required this.description,
    required this.currentProgress,
    required this.targetProgress,
    required this.color,
  });
}

/// Represents a badge achieved by the Kabaddi player.
class BadgeData {
  final String title;
  final IconData icon;
  final Color color;

  const BadgeData({
    required this.title,
    required this.icon,
    required this.color,
  });
}

/// Represents a single Kabaddi test result in the player's history.
class TestResult {
  final String testType;
  final int score;
  final String date;
  final IconData trendIcon;
  final Color trendColor;

  const TestResult({
    required this.testType,
    required this.score,
    required this.date,
    required this.trendIcon,
    required this.trendColor,
  });
}

/// Represents an achievement or milestone in Kabaddi.
class AchievementData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const AchievementData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

/// Represents a performance metric shown in ML feedback for Kabaddi.
class MetricData {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const MetricData({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });
}

/// Represents an analysis point (strength or area to improve) in ML feedback for Kabaddi.
class AnalysisPointData {
  final String title;
  final String content;
  final Color color;

  const AnalysisPointData({
    required this.title,
    required this.content,
    required this.color,
  });
}

// State management for Leaderboard with hierarchical region filtering
class LeaderboardData extends ChangeNotifier {
  final List<LeaderboardUserData> _allLeaderboardUsers;
  String? _selectedAgeGroup = 'All';
  bool _showAgeGroupFilters = false;
  bool _showRegionFilters = false;

  // This stores the current path of selected parent regions, e.g., ['Global', 'India']
  // The last element in this list determines the current level of options to display.
  final List<String> _regionPath = <String>[];
  // This stores the *actual region value selected for filtering users*.
  // It can be 'All', or 'Global', or 'India', or 'Haryana', or 'Damdama'.
  String? _currentSelectedRegionFilter = 'All';

  // Updated age group options
  static const List<String> _ageGroupOptions = <String>['All', 'u10', 'u12', 'u14', 'u17', 'u19', 'u21', 'u21+'];

  // Explicitly define parent-child relationships for regions present in sample data.
  // 'All' is a special key representing the root level for initial options.
  static final Map<String, List<String>> _regionChildrenMap = <String, List<String>>{
    'All': <String>['Global'], // Changed: Only 'Global' is a direct child of 'All' now
    'Global': <String>[
      'India',
      'Iran',
      'Pakistan',
      'Bangladesh',
      'South Korea',
      'Japan',
      'Kenya',
      'Argentina',
      'England'
    ], // Updated to include new nations
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
      'Gujarat'
    ],
    'Iran': <String>[], // No sub-regions for Iran in sample data
    'Pakistan': <String>[], // New nation
    'Bangladesh': <String>[], // New nation
    'South Korea': <String>[], // New nation
    'Japan': <String>[], // New nation
    'Kenya': <String>[], // New nation
    'Argentina': <String>[], // New nation
    'England': <String>[], // New nation
    'Haryana': <String>['Gurugram'],
    'Punjab': <String>[],
    'Andhra Pradesh': <String>[],
    'Uttar Pradesh': <String>[],
    'Maharashtra': <String>[],
    'Tamil Nadu': <String>[],
    'Himachal Pradesh': <String>[],
    'Delhi': <String>[],
    'Rajasthan': <String>[],
    'Gujarat': <String>[],
    'Gurugram': <String>['Sohna'],
    'Sohna': <String>['Damdama'],
    'Damdama': <String>[],
  };

  // Pre-calculate child-to-parent map for efficient traversal up the hierarchy
  static final Map<String, String> _childToParentMap = _createChildToParentMap(_regionChildrenMap);

  static Map<String, String> _createChildToParentMap(Map<String, List<String>> childrenMap) {
    final Map<String, String> reverseMap = <String, String>{};
    childrenMap.forEach((String parent, List<String> children) {
      for (final String child in children) {
        if (child != 'All') {
          // 'All' shouldn't have a parent in this map
          reverseMap[child] = parent;
        }
      }
    });
    return reverseMap;
  }

  LeaderboardData({required List<LeaderboardUserData> initialUsers}) : _allLeaderboardUsers = initialUsers;

  String? get selectedAgeGroup => _selectedAgeGroup;
  bool get showAgeGroupFilters => _showAgeGroupFilters;
  bool get showRegionFilters => _showRegionFilters;

  String? get activeRegionFilter => _currentSelectedRegionFilter;
  List<String> get regionPath => List<String>.unmodifiable(_regionPath);

  // Determines the parent region whose children should be shown as current options.
  String get currentRegionPathParent {
    if (_regionPath.isEmpty) return 'All';
    return _regionPath.last;
  }

  // Provides the list of region options for the currently displayed hierarchical level.
  List<String> get regionOptions {
    final SplayTreeSet<String> options = SplayTreeSet<String>();
    options.add('All'); // Always include 'All' to reset filter

    // The current active filter is already shown above the chips,
    // so we don't add the current parent to the options list.

    final List<String> children = _regionChildrenMap[currentRegionPathParent] ?? <String>[];

    // Get all unique regions from the entire dataset for validation.
    // This ensures we only show options for regions that actually exist in the user data,
    // or regions that are parents to existing regions.
    final SplayTreeSet<String> uniqueRegionsInUsers = SplayTreeSet<String>();
    for (final LeaderboardUserData user in _allLeaderboardUsers) {
      uniqueRegionsInUsers.add(user.region);
      // Also add all ancestors of user.region to ensure their filter options appear
      String? currentParent = _childToParentMap[user.region];
      while (currentParent != null && currentParent != 'All') {
        uniqueRegionsInUsers.add(currentParent);
        currentParent = _childToParentMap[currentParent];
      }
    }

    for (final String child in children) {
      // Add child if it exists in user data OR it's a parent region with sub-regions defined.
      if (uniqueRegionsInUsers.contains(child) ||
          (_regionChildrenMap.containsKey(child) && _regionChildrenMap[child]!.isNotEmpty)) {
        options.add(child);
      }
    }
    return options.toList();
  }

  List<LeaderboardUserData> get leaderboardUsers {
    List<LeaderboardUserData> filteredList = _allLeaderboardUsers;

    // Filter by age group
    if (_selectedAgeGroup != null && _selectedAgeGroup != 'All') {
      filteredList = filteredList.where((LeaderboardUserData user) {
        return _getAgeGroupString(user.age) == _selectedAgeGroup;
      }).toList();
    }

    // Filter by hierarchical region
    if (_currentSelectedRegionFilter != null && _currentSelectedRegionFilter != 'All') {
      filteredList = filteredList.where((LeaderboardUserData user) {
        return _isDescendantOf(user.region, _currentSelectedRegionFilter!);
      }).toList();
    }

    // Always re-sort and re-rank after filtering
    filteredList.sort((LeaderboardUserData a, LeaderboardUserData b) => b.score.compareTo(a.score));

    return List<LeaderboardUserData>.generate(filteredList.length, (int i) {
      final LeaderboardUserData user = filteredList[i];
      return LeaderboardUserData(
        rank: i + 1, // Dynamic rank based on filtered and sorted list
        name: user.name,
        score: user.score,
        age: user.age,
        region: user.region,
        totalMatchesPlayed: user.totalMatchesPlayed, // Include the new field
        isCurrentUser: user.isCurrentUser,
        profilePictureUrl: user.profilePictureUrl, // Include profile picture URL
      );
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
      _showRegionFilters = false; // Close region filters if age group filters are opened
    }
    notifyListeners();
  }

  void toggleRegionFilters() {
    _showRegionFilters = !_showRegionFilters;
    if (_showRegionFilters) {
      _showAgeGroupFilters = false; // Close age group filters if region filters are opened
    }
    notifyListeners();
  }

  // Handles selection of a region option, either drilling down or selecting a leaf.
  void onSelectRegionOption(String? region) {
    if (region == null || region == 'All') {
      _regionPath.clear();
      _currentSelectedRegionFilter = 'All';
    } else {
      // If the selected region has children defined, drill down into it.
      if (_regionChildrenMap.containsKey(region) && _regionChildrenMap[region]!.isNotEmpty) {
        // Only add to path if it's a direct child of the current last path element or 'All'
        if (_regionPath.isEmpty || (_regionPath.last == _childToParentMap[region])) {
          _regionPath.add(region);
        } else if (_childToParentMap.containsKey(region) && _childToParentMap[region] == 'Global') {
          // This handles cases where user clicks on 'India' or 'Iran' when 'All' is the parent
          _regionPath.clear();
          _regionPath.add(region);
        }
        _currentSelectedRegionFilter = region; // Filter by this new parent region
      } else {
        // It's a leaf node or a specific selection without further children,
        // so just apply it as the filter.
        // Update the path to reflect the full path to this selected leaf node.
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

  // Allows navigation back up the region hierarchy.
  void goBackRegionHierarchy() {
    if (_regionPath.isNotEmpty) {
      _regionPath.removeLast();
      // After going back, the active filter becomes the new last element in the path, or 'All' if path is empty.
      _currentSelectedRegionFilter = _regionPath.isEmpty ? 'All' : _regionPath.last;
    } else {
      _currentSelectedRegionFilter = 'All'; // Already at the top level
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

  // Helper to check if a potentialChild region is a descendant of potentialParent.
  // This is used for filtering the leaderboard users.
  bool _isDescendantOf(String potentialChild, String potentialParent) {
    if (potentialChild == potentialParent) return true;
    if (potentialParent == 'All') return true; // 'All' at the top level means no specific region filter.

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
    'Pro Kabaddi League',
    'Amateur League',
    'Youth Development',
    'Selections',
    'Trials',
    'Tournaments',
    'Scholarships & Training',
    'Camps & Workshops',
  ];

  final Map<String, List<OpportunityData>> _allOpportunities;

  OpportunitiesData({required Map<String, List<OpportunityData>> initialOpportunities})
      : _allOpportunities = initialOpportunities;

  List<String> get categories => _categories;
  Map<String, List<OpportunityData>> get allGroupedOpportunities => _allOpportunities;

  // No need for _selectedCategory or onCategorySelected methods anymore
  // as all categories and their opportunities will be displayed.
}

// -----------------------------------------------------------------------------
// ATOMIC WIDGETS
// -----------------------------------------------------------------------------

/// Displays a single Kabaddi performance statistic with an icon, value, and title.
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

  const NotificationCard({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.deepOrange[50],
            child: Icon(notification.icon, color: Colors.deepOrange[600], size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  notification.title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(notification.time, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Displays a single opportunity item.
class OpportunityCard extends StatelessWidget {
  final OpportunityData opportunity;

  const OpportunityCard({
    super.key,
    required this.opportunity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: opportunity.color.withAlpha((0.05 * 255).round()),
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
  final LeaderboardUserData user;
  final VoidCallback onTap; // Callback for when the item is tapped

  const LeaderboardItemWidget({
    super.key,
    required this.user,
    required this.onTap,
  });

  // Default placeholder URL
  static const String _defaultProfilePictureUrl = 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg';

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: user.isCurrentUser ? Colors.deepOrange[50] : null,
      child: InkWell(
        onTap: onTap, // Hook up the tap event
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: user.rank <= 3 ? Colors.amber[700] : Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${user.rank}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: user.rank <= 3 ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.deepOrange[100],
                child: user.profilePictureUrl != _defaultProfilePictureUrl
                    ? ClipOval(
                        child: Image.network(
                          user.profilePictureUrl,
                          width: 40, // 2 * radius
                          height: 40, // 2 * radius
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                            // Fallback to text initial on image load error
                            return Text(
                              user.name[0],
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                            );
                          },
                        ),
                      )
                    : Text(
                        user.name[0],
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      user.name,
                      style: TextStyle(
                        fontWeight: user.isCurrentUser ? FontWeight.bold : FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Age: ${user.age} years', // Displaying age on its own line
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute nation and score
                      children: <Widget>[
                        Text(
                          'Nation: ${user.region}', // Displaying region as nation on its own line
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${user.score}', // Credit score (original score)
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
            width: 70, // Fixed width to prevent overflow for title
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

/// Displays a single test history entry.
class TestHistoryEntryCard extends StatelessWidget {
  final TestResult testResult;

  const TestHistoryEntryCard({
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
            CircleAvatar(
              backgroundColor: Colors.deepOrange[100],
              child: Text('${testResult.score}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
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
                Text('${testResult.score}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

/// Displays a single achievement item.
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
                    maxLines: 2, // Allow two lines for description
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

/// Displays a single metric in the ML feedback section.
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

/// Displays a single analysis point (strength or area to improve) in ML feedback.
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

/// Displays a line chart of Kabaddi test scores over attempts.
class KabaddiTestScoreChart extends StatelessWidget {
  final List<TestResult> testResults;

  const KabaddiTestScoreChart({
    super.key,
    required this.testResults,
  });

  @override
  Widget build(BuildContext context) {
    if (testResults.isEmpty) {
      return const Center(child: Text('No test data available to display chart.'));
    }

    // Determine max score for Y-axis scaling, ensuring it's at least 100 or slightly above the highest score.
    final int maxScore = testResults.map<int>((TestResult e) => e.score).fold(0, max);
    final double maxY =
        max(100, maxScore + 10).toDouble(); // Ensure Y-axis goes up to at least 100 or slightly above max score.

    return AspectRatio(
      aspectRatio: 1.7, // Wider than tall
      child: Padding(
        padding: const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(
              show: false, // Removed grid lines
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
                    if (index >= 0 && index < testResults.length) {
                      return Text(
                        'Test ${index + 1}',
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
                  interval: 20, // Y-axis labels every 20 points
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
            maxX: (testResults.length - 1).toDouble(),
            minY: 0,
            maxY: maxY,
            lineBarsData: <LineChartBarData>[
              LineChartBarData(
                spots: testResults.asMap().entries.map<FlSpot>((MapEntry<int, TestResult> entry) {
                  return FlSpot(entry.key.toDouble(), entry.value.score.toDouble());
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

/// Full page to display detailed information about a selected player from the leaderboard.
class PlayerProfilePage extends StatelessWidget {
  final LeaderboardUserData player;

  const PlayerProfilePage({
    super.key,
    required this.player,
  });

  // Default placeholder URL
  static const String _defaultProfilePictureUrl = 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(player.name),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.deepOrange[400], // Consistent background color
                      child: player.profilePictureUrl != _defaultProfilePictureUrl
                          ? ClipOval(
                              child: Image.network(
                                player.profilePictureUrl,
                                width: 120, // 2 * radius
                                height: 120, // 2 * radius
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                  // Fallback to text initial on image load error
                                  return Text(
                                    player.name[0],
                                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                                  );
                                },
                              ),
                            )
                          : Text(
                              player.name[0],
                              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      player.name,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    if (player.isCurrentUser)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          '(This is you!)',
                          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.deepOrange[400]),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 0),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: <Widget>[
                      _buildDetailRow(Icons.leaderboard, 'Rank', '${player.rank}'),
                      _buildDetailRow(Icons.person, 'Age', '${player.age} years'),
                      _buildDetailRow(Icons.location_on, 'Region', player.region),
                      _buildDetailRow(Icons.score, 'Score', '${player.score}'),
                      _buildDetailRow(Icons.sports_score, 'Matches Played', '${player.totalMatchesPlayed}'),
                    ],
                  ),
                ),
              ),
              // Add more sections if a player profile would have more data, e.g.,
              // recent performance, achievements specific to them, etc.
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          Icon(icon, color: Colors.deepOrange[700], size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// COMPOUND WIDGETS
// -----------------------------------------------------------------------------

/// Section for displaying notifications.
class NotificationSection extends StatelessWidget {
  final List<NotificationData> notifications;

  const NotificationSection({
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
            const Text(
              'Notifications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...notifications.map<Widget>((NotificationData n) => NotificationCard(notification: n)).toList(),
          ],
        ),
      ),
    );
  }
}

/// Section for displaying career and program opportunities.
class OpportunitiesSection extends StatelessWidget {
  const OpportunitiesSection({super.key});

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
              'Kabaddi Opportunities Hub',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Consumer<OpportunitiesData>(
              builder: (BuildContext context, OpportunitiesData opportunitiesData, Widget? child) {
                final List<Widget> opportunityWidgets = <Widget>[];

                for (final String category in opportunitiesData.categories) {
                  final List<OpportunityData>? opportunitiesForCategory =
                      opportunitiesData.allGroupedOpportunities[category];

                  if (opportunitiesForCategory != null && opportunitiesForCategory.isNotEmpty) {
                    opportunityWidgets.add(
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
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
                      opportunitiesForCategory.map<Widget>((OpportunityData o) {
                        return OpportunityCard(opportunity: o);
                      }).toList(),
                    );
                  }
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
  const LeaderboardSection({super.key});

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
              'Kabaddi Leaderboard',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Consumer<LeaderboardData>(
              builder: (BuildContext context, LeaderboardData leaderboardData, Widget? child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              leaderboardData.toggleAgeGroupFilters();
                            },
                            icon: Icon(
                                leaderboardData.showAgeGroupFilters ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                            label: const Text('Age Group'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange[100],
                              foregroundColor: Colors.deepOrange[700],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              leaderboardData.toggleRegionFilters();
                            },
                            icon: Icon(leaderboardData.showRegionFilters ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                            label: const Text('Region Filter'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange[100],
                              foregroundColor: Colors.deepOrange[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (leaderboardData.showAgeGroupFilters)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 16),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text('Filter by Age Group:', style: TextStyle(fontWeight: FontWeight.w500)),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: LeaderboardData._ageGroupOptions.map<Widget>((String ageGroup) {
                                return Padding(
                                  // Added padding for horizontal chips
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: FilterChipWidget(
                                    label: ageGroup,
                                    isSelected: leaderboardData.selectedAgeGroup == ageGroup,
                                    onSelected: (bool selected) {
                                      leaderboardData.onAgeGroupSelected(selected ? ageGroup : 'All');
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    // Hierarchical Region Filters
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
                                    'Current Filter: ${leaderboardData.activeRegionFilter}',
                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              if (leaderboardData.regionPath.isNotEmpty && leaderboardData.activeRegionFilter != 'All')
                                IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  onPressed: () {
                                    leaderboardData.goBackRegionHierarchy();
                                  },
                                  tooltip: 'Go back to parent region',
                                ),
                            ],
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: leaderboardData.regionOptions.map<Widget>((String region) {
                                return Padding(
                                  // Added padding for horizontal chips
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
                    Column(
                      children: leaderboardData.leaderboardUsers.map<Widget>((LeaderboardUserData user) {
                        return LeaderboardItemWidget(
                          user: user,
                          onTap: () {
                            Navigator.push<void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext dialogContext) {
                                  return PlayerProfilePage(player: user);
                                },
                              ),
                            );
                          },
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
}

/// Section for displaying active challenges.
class ChallengesSection extends StatelessWidget {
  final List<ChallengeData> challenges;

  const ChallengesSection({
    super.key,
    required this.challenges,
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
            const Text(
              'Active Kabaddi Challenges',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...challenges.map<Widget>((ChallengeData c) => ChallengeProgressCard(challenge: c)).toList(),
          ],
        ),
      ),
    );
  }
}

/// Section for displaying badges earned.
class BadgesSection extends StatelessWidget {
  final List<BadgeData> badges;

  const BadgesSection({
    super.key,
    required this.badges,
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
            const Text(
              'Your Kabaddi Badges',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: badges.map<Widget>((BadgeData b) => BadgeDisplay(badge: b)).toList(),
              ),
            ),
          ],
        ),
      ), // Fixed: closing parenthesis for Padding
    );
  }
}

/// Section for displaying test history.
class TestHistorySection extends StatelessWidget {
  final List<TestResult> testResults;

  const TestHistorySection({
    super.key,
    required this.testResults,
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
            const Text(
              'Kabaddi Test History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...testResults.map<Widget>((TestResult tr) => TestHistoryEntryCard(testResult: tr)).toList(),
          ],
        ),
      ),
    );
  }
}

/// Section for displaying achievements.
class AchievementsSection extends StatelessWidget {
  final List<AchievementData> achievements;

  const AchievementsSection({
    super.key,
    required this.achievements,
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
            const Text(
              'Kabaddi Achievements',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...achievements.map<Widget>((AchievementData a) => AchievementDisplayCard(achievement: a)).toList(),
          ],
        ),
      ),
    );
  }
}

/// Section for displaying ML feedback metrics and analysis.
class MLFeedbackSection extends StatelessWidget {
  final List<MetricData> metrics;
  final List<AnalysisPointData> feedback;

  const MLFeedbackSection({
    super.key,
    required this.metrics,
    required this.feedback,
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
            const Text(
              'Performance Insights (ML Feedback)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120, // Fixed height for the metrics row
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: metrics.length,
                itemBuilder: (BuildContext context, int index) {
                  return MetricDisplayCard(metric: metrics[index]);
                },
              ),
            ),
            const SizedBox(height: 16),
            ...feedback.map<Widget>((AnalysisPointData a) => AnalysisPointCard(analysisPoint: a)).toList(),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// SCREENS
// -----------------------------------------------------------------------------

/// The main dashboard screen displaying key player statistics and activities.
class DashboardScreen extends StatelessWidget {
  final PlayerStats playerStats;
  final List<NotificationData> notifications;
  final List<ChallengeData> challenges;

  const DashboardScreen({
    super.key,
    required this.playerStats,
    required this.notifications,
    required this.challenges,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                DashboardStatCard(
                  title: 'Last Raid Score',
                  value: '${playerStats.lastScore}',
                  icon: Icons.sports_kabaddi,
                ),
                DashboardStatCard(
                  title: 'Agility Boost',
                  value: '${playerStats.improvementPercentage}%',
                  icon: Icons.speed,
                ),
                DashboardStatCard(
                  title: 'League Rank',
                  value: '${playerStats.rank}',
                  icon: Icons.leaderboard,
                ),
                DashboardStatCard(
                  title: 'Total Matches',
                  value: '${playerStats.totalTests}',
                  icon: Icons.sports_score,
                ),
              ],
            ),
          ),
          NotificationSection(notifications: notifications),
          const OpportunitiesSection(), // Now uses provider
          const LeaderboardSection(),
          ChallengesSection(challenges: challenges),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

/// Screen for displaying the leaderboard.
class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: <Widget>[
          LeaderboardSection(),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

/// Screen for displaying career and program opportunities.
class OpportunitiesScreen extends StatelessWidget {
  const OpportunitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: <Widget>[
          OpportunitiesSection(), // Now uses provider
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

/// The profile screen displaying personal details, badges, and test history.
class ProfileScreen extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String userProfilePictureUrl; // Added profile picture URL for the current user
  final int totalTestsTaken;
  final int badgesEarned;
  final int totalAchievements;
  final List<BadgeData> badges;
  final List<TestResult> testResults;
  final List<AchievementData> achievements;
  final List<MetricData> mlMetrics;
  final List<AnalysisPointData> mlFeedback;

  const ProfileScreen({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userProfilePictureUrl,
    required this.totalTestsTaken,
    required this.badgesEarned,
    required this.totalAchievements,
    required this.badges,
    required this.testResults,
    required this.achievements,
    required this.mlMetrics,
    required this.mlFeedback,
  });

  static const String _defaultProfilePictureUrl = 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.deepOrange[400], // Consistent background color
                  child: userProfilePictureUrl != _defaultProfilePictureUrl
                      ? ClipOval(
                          child: Image.network(
                            userProfilePictureUrl,
                            width: 80, // 2 * radius
                            height: 80, // 2 * radius
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                              return Text(
                                userName[0], // Fallback to first letter on error
                                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                              );
                            },
                          ),
                        )
                      : Text(
                          userName[0], // Always show first letter if placeholder
                          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(userName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    Text(userEmail, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                  ],
                ),
                // The settings button was here, moved to the main AppBar
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ProfileSummaryStat(title: 'Matches Played', value: '$totalTestsTaken'),
                ProfileSummaryStat(title: 'Badges', value: '$badgesEarned'),
                ProfileSummaryStat(title: 'Milestones', value: '$totalAchievements'),
              ],
            ),
          ),
          BadgesSection(badges: badges),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Test Score Performance',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  KabaddiTestScoreChart(testResults: testResults),
                ],
              ),
            ),
          ),
          TestHistorySection(testResults: testResults),
          AchievementsSection(achievements: achievements),
          MLFeedbackSection(metrics: mlMetrics, feedback: mlFeedback),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// MAIN APP WIDGET
// -----------------------------------------------------------------------------

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Sample Data for the UI
  static final PlayerStats _playerStats = const PlayerStats(
    lastScore: 95, // Updated to match the last test score
    improvementPercentage: 10,
    rank: 5,
    totalTests: 10, // Updated to match the number of tests in the chart
  );

  static final List<NotificationData> _notifications = <NotificationData>[
    const NotificationData(
      title: 'New Kabaddi challenge: "Raid Master"!',
      time: '20 min ago',
      icon: Icons.sports_kabaddi,
    ),
    const NotificationData(
      title: 'Your weekly Kabaddi performance review is ready.',
      time: '2 hours ago',
      icon: Icons.trending_up,
    ),
    const NotificationData(
      title: 'You earned the "Super Tackle" badge.',
      time: '5 hours ago',
      icon: Icons.shield,
    ),
    const NotificationData(
      title: 'Pro Kabaddi League tryouts approaching!',
      time: '1 day ago',
      icon: Icons.event,
    ),
    // New notifications added here:
    const NotificationData(
      title: 'Your team won the district championship!',
      time: '3 days ago',
      icon: Icons.emoji_events,
    ),
    const NotificationData(
      title: 'New training video available: "Advanced Raider Techniques".',
      time: '1 week ago',
      icon: Icons.smart_display,
    ),
    const NotificationData(
      title: 'Reminder: Kabaddi camp registration closes soon.',
      time: '2 days ago',
      icon: Icons.notifications_active,
    ),
    const NotificationData(
      title: 'Coach feedback on your last match performance is in.',
      time: '1 day ago',
      icon: Icons.feedback,
    ),
    // Additional notifications as per the prompt
    const NotificationData(
      title: 'Upcoming fitness test on Aug 15th. Prepare well!',
      time: '4 days ago',
      icon: Icons.fitness_center,
    ),
    const NotificationData(
      title: 'New article: "Mastering the Toe Touch Skill".',
      time: '1 day ago',
      icon: Icons.article,
    ),
    const NotificationData(
      title: 'Congratulations! You reached 100 successful raids.',
      time: '6 hours ago',
      icon: Icons.star,
    ),
  ];

  static final Map<String, List<OpportunityData>> _allOpportunities = <String, List<OpportunityData>>{
    'Pro Kabaddi League': <OpportunityData>[
      OpportunityData(
        title: 'PKL Team Tryouts',
        category: 'Pro Kabaddi League',
        status: 'Open',
        color: Colors.green[700]!,
      ),
      OpportunityData(
        title: 'Kabaddi Analyst Internship',
        category: 'Pro Kabaddi League',
        status: 'Applications Open',
        color: Colors.deepOrange[700]!,
      ),
    ],
    'Amateur League': <OpportunityData>[
      OpportunityData(
        title: 'Local Kabaddi Club Recruitment',
        category: 'Amateur League',
        status: 'Seeking Players',
        color: Colors.blue[700]!,
      ),
      OpportunityData(
        title: 'Community Kabaddi League Coach',
        category: 'Amateur League',
        status: 'Apply Now',
        color: Colors.teal[700]!,
      ),
    ],
    'Youth Development': <OpportunityData>[
      OpportunityData(
        title: 'Kabaddi Summer Camp',
        category: 'Youth Development',
        status: 'Registration Open',
        color: Colors.purple[700]!,
      ),
      OpportunityData(
        title: 'School Kabaddi Team Tryouts',
        category: 'Youth Development',
        status: 'Upcoming Event',
        color: Colors.red[700]!,
      ),
    ],
    // New Kabaddi Opportunities based on the prompt
    'Selections': <OpportunityData>[
      OpportunityData(
        title: 'U17 State Kabaddi Team Selections – Maharashtra',
        category: 'Selections',
        status: 'Registration Open',
        color: Colors.brown[700]!,
      ),
    ],
    'Trials': <OpportunityData>[
      OpportunityData(
        title: 'SAI Kabaddi Trials – North Zone',
        category: 'Trials',
        status: 'Open for U19',
        color: Colors.indigo[700]!,
      ),
    ],
    'Tournaments': <OpportunityData>[
      OpportunityData(
        title: 'All India Inter-University Kabaddi Championship',
        category: 'Tournaments',
        status: 'Registration Open',
        color: Colors.purple[700]!,
      ),
      OpportunityData(
        title: 'Khelo India Youth Games – Kabaddi',
        category: 'Tournaments',
        status: 'Upcoming',
        color: Colors.green[700]!,
      ),
    ],
    'Scholarships & Training': <OpportunityData>[
      OpportunityData(
        title: 'Pro Kabaddi Junior Academy Scholarship',
        category: 'Scholarships & Training',
        status: 'Trial-based',
        color: Colors.teal[700]!,
      ),
    ],
    'Camps & Workshops': <OpportunityData>[
      OpportunityData(
        title: 'National Kabaddi Skill Development Camp',
        category: 'Camps & Workshops',
        status: 'Register Now',
        color: Colors.cyan[700]!,
      ),
    ],
  };

  static final List<ChallengeData> _challenges = <ChallengeData>[
    ChallengeData(
      title: 'Raid Master',
      description: 'Score 50 raid points in 5 matches',
      currentProgress: 35,
      targetProgress: 50,
      color: Colors.deepOrange[700]!,
    ),
    ChallengeData(
      title: 'Tackle Titan',
      description: 'Execute 15 successful tackles in 7 days',
      currentProgress: 10,
      targetProgress: 15,
      color: Colors.blue[700]!,
    ),
    ChallengeData(
      title: 'Agility Guru',
      description: 'Complete 10 agility drills with 90%+ efficiency',
      currentProgress: 7,
      targetProgress: 10,
      color: Colors.amber[700]!,
    ),
  ];

  static const String _currentUserProfilePicture =
      'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg'; // Placeholder for current user

  static final List<LeaderboardUserData> _leaderboardUsers = <LeaderboardUserData>[
    const LeaderboardUserData(
        rank: 1, name: 'Ahmed Khan', score: 1500, age: 25, region: 'Pakistan', totalMatchesPlayed: 120, profilePictureUrl: 'https://i.pravatar.cc/150?img=68'),
    const LeaderboardUserData(
        rank: 2, name: 'Rahim Uddin', score: 1450, age: 20, region: 'Bangladesh', totalMatchesPlayed: 110, profilePictureUrl: 'https://i.pravatar.cc/150?img=69'),
    const LeaderboardUserData(
        rank: 3, name: 'Kim Min-jun', score: 1400, age: 16, region: 'South Korea', totalMatchesPlayed: 95, profilePictureUrl: 'https://i.pravatar.cc/150?img=70'),
    const LeaderboardUserData(
        rank: 4, name: 'Anil Yadav', score: 1350, age: 19, region: 'Andhra Pradesh', isCurrentUser: true, totalMatchesPlayed: 10, profilePictureUrl: _currentUserProfilePicture),
    const LeaderboardUserData(
        rank: 5, name: 'Kenji Tanaka', score: 200, age: 9, region: 'Japan', totalMatchesPlayed: 15, profilePictureUrl: 'https://i.pravatar.cc/150?img=71'),
    const LeaderboardUserData(
        rank: 6, name: 'Juma Hassan', score: 1290, age: 11, region: 'Kenya', totalMatchesPlayed: 40, profilePictureUrl: 'https://i.pravatar.cc/150?img=72'),
    const LeaderboardUserData(
        rank: 7, name: 'Mateo Garcia', score: 1250, age: 13, region: 'Argentina', totalMatchesPlayed: 60, profilePictureUrl: 'https://i.pravatar.cc/150?img=73'),
    const LeaderboardUserData(
        rank: 8, name: 'Liam Smith', score: 1220, age: 18, region: 'England', totalMatchesPlayed: 80, profilePictureUrl: 'https://i.pravatar.cc/150?img=74'),
    const LeaderboardUserData(
        rank: 9, name: 'Fazel Atrachali', score: 1200, age: 32, region: 'Iran', totalMatchesPlayed: 150, profilePictureUrl: 'https://i.pravatar.cc/150?img=75'),
    const LeaderboardUserData(
        rank: 10, name: 'Bilal Ali', score: 1180, age: 22, region: 'Pakistan', totalMatchesPlayed: 105, profilePictureUrl: 'https://i.pravatar.cc/150?img=76'),
    const LeaderboardUserData(
        rank: 11, name: 'Kamal Hossain', score: 1150, age: 27, region: 'Bangladesh', totalMatchesPlayed: 90, profilePictureUrl: 'https://i.pravatar.cc/150?img=77'),
    const LeaderboardUserData(
        rank: 12, name: 'Rakesh Hooda', score: 1100, age: 21, region: 'Haryana', totalMatchesPlayed: 75, profilePictureUrl: 'https://i.pravatar.cc/150?img=78'),
    const LeaderboardUserData(
        rank: 13, name: 'Lee Seo-yeon', score: 1080, age: 15, region: 'South Korea', totalMatchesPlayed: 65, profilePictureUrl: 'https://i.pravatar.cc/150?img=79'),
    const LeaderboardUserData(
        rank: 14, name: 'Akari Sato', score: 1050, age: 10, region: 'Japan', totalMatchesPlayed: 30, profilePictureUrl: 'https://i.pravatar.cc/150?img=80'),
    const LeaderboardUserData(
        rank: 15, name: 'Amina Salim', score: 1020, age: 12, region: 'Kenya', totalMatchesPlayed: 50, profilePictureUrl: 'https://i.pravatar.cc/150?img=81'),
    const LeaderboardUserData(
        rank: 16, name: 'Sofia Perez', score: 980, age: 14, region: 'Argentina', totalMatchesPlayed: 70, profilePictureUrl: 'https://i.pravatar.cc/150?img=82'),
    const LeaderboardUserData(
        rank: 17, name: 'Olivia Jones', score: 950, age: 17, region: 'England', totalMatchesPlayed: 85, profilePictureUrl: 'https://i.pravatar.cc/150?img=83'),
    const LeaderboardUserData(
        rank: 18, name: 'Rahul Yadav', score: 920, age: 19, region: 'Uttar Pradesh', totalMatchesPlayed: 90, profilePictureUrl: 'https://i.pravatar.cc/150?img=84'),
    const LeaderboardUserData(
        rank: 19, name: 'Mohith', score: 890, age: 21, region: 'Rajasthan', totalMatchesPlayed: 110, profilePictureUrl: 'https://i.pravatar.cc/150?img=85'),
    const LeaderboardUserData(
        rank: 20, name: 'Sai Ram', score: 870, age: 20, region: 'Delhi', totalMatchesPlayed: 95, profilePictureUrl: 'https://i.pravatar.cc/150?img=86'),
    const LeaderboardUserData(
        rank: 21, name: 'Siva Ganesh', score: 850, age: 26, region: 'Gujarat', totalMatchesPlayed: 125, profilePictureUrl: 'https://i.pravatar.cc/150?img=87'),
    const LeaderboardUserData(
        rank: 22, name: 'Vijay Singh', score: 830, age: 29, region: 'Haryana', totalMatchesPlayed: 130, profilePictureUrl: 'https://i.pravatar.cc/150?img=88'),
    // New users added to demonstrate region level filtering
    const LeaderboardUserData(
        rank: 23, name: 'Global Champion', score: 2000, age: 30, region: 'Global', totalMatchesPlayed: 200, profilePictureUrl: 'https://i.pravatar.cc/150?img=89'),
    const LeaderboardUserData(
        rank: 24, name: 'Bharat Singh', score: 1800, age: 28, region: 'India', totalMatchesPlayed: 180, profilePictureUrl: 'https://i.pravatar.cc/150?img=90'),
    const LeaderboardUserData(
        rank: 25, name: 'Deepak Malik', score: 1100, age: 16, region: 'Gurugram', totalMatchesPlayed: 70, profilePictureUrl: 'https://i.pravatar.cc/150?img=91'),
    const LeaderboardUserData(
        rank: 26, name: 'Naveen Kumar', score: 1050, age: 10, region: 'Sohna', totalMatchesPlayed: 25, profilePictureUrl: 'https://i.pravatar.cc/150?img=92'),
    const LeaderboardUserData(
        rank: 27, name: 'Ajit Rana', score: 900, age: 18, region: 'Damdama', totalMatchesPlayed: 60, profilePictureUrl: 'https://i.pravatar.cc/150?img=93'),
    const LeaderboardUserData(
        rank: 28, name: 'Gopal Das', score: 1120, age: 25, region: 'India', totalMatchesPlayed: 100, profilePictureUrl: 'https://i.pravatar.cc/150?img=94'),

    // Added players to ensure at least 5 members per age group
    // u10
    const LeaderboardUserData(
        rank: 29, name: 'Aryan Singh', score: 180, age: 9, region: 'Haryana', totalMatchesPlayed: 10, profilePictureUrl: 'https://i.pravatar.cc/150?img=95'),
    const LeaderboardUserData(
        rank: 30, name: 'Junior Champ 1', score: 170, age: 8, region: 'Punjab', totalMatchesPlayed: 8, profilePictureUrl: 'https://i.pravatar.cc/150?img=96'),
    // u12
    const LeaderboardUserData(
        rank: 31, name: 'Priya Sharma', score: 250, age: 11, region: 'Delhi', totalMatchesPlayed: 18, profilePictureUrl: 'https://i.pravatar.cc/150?img=97'),
    const LeaderboardUserData(
        rank: 32, name: 'Harsh Vardhan', score: 260, age: 12, region: 'Rajasthan', totalMatchesPlayed: 22, profilePictureUrl: 'https://i.pravatar.cc/150?img=98'),
    const LeaderboardUserData(
        rank: 33, name: 'Shreya Gupta', score: 240, age: 11, region: 'Uttar Pradesh', totalMatchesPlayed: 15, profilePictureUrl: 'https://i.pravatar.cc/150?img=99'),
    // u14
    const LeaderboardUserData(
        rank: 34, name: 'Aditya Kulkarni', score: 350, age: 13, region: 'Maharashtra', totalMatchesPlayed: 30, profilePictureUrl: 'https://i.pravatar.cc/150?img=100'),
    const LeaderboardUserData(
        rank: 35, name: 'Suresh Kumar', score: 360, age: 14, region: 'Tamil Nadu', totalMatchesPlayed: 35, profilePictureUrl: 'https://i.pravatar.cc/150?img=1'),
    const LeaderboardUserData(
        rank: 36, name: 'Kiran Solanki', score: 340, age: 13, region: 'Gujarat', totalMatchesPlayed: 28, profilePictureUrl: 'https://i.pravatar.cc/150?img=2'),
    // u17
    const LeaderboardUserData(
        rank: 37, name: 'Anuj Rana', score: 450, age: 15, region: 'Himachal Pradesh', totalMatchesPlayed: 40, profilePictureUrl: 'https://i.pravatar.cc/150?img=3'),
    // u19
    const LeaderboardUserData(
        rank: 38, name: 'Kiran Babu', score: 550, age: 17, region: 'Andhra Pradesh', totalMatchesPlayed: 50, profilePictureUrl: 'https://i.pravatar.cc/150?img=4'),
    // u21
    const LeaderboardUserData(
        rank: 39, name: 'Sakshi Rawat', score: 650, age: 19, region: 'Delhi', totalMatchesPlayed: 60, profilePictureUrl: 'https://i.pravatar.cc/150?img=5'),
    const LeaderboardUserData(
        rank: 40, name: 'Gopal Verma', score: 640, age: 20, region: 'Punjab', totalMatchesPlayed: 55, profilePictureUrl: 'https://i.pravatar.cc/150?img=6'),
  ];

  static final List<BadgeData> _badges = <BadgeData>[
    const BadgeData(title: 'Agility Ace', icon: Icons.fast_forward, color: Colors.amber),
    const BadgeData(title: 'Dodger', icon: Icons.run_circle, color: Colors.lightGreen),
    const BadgeData(title: 'Defender', icon: Icons.security, color: Colors.blueGrey),
    const BadgeData(title: 'Captain', icon: Icons.military_tech, color: Colors.purple),
    const BadgeData(title: 'Raid King', icon: Icons.sports_kabaddi, color: Colors.deepOrange),
  ];

  static final List<TestResult> _testResults = <TestResult>[
    const TestResult(
      testType: 'Agility Test',
      score: 65,
      date: '2024-08-01',
      trendIcon: Icons.horizontal_rule, // First test, no previous trend
      trendColor: Colors.grey,
    ),
    const TestResult(
      testType: 'Raid Skill',
      score: 72,
      date: '2024-08-08',
      trendIcon: Icons.arrow_upward,
      trendColor: Colors.green,
    ),
    const TestResult(
      testType: 'Tackle Technique',
      score: 80,
      date: '2024-08-15',
      trendIcon: Icons.arrow_upward,
      trendColor: Colors.green,
    ),
    const TestResult(
      testType: 'Endurance Drill',
      score: 78,
      date: '2024-08-22',
      trendIcon: Icons.arrow_downward,
      trendColor: Colors.red,
    ),
    const TestResult(
      testType: 'Match Simulation',
      score: 85,
      date: '2024-08-29',
      trendIcon: Icons.arrow_upward,
      trendColor: Colors.green,
    ),
    const TestResult(
      testType: 'Footwork Speed',
      score: 88,
      date: '2024-09-05',
      trendIcon: Icons.arrow_upward,
      trendColor: Colors.green,
    ),
    const TestResult(
      testType: 'Strength Test',
      score: 90,
      date: '2024-09-12',
      trendIcon: Icons.arrow_upward,
      trendColor: Colors.green,
    ),
    const TestResult(
      testType: 'Breathing Control',
      score: 87,
      date: '2024-09-19',
      trendIcon: Icons.arrow_downward,
      trendColor: Colors.red,
    ),
    const TestResult(
      testType: 'Strategic Raiding',
      score: 92,
      date: '2024-09-26',
      trendIcon: Icons.arrow_upward,
      trendColor: Colors.green,
    ),
    const TestResult(
      testType: 'Team Coordination',
      score: 95,
      date: '2024-10-03',
      trendIcon: Icons.arrow_upward,
      trendColor: Colors.green,
    ),
  ];

  static final List<AchievementData> _achievements = <AchievementData>[
    AchievementData(
      title: 'First Match Won',
      description: 'You\'ve secured your first victory in Kabaddi!',
      icon: Icons.emoji_events,
      color: Colors.amber[700]!,
    ),
    AchievementData(
      title: 'Top Raider Status',
      description: 'Achieved a top raider position in a local Kabaddi tournament.',
      icon: Icons.stars,
      color: Colors.deepOrange[700]!,
    ),
    AchievementData(
      title: 'Defensive Wall',
      description: 'Successfully performed 10 consecutive tackles without error.',
      icon: Icons.shield_moon,
      color: Colors.blue[700]!,
    ),
  ];

  static final List<MetricData> _mlMetrics = <MetricData>[
    MetricData(
      title: 'Raid Success',
      value: '75%',
      color: Colors.green[700]!,
      icon: Icons.check_circle_outline,
    ),
    MetricData(
      title: 'Tackle Efficacy',
      value: '60%',
      color: Colors.blue[700]!,
      icon: Icons.shield_outlined,
    ),
    MetricData(
      title: 'Avg. Raid Time',
      value: '25s',
      color: Colors.amber[700]!,
      icon: Icons.timer,
    ),
    MetricData(
      title: 'Footwork Score',
      value: '8.2',
      color: Colors.deepPurple[700]!,
      icon: Icons.directions_run,
    ),
  ];

  static final List<AnalysisPointData> _mlFeedback = <AnalysisPointData>[
    AnalysisPointData(
      title: 'Strength: Quick Hand Touches',
      content: 'Your quick hand touches on opponent defenders are highly effective, leading to successful raid points.',
      color: Colors.green[700]!,
    ),
    AnalysisPointData(
      title: 'Improvement: Ankle Holds',
      content:
          'Focus on improving the grip and timing of ankle holds during defensive plays to increase tackle success rate.',
      color: Colors.red[700]!,
    ),
    AnalysisPointData(
      title: 'Strength: Baulk Line Crossing',
      content: 'Consistent and timely baulk line crossing demonstrates excellent awareness and game sense.',
      color: Colors.green[700]!,
    ),
    AnalysisPointData(
      title: 'Improvement: Bonus Point Attempts',
      content: 'Increase attempts for bonus points when the opportunity arises, especially in critical situations.',
      color: Colors.orange[700]!,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<LeaderboardData>(
          create: (BuildContext context) => LeaderboardData(initialUsers: _leaderboardUsers),
        ),
        ChangeNotifierProvider<OpportunitiesData>(
          create: (BuildContext context) => OpportunitiesData(initialOpportunities: _allOpportunities),
        ),
      ],
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          title: 'Kabaddi Compass',
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          debugShowCheckedModeBanner: false,
          home: _MainScreen(
            playerStats: _playerStats,
            notifications: _notifications,
            challenges: _challenges,
            badges: _badges,
            testResults: _testResults,
            achievements: _achievements,
            mlMetrics: _mlMetrics,
            mlFeedback: _mlFeedback,
            currentUserProfilePicture: _currentUserProfilePicture, // Pass to MainScreen
          ),
        );
      },
    );
  }
}

class _MainScreen extends StatefulWidget {
  final PlayerStats playerStats;
  final List<NotificationData> notifications;
  final List<ChallengeData> challenges;
  final List<BadgeData> badges;
  final List<TestResult> testResults;
  final List<AchievementData> achievements;
  final List<MetricData> mlMetrics;
  final List<AnalysisPointData> mlFeedback;
  final String currentUserProfilePicture;

  const _MainScreen({
    required this.playerStats,
    required this.notifications,
    required this.challenges,
    required this.badges,
    required this.testResults,
    required this.achievements,
    required this.mlMetrics,
    required this.mlFeedback,
    required this.currentUserProfilePicture,
  });

  @override
  State<_MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<_MainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _lastTabIndex = 0; // Keep track of the last selected tab index to trigger rebuild

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    // Only update UI if the tab selection has settled on a new index
    if (!_tabController.indexIsChanging && _tabController.index != _lastTabIndex) {
      setState(() {
        _lastTabIndex = _tabController.index;
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kabaddi Compass'),
        actions: <Widget>[
          // Swapped positions: Notification icon first, then Menu icon
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // No-op for now as specific functionality is not defined in prompt
            },
            tooltip: 'Notifications',
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // No-op for now as specific functionality is not defined in prompt
            },
            tooltip: 'Menu',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(icon: Icon(Icons.dashboard), text: 'Dashboard'),
            Tab(icon: Icon(Icons.leaderboard), text: 'Leaderboard'),
            Tab(icon: Icon(Icons.work), text: 'Opportunities'),
            Tab(icon: Icon(Icons.person), text: 'Profile'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          DashboardScreen(
            playerStats: widget.playerStats,
            notifications: widget.notifications,
            challenges: widget.challenges,
          ),
          const LeaderboardScreen(),
          const OpportunitiesScreen(),
          ProfileScreen(
            userName: 'Anil Yadav', // Updated user name
            userEmail: 'anilyadav@gmail.com', // Generic email for current user
            userProfilePictureUrl: widget.currentUserProfilePicture, // Pass current user's profile picture
            totalTestsTaken: widget.playerStats.totalTests,
            badgesEarned: widget.badges.length,
            totalAchievements: widget.achievements.length,
            badges: widget.badges,
            testResults: widget.testResults,
            mlMetrics: widget.mlMetrics,
            mlFeedback: widget.mlFeedback,
            achievements: widget.achievements, // Ensure all required fields are passed
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Camera functionality requires an external package (e.g., `camera`) not available.'),
              duration: Duration(seconds: 3),
            ),
          );
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.videocam, color: Colors.white),
      ),
    );
  }
}+
