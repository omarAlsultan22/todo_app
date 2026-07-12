class PositionUtils {
  static int calculateSafePosition({
    required int position,
    required int tasksLength,
  }) {
    if (tasksLength == 0) return 0;
    if (position >= 0 && position <= tasksLength) return position;
    if (position < 0) return 0;
    return tasksLength;
  }
}