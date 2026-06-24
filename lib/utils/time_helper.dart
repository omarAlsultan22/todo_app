/// 📚 مخصص للتعامل مع التواريخ والأوقات
class TimeHelper {
  /// 🔄 تحويل الوقت من 24 ساعة إلى 12 ساعة مع AM/PM
  static String formatTo12Hour(String time24) {
    try {
      final parts = time24.split(':');
      final hour = int.parse(parts[0]);
      final minute = parts[1];
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      print('12Hour');
      return '$displayHour:$minute $period';
    } catch (e) {
      return time24; // fallback
    }
  }

  /// 🔄 تحويل الوقت من 12 ساعة إلى 24 ساعة
  static String formatTo24Hour(String time12) {
    try {
      final parts = time12.split(' ');
      final time = parts[0].split(':');
      final hour = int.parse(time[0]);
      final minute = time[1];
      final period = parts[1];

      int hour24 = hour;
      if (period == 'PM' && hour != 12) {
        hour24 = hour + 12;
      } else if (period == 'AM' && hour == 12) {
        hour24 = 0;
      }

      print('${hour24.toString().padLeft(2, '0')}:$minute');
      return '${hour24.toString().padLeft(2, '0')}:$minute';
    } catch (e) {
      return time12; // fallback
    }
  }
}