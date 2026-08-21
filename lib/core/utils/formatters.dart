import 'package:intl/intl.dart';

/// Utility functions for formatting currency, dates, and other display values.
class Formatters {
  Formatters._();

  static final _birr = NumberFormat('#,##0.##', 'en');
  static final _birrDecimal = NumberFormat('#,##0.00', 'en');
  static final _timeFormat = DateFormat('hh:mm a');
  static final _dateFormat = DateFormat('MMM d, yyyy');
  static final _shortDate = DateFormat('MMM d');

  /// Format amount as "8,450 ETB"
  static String currency(num amount, {bool compact = false}) {
    if (compact && amount >= 1000) {
      return '${_birr.format(amount / 1000)}k ETB';
    }
    return '${_birr.format(amount)} ETB';
  }

  /// Format with decimal: "8,450.00 ETB"
  static String currencyFull(num amount) {
    return '${_birrDecimal.format(amount)} ETB';
  }

  /// Format number with commas: "8,450"
  static String number(num n) => _birr.format(n);

  /// "10:43 AM"
  static String time(DateTime dt) => _timeFormat.format(dt.toLocal());

  /// "Aug 21, 2026"
  static String date(DateTime dt) => _dateFormat.format(dt.toLocal());

  /// "Aug 21"
  static String shortDate(DateTime dt) => _shortDate.format(dt.toLocal());

  /// Greeting based on time of day
  static String greeting(String name) {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning, $name';
    if (hour < 17) return 'Good afternoon, $name';
    return 'Good evening, $name';
  }

  /// Greeting key for localization
  static String greetingKey() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'goodMorning';
    if (hour < 17) return 'goodAfternoon';
    return 'goodEvening';
  }
}
