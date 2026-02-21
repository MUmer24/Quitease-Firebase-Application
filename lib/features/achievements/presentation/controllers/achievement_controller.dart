import 'package:get/get.dart';
import 'package:quitease/features/dashboard/data/app_data_controller.dart';
import 'package:quitease/shared/models/achievement_model.dart';
import 'package:quitease/shared/services/storage/data_persistence_service.dart';
import 'package:quitease/shared/services/notification/notification_scheduler.dart';

class AchievementController extends GetxController {
  static AchievementController get instance => Get.find();

  // Dependencies - Updated to use centralized services
  final AppDataController _appDataController = Get.find();
  final DataPersistenceService _dataPersistenceService = Get.find();
  NotificationScheduler? _notificationScheduler;

  // Reactive variables
  final achievements = <Achievement>[].obs;
  final completedAchievements = 0.obs;
  final totalAchievements = 0.obs;
  final dashboardAchievements = <Achievement>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize notification scheduler (lazy load to avoid circular dependency)
    try {
      _notificationScheduler = Get.find<NotificationScheduler>();
    } catch (e) {
      // NotificationScheduler might not be registered yet, skip
    }

    _initializeAchievements();
    ever(
      _appDataController.totalCigarettesSkipped,
      (_) => _updateAchievements(),
    );
  }

  void _initializeAchievements() {
    achievements.assignAll([
      Achievement(
        isCompleted: false,
        coloredImage: 'assets/imgs/achievements_imgs/1.png',
        grayscaleImage: 'assets/imgs/achievements_imgs/1-Grayscale.png',
        title: 'Puff Passer',
        subtitle: 'Skipped 1 cigarette',
        description:
            'You skipped your very first cigarette—small step, big win.',
        requiredValue: 1,
        isDaysBased: false, // This achievement is based on cigarettes skipped
      ),
      Achievement(
        isCompleted: false,
        coloredImage: 'assets/imgs/achievements_imgs/2.png',
        grayscaleImage: 'assets/imgs/achievements_imgs/2-Grayscale.png',
        title: 'Ash-Free Apprentice',
        subtitle: 'Skipped 10 cigarette',
        description:
            'You\'ve turned down 10 smokes. Discipline is growing, one choice at a time.',
        requiredValue: 10,
        isDaysBased: false,
      ),
      Achievement(
        isCompleted: false,
        coloredImage: 'assets/imgs/achievements_imgs/3.png',
        grayscaleImage: 'assets/imgs/achievements_imgs/3-Grayscale.png',
        title: 'Craving Crusher',
        subtitle: 'Skipped 25 cigarette',
        description: 'You\'re learning to ride the waves of temptation.',
        requiredValue: 25,
        isDaysBased: false,
      ),
      Achievement(
        isCompleted: false,
        coloredImage: 'assets/imgs/achievements_imgs/4.png',
        grayscaleImage: 'assets/imgs/achievements_imgs/4-Grayscale.png',
        title: 'Butt Breaker',
        subtitle: 'Skipped 50 cigarette',
        description: 'You\'re breaking habits and building strength.',
        requiredValue: 50,
        isDaysBased: false,
      ),
      Achievement(
        isCompleted: false,
        coloredImage: 'assets/imgs/achievements_imgs/5.png',
        grayscaleImage: 'assets/imgs/achievements_imgs/5-Grayscale.png',
        title: 'Nicotine Ninja',
        subtitle: 'Skipped 100 cigarette',
        description:
            'Dodged 100 cigarette opportunities. Stealth and strength!',
        requiredValue: 100,
        isDaysBased: false,
      ),
      Achievement(
        isCompleted: false,
        coloredImage: 'assets/imgs/achievements_imgs/6.png',
        grayscaleImage: 'assets/imgs/achievements_imgs/6-Grayscale.png',
        title: 'Smoke-Free Streaker',
        subtitle: 'Skipped 250 cigarette',
        description: '250 avoided! That\'s serious smoke you didn\'t inhale.',
        requiredValue: 250,
        isDaysBased: false,
      ),
      Achievement(
        isCompleted: false,
        coloredImage: 'assets/imgs/achievements_imgs/7.png',
        grayscaleImage: 'assets/imgs/achievements_imgs/7-Grayscale.png',
        title: 'Habit Hacker',
        subtitle: 'Skipped 500 cigarette',
        description: '500 missed smokes? You\'re reprogramming your life.',
        requiredValue: 500,
        isDaysBased: false,
      ),
      Achievement(
        isCompleted: false,
        coloredImage: 'assets/imgs/achievements_imgs/8.png',
        grayscaleImage: 'assets/imgs/achievements_imgs/8-Grayscale.png',
        title: 'Freedom Fighter',
        subtitle: 'Skipped 1K cigarette',
        description:
            'You\'ve sidestepped 1,000 smokes. You\'re fighting for your freedom—and winning.',
        requiredValue: 1000,
        isDaysBased: false,
      ),
      Achievement(
        isCompleted: false,
        coloredImage: 'assets/imgs/achievements_imgs/9.png',
        grayscaleImage: 'assets/imgs/achievements_imgs/9-Grayscale.png',
        title: 'Oxygen Overload',
        subtitle: 'Skipped 2500 cigarette',
        description: '2,500 skipped! Your lungs are loving every breath.',
        requiredValue: 2500,
        isDaysBased: false,
      ),
      Achievement(
        isCompleted: false,
        coloredImage: 'assets/imgs/achievements_imgs/10.png',
        grayscaleImage: 'assets/imgs/achievements_imgs/10-Grayscale.png',
        title: 'Breathe Boss',
        subtitle: 'Skipped 5K cigarette',
        description:
            '5,000 cigarettes skipped. Your air is cleaner, and so is your future.',
        requiredValue: 5000,
        isDaysBased: false,
      ),
      Achievement(
        isCompleted: false,
        coloredImage: 'assets/imgs/achievements_imgs/11.png',
        grayscaleImage: 'assets/imgs/achievements_imgs/11-Grayscale.png',
        title: 'One Day Warrior',
        subtitle: 'First day without smoking',
        description:
            'You made it through the first day. Every journey begins with one bold step.',
        requiredValue: 1,
        isDaysBased: true,
      ),
      Achievement(
        isCompleted: false,
        coloredImage: 'assets/imgs/achievements_imgs/12.png',
        grayscaleImage: 'assets/imgs/achievements_imgs/12-Grayscale.png',
        title: 'Smoke-Free Starter',
        subtitle: '3 days without smoking',
        description:
            'Three days strong! Cravings are fading, and your body is already healing.',
        requiredValue: 3,
        isDaysBased: true,
      ),
      Achievement(
        isCompleted: false,
        coloredImage: 'assets/imgs/achievements_imgs/13.png',
        grayscaleImage: 'assets/imgs/achievements_imgs/13-Grayscale.png',
        title: 'Week One Wonder',
        subtitle: '7 consecutive days',
        description:
            '7 days clean! Your breath is fresher and energy\'s on the rise.',
        requiredValue: 7,
        isDaysBased: true,
      ),
      Achievement(
        isCompleted: false,
        coloredImage: 'assets/imgs/achievements_imgs/14.png',
        grayscaleImage: 'assets/imgs/achievements_imgs/14-Grayscale.png',
        title: 'Lung Liberator',
        subtitle: '14 consecutive days',
        description: 'Two weeks down, and your lungs are already thanking you.',
        requiredValue: 14,
        isDaysBased: true,
      ),
      Achievement(
        isCompleted: false,
        coloredImage: 'assets/imgs/achievements_imgs/15.png',
        grayscaleImage: 'assets/imgs/achievements_imgs/15-Grayscale.png',
        title: 'Smoke-Free Sentinel',
        subtitle: '30 consecutive days',
        description:
            'One month clean—your body is transforming, and so is your mindset.',
        requiredValue: 30,
        isDaysBased: true,
      ),
      Achievement(
        isCompleted: false,
        coloredImage: 'assets/imgs/achievements_imgs/16.png',
        grayscaleImage: 'assets/imgs/achievements_imgs/16-Grayscale.png',
        title: 'Trigger Tamer',
        subtitle: '2 consecutive months',
        description:
            '60 days strong. You\'ve mastered the art of staying cool when cravings strike.',
        requiredValue: 60,
        isDaysBased: true,
      ),
      Achievement(
        isCompleted: false,
        coloredImage: 'assets/imgs/achievements_imgs/17.png',
        grayscaleImage: 'assets/imgs/achievements_imgs/17-Grayscale.png',
        title: 'Craving Commander',
        subtitle: '3 consecutive months',
        description:
            '90 days smoke-free. You\'re taking full control of your story.',
        requiredValue: 90,
        isDaysBased: true,
      ),
      Achievement(
        isCompleted: false,
        coloredImage: 'assets/imgs/achievements_imgs/18.png',
        grayscaleImage: 'assets/imgs/achievements_imgs/18-Grayscale.png',
        title: 'Habit Hero',
        subtitle: '6 consecutive months',
        description:
            'Six months! Your risk of relapse drops, and your confidence soars.',
        requiredValue: 180,
        isDaysBased: true,
      ),
      Achievement(
        isCompleted: false,
        coloredImage: 'assets/imgs/achievements_imgs/19.png',
        grayscaleImage: 'assets/imgs/achievements_imgs/19-Grayscale.png',
        title: 'Year of You',
        subtitle: 'A Year of Progress',
        description:
            '365 days without a single puff. A whole year of progress and power!',
        requiredValue: 365,
        isDaysBased: true,
      ),
      Achievement(
        isCompleted: false,
        coloredImage: 'assets/imgs/achievements_imgs/20.png',
        grayscaleImage: 'assets/imgs/achievements_imgs/20-Grayscale.png',
        title: 'Lifetime Legend',
        subtitle: '2 Years Smoke-Free',
        description:
            'You\'ve gone 2 years smoke-free. You didn\'t just quit—you rewrote your future.',
        requiredValue: 730, // 2 years in days
        isDaysBased: true,
      ),
    ]);

    totalAchievements.value = achievements.length;
    _updateAchievements();
  }

  /// Calculates the total days since the user quit smoking
  int get totalDaysSmokeFree {
    final quitDate = _dataPersistenceService.quitDate.value;
    if (quitDate == null) return 0;

    final now = DateTime.now();
    return now.difference(quitDate).inDays;
  }

  /// Sorts achievements with completed ones first, then by required value
  void _sortAchievements() {
    achievements.sort((a, b) {
      // First sort by completion status (completed first)
      if (a.isCompleted && !b.isCompleted) return -1;
      if (!a.isCompleted && b.isCompleted) return 1;

      // Then sort by required value (ascending)
      return a.requiredValue.compareTo(b.requiredValue);
    });
  }

  void _updateAchievements() {
    final cigarettesSkipped = _appDataController.totalCigarettesSkipped.value;
    int completedCount = 0;
    final daysSmokeFree = totalDaysSmokeFree;

    for (var achievement in achievements) {
      bool wasCompleted = achievement.isCompleted;

      if (achievement.isDaysBased) {
        if (daysSmokeFree >= achievement.requiredValue) {
          achievement.isCompleted = true;
          completedCount++;

          // Trigger notification if newly completed
          if (!wasCompleted && achievement.isCompleted) {
            _triggerAchievementNotification(achievement);
          }
        }
      } else {
        if (cigarettesSkipped >= achievement.requiredValue) {
          achievement.isCompleted = true;
          completedCount++;

          // Trigger notification if newly completed
          if (!wasCompleted && achievement.isCompleted) {
            _triggerAchievementNotification(achievement);
          }
        }
      }
    }

    completedAchievements.value = completedCount;
    _sortAchievements();
    update();

    // Update dashboard achievements (first 5 completed)
    final completedList = achievements
        .where((achievement) => achievement.isCompleted)
        .take(5)
        .toList();
    dashboardAchievements.assignAll(completedList);
  }

  /// Trigger notification when achievement is completed
  void _triggerAchievementNotification(Achievement achievement) {
    try {
      _notificationScheduler?.showMilestoneNotification(
        title: '🏆 ${achievement.title}',
        body: achievement.description,
      );
    } catch (e) {
      // Fail silently if notification service unavailable
    }
  }
}
