class Achievement {
  final String coloredImage;
  final String grayscaleImage;
  final String title;
  final String subtitle;
  final String description;
  final int requiredValue;
  final bool isDaysBased;
  bool isCompleted;

  Achievement({
    required this.coloredImage,
    required this.grayscaleImage,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.requiredValue,
    required this.isDaysBased,
    this.isCompleted = false,
  });
}
