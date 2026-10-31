
// Core game constants
class AppConstants {
  AppConstants._();

  // App identity
  static const String appName = 'Arrow Escape';
  static const String packageId = 'com.arrowx.escape';

  // Grid sizes: 10×10 minimum at level 1, up to 35×35 target (hard cap 40).
  // Normal: 10×10 at level 4 → 35×35 around level 300+
  // Boss:   20×20 at first boss → 30×30 at high cycles
  // God:    22×22 at first god  → 35×35 at high cycles
  static const int startingGridSize = 10;
  static const int maxGridSize = 40;
  static const int tutorialLevels = 3;

  // Lives
  static const int maxLives = 3;

  // Special level cadence
  static const int bossLevelEvery = 3;
  static const int godLevelEvery = 5;

  // Ads (disabled for local testing)
  static const String admobAppIdAndroid = '';
  static const String admobBannerUnitId = '';
  static const String admobInterstitialUnitId = '';
  static const String admobRewardedUnitId = '';

  static const String unityGameId = 'YOUR_UNITY_GAME_ID';
  static const String unityBannerAdId = 'Banner_Android';
  static const String unityInterstitialAdId = 'Interstitial_Android';
  static const String unityRewardedAdId = 'Rewarded_Android';
  static const bool unityTestMode = true;

  // Ad Network Feature Toggles
  static const bool enableAdMob = false;
  static const bool enableUnityAds = false;
  static const bool enableAppLovin = false;

  static const int interstitialEveryNLevels = 4;

  // Animation durations
  static const Duration arrowSlideDuration = Duration(milliseconds: 220);
  static const Duration arrowExitDuration = Duration(milliseconds: 400);
  static const Duration arrowShakeDuration = Duration(milliseconds: 400);
  static const Duration levelCompleteDuration = Duration(milliseconds: 200);

  // Scoring
  static const int baseScore = 100;
  static const int bonusPerRemainingLife = 50;
  static const int bossBonus = 200;
  static const int godBonus = 500;

  // Streak milestones
  static const int streakMilestone1 = 7;
  static const int streakMilestone2 = 30;
  static const int streakMilestone3 = 100;

  /// How many boss levels have occurred up to and including [level].
  static int bossCycleCount(int level) {
    if (level <= tutorialLevels) return 0;
    int count = 0;
    for (int l = tutorialLevels + 1; l <= level; l++) {
      if (levelTypeFor(l) == LevelType.boss) count++;
    }
    return count;
  }

  /// How many god levels have occurred up to and including [level].
  static int godCycleCount(int level) {
    if (level <= tutorialLevels) return 0;
    int count = 0;
    for (int l = tutorialLevels + 1; l <= level; l++) {
      if (levelTypeFor(l) == LevelType.god) count++;
    }
    return count;
  }

  /// Grid size for a given level number.
  static int gridSizeForLevel(int level) {
    if (level <= tutorialLevels) return 10;

    final type = levelTypeFor(level);

    if (type == LevelType.boss) {
      final cycle = bossCycleCount(level);
      final raw = 27 + ((cycle - 1) * (13.0 / 19.0)).round();
      return raw.clamp(27, 40);
    }

    if (type == LevelType.god) {
      final cycle = godCycleCount(level);
      final raw = 27 + ((cycle - 1) * (13.0 / 19.0)).round();
      return raw.clamp(27, 40);
    }

    // Normal levels
    if (level < 20) {
      final raw = 15 + ((level - 4) * (9.0 / 15.0)).round();
      return raw.clamp(15, 24);
    } else {
      final raw = 25 + ((level - 20) * (10.0 / 480.0)).round();
      return raw.clamp(25, 35);
    }
  }

  /// Returns the level type: tutorial, god, boss, or normal.
  static LevelType levelTypeFor(int level) {
    if (level <= tutorialLevels) return LevelType.tutorial;

    final pos = ((level - tutorialLevels - 1) % 7) + 1;

    if (pos == 7) return LevelType.god;
    if (pos == 4) return LevelType.boss;

    return LevelType.normal;
  }

  /// True when n is a boss level.
  static bool isBossLevel(int n) => levelTypeFor(n) == LevelType.boss;

  /// True for god levels.
  static bool isGodLevel(int n) => levelTypeFor(n) == LevelType.god;

  /// Canvas scale factor.
  static double canvasScaleForType(LevelType type) {
    switch (type) {
      case LevelType.god:
        return 0.97;
      case LevelType.boss:
        return 0.97;
      default:
        return 1.2;
    }
  }
}

enum LevelType {
  tutorial,
  normal,
  boss,
  god;

  String get label {
    switch (this) {
      case LevelType.tutorial:
        return 'Tutorial';
      case LevelType.normal:
        return '';
      case LevelType.boss:
        return 'Boss';
      case LevelType.god:
        return 'God';
    }
  }

  bool get isSpecial => this == LevelType.boss || this == LevelType.god;
}
