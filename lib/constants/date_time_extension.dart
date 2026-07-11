
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  bool theSameDateAs(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  /// 2023-08-20
  String get toyyyyMMdd => DateFormat('yyyy-MM-dd').format(this);

  /// 20-08-2023
  String get toddMMyyyy => DateFormat('dd-MM-yyyy').format(this);

  /// 08:00 AM
  String get tohhmma => DateFormat('hh:mm a').format(toLocal());

  /// 08:00:00 AM
  String get tohhmmssa => DateFormat('hh:mm:ss a').format(toLocal());

  /// Wed, Mar 08, 2023
  String get toEEMMMddyyyy => DateFormat(
        'EE, MMM dd, yyyy',
        FlutterLocalization.instance.currentLocale?.languageCode,
      ).format(this);

  /// Monday, March 08, 2023
  String get toEEEEMMMMddyyyy => DateFormat(
    'EEEE, MMMM dd, yyyy',
    FlutterLocalization.instance.currentLocale?.languageCode,
  ).format(this);

  /// Mar 08, 2023
  String get toMMMddyyyy => DateFormat(
        'MMM dd, yyyy',
        FlutterLocalization.instance.currentLocale?.languageCode,
      ).format(this);

  /// Mar 08
  String get toMMMdd => DateFormat(
        'MMM dd',
        FlutterLocalization.instance.currentLocale?.languageCode,
      ).format(this);

  /// Mar 26 - 08:00 AM
  String get toMMMddhhmma => DateFormat(
        'MMM dd - hh:mm a',
        FlutterLocalization.instance.currentLocale?.languageCode,
      ).format(toLocal());

  /// Nov 26, 2023 - 08:40 AM
  String get toMMMddyyyyhhmma => DateFormat(
        'MMM dd, yyyy - hh:mm a',
        FlutterLocalization.instance.currentLocale?.languageCode,
      ).format(toLocal());

  /// 2023-03-20 10:30 PM
  String get toddMMyyyyhhmma =>
      DateFormat('yyyy-MM-dd hh:mm a').format(toLocal());

  /// 2023-03-20 13:00
  String get toddMMyyyyHHmm =>
      DateFormat('yyyy-MM-dd HH:mm').format(toLocal());

  /// 13:00
  String get toHHmm =>
      DateFormat('HH:mm').format(toLocal());

}

