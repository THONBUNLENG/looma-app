import 'package:flutter_localization/flutter_localization.dart';

import 'navigator_extension.dart';

extension TranslateExtension on String {
  String get tr => getString(Go.context);
}
