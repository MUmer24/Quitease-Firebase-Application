/// Notification template data and configuration
class NotificationConfig {
  /// Notification IDs - must be unique
  static const int motivationalBaseId = 1000;
  static const int milestoneBaseId = 2000;
  static const int healthBaseId = 3000;
  static const int dailyCheckInBaseId = 4000;
  static const int cravingTipBaseId = 5000;

  /// Motivational messages (15 variations)
  static const List<String> motivationalMessages = [
    'Every smoke-free moment is a victory! Keep going 💪',
    'You\'re stronger than any craving. Believe it!',
    'Your lungs are thanking you right now 🌬️',
    'One day at a time. You\'ve got this!',
    'Remember why you started. Stay strong!',
    'Your future self will thank you for today\'s choice',
    'Cravings pass. Your strength doesn\'t. 💪',
    'You\'re not giving up anything. You\'re gaining freedom!',
    'Every breath is easier. Every day is healthier.',
    'Proud of you! Keep pushing forward 🌟',
    'Your willpower is incredible. Don\'t stop now!',
    'Think of how far you\'ve come. Amazing! 🎯',
    'You\'re breaking free, one moment at a time',
    'Your body is healing. Your mind is stronger.',
    'Champions are made in moments like these! 🏆',
  ];

  /// Craving management tips (10 tips)
  static const List<String> cravingTips = [
    'Craving hitting? Try the 5-4-3-2-1 grounding technique 🧘',
    'Feeling tempted? Take 10 deep breaths right now',
    'Drink a glass of water. Cravings often pass in 3-5 minutes',
    'Call a friend or text someone supportive right now',
    'Go for a quick 5-minute walk. Movement helps!',
    'Chew gum or have a healthy snack instead',
    'Remember: Cravings are temporary. You are permanent.',
    'Visualize your success. See yourself smoke-free and healthy',
    'Do 20 jumping jacks. Get those endorphins flowing!',
    'Listen to your favorite song. Distract and conquer! 🎵',
  ];

  /// Daily check-in prompts
  static const List<String> dailyCheckIns = [
    'Good morning! How are you feeling today? 🌅',
    'Time to log your progress! You\'re doing great 📊',
    'Evening check-in: How was your day? 🌙',
    'Quick check-in: Any cravings today?',
    'Time to celebrate today\'s wins! 🎉',
  ];

  /// Health milestone messages based on quit duration
  static Map<String, String> getHealthMilestone(int hours) {
    if (hours >= 175200) {
      // 20 years
      return {
        'title': '20 Years Smoke-Free! 🏆',
        'body':
            'Your risk of disease is now the same as a non-smoker. Incredible achievement!',
      };
    } else if (hours >= 87600) {
      // 10 years
      return {
        'title': '10 Years Smoke-Free! 🎊',
        'body': 'Your risk of lung cancer has dropped by 50%. Outstanding!',
      };
    } else if (hours >= 43800) {
      // 5 years
      return {
        'title': '5 Years Smoke-Free! 🌟',
        'body':
            'Stroke risk reduced to that of a non-smoker. Remarkable progress!',
      };
    } else if (hours >= 8760) {
      // 1 year
      return {
        'title': '1 Year Smoke-Free! 🎉',
        'body': 'Heart disease risk cut in half! You\'re a champion!',
      };
    } else if (hours >= 2160) {
      // 3 months
      return {
        'title': '3 Months Smoke-Free! 💪',
        'body':
            'Lung function improving significantly. Circulation much better!',
      };
    } else if (hours >= 720) {
      // 1 month
      return {
        'title': '1 Month Smoke-Free! 🎯',
        'body': 'Coughing and shortness of breath decreasing. Keep it up!',
      };
    } else if (hours >= 336) {
      // 2 weeks
      return {
        'title': '2 Weeks Smoke-Free! 🌱',
        'body': 'Circulation improving. Walking easier. You\'re healing!',
      };
    } else if (hours >= 168) {
      // 1 week
      return {
        'title': '1 Week Smoke-Free! 🎊',
        'body': 'Taste and smell returning! Food tastes better!',
      };
    } else if (hours >= 72) {
      // 3 days
      return {
        'title': '3 Days Smoke-Free! 💚',
        'body': 'Nicotine completely out! Breathing easier now!',
      };
    } else if (hours >= 24) {
      // 1 day
      return {
        'title': '24 Hours Smoke-Free! 🌟',
        'body': 'Heart attack risk already decreasing! Amazing start!',
      };
    } else if (hours >= 12) {
      // 12 hours
      return {
        'title': '12 Hours Smoke-Free! 🎯',
        'body': 'Carbon monoxide levels normalizing. Blood oxygen improving!',
      };
    } else if (hours >= 2) {
      // 2 hours
      return {
        'title': '2 Hours Smoke-Free! 💪',
        'body': 'Heart rate and blood pressure dropping to normal. Great job!',
      };
    } else if (hours >= 1) {
      // 1 hour
      return {
        'title': '1 Hour Smoke-Free! 🌱',
        'body': 'Your body is already starting to heal. Keep going!',
      };
    } else {
      return {
        'title': 'Starting Your Journey! 🚀',
        'body': 'Every second counts. You\'ve made the best decision!',
      };
    }
  }

  /// Generate milestone notification for cigarettes avoided
  static Map<String, String> getCigaretteMilestone(int cigarettes) {
    if (cigarettes >= 10000) {
      return {
        'title': '🏆 10,000 Cigarettes Avoided!',
        'body': 'You are a legend! This is extraordinary!',
      };
    } else if (cigarettes >= 5000) {
      return {
        'title': '🎉 5,000 Cigarettes Skipped!',
        'body': 'Your lungs are celebrating every breath!',
      };
    } else if (cigarettes >= 2500) {
      return {
        'title': '🌟 2,500 Cigarettes Avoided!',
        'body': 'Your dedication is inspiring!',
      };
    } else if (cigarettes >= 1000) {
      return {
        'title': '💪 1,000 Cigarettes Skipped!',
        'body': 'You\'re unstoppable! Keep this momentum!',
      };
    } else if (cigarettes >= 500) {
      return {
        'title': '🎯 500 Cigarettes Avoided!',
        'body': 'Half a thousand! You\'re crushing it!',
      };
    } else if (cigarettes >= 250) {
      return {
        'title': '🔥 250 Cigarettes Skipped!',
        'body': 'Your willpower is incredible!',
      };
    } else if (cigarettes >= 100) {
      return {
        'title': '🚀 100 Cigarettes Avoided!',
        'body': 'Triple digits! You\'re doing amazing!',
      };
    } else if (cigarettes >= 50) {
      return {
        'title': '🌱 50 Cigarettes Skipped!',
        'body': 'Halfway to 100! Keep going strong!',
      };
    } else if (cigarettes >= 25) {
      return {
        'title': '⭐ 25 Cigarettes Avoided!',
        'body': 'Quarter century! Fantastic progress!',
      };
    } else if (cigarettes >= 10) {
      return {
        'title': '💚 10 Cigarettes Skipped!',
        'body': 'Double digits! You\'re building momentum!',
      };
    } else {
      return {
        'title': '🎊 First Cigarettes Avoided!',
        'body': 'Every single one counts! Proud of you!',
      };
    }
  }

  /// Generate milestone notification for money saved
  static Map<String, String> getMoneySavedMilestone(double amount) {
    if (amount >= 10000) {
      return {
        'title': '💰 \$${amount.toStringAsFixed(0)} Saved!',
        'body': 'Life-changing money! Imagine what you can do with this!',
      };
    } else if (amount >= 5000) {
      return {
        'title': '💵 \$${amount.toStringAsFixed(0)} Saved!',
        'body': 'That\'s a vacation! A car down payment! Incredible!',
      };
    } else if (amount >= 1000) {
      return {
        'title': '🎉 \$${amount.toStringAsFixed(0)} Saved!',
        'body': '4 figures! Think of what you can buy instead!',
      };
    } else if (amount >= 500) {
      return {
        'title': '💸 \$${amount.toStringAsFixed(0)} Saved!',
        'body': 'That\'s a nice weekend getaway! Treat yourself!',
      };
    } else if (amount >= 100) {
      return {
        'title': '🌟 \$${amount.toStringAsFixed(0)} Saved!',
        'body': 'Triple digits! Your wallet is happier!',
      };
    } else if (amount >= 50) {
      return {
        'title': '💚 \$${amount.toStringAsFixed(2)} Saved!',
        'body': 'Fifty bucks! Dinner for two on you!',
      };
    } else if (amount >= 20) {
      return {
        'title': '🎯 \$${amount.toStringAsFixed(2)} Saved!',
        'body': 'Money adding up! Keep it going!',
      };
    } else {
      return {
        'title': '💰 \$${amount.toStringAsFixed(2)} Saved!',
        'body': 'Every dollar counts! You\'re building wealth!',
      };
    }
  }
}
