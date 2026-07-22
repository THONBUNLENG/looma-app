import 'package:flutter_localization/flutter_localization.dart';

import 'navigator_extension.dart';

extension TranslateExtension on String {
  String get tr {
    final context = Go.navigatorKey.currentContext;
    if (context == null) return this;
    return getString(context);
  }

  String trArgs(List<dynamic> args) {
    final context = Go.navigatorKey.currentContext;
    if (context == null) return this;
    return context.formatString(this, args);
  }
}
