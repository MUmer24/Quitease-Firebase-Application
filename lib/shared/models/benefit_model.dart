class Benefit {
  final int progressPercent;
  final String description;
  final bool isCompleted;

  Benefit({
    required this.progressPercent,
    required this.description,
    bool? isCompleted,
  }) : isCompleted = isCompleted ?? (progressPercent == 100);
}
