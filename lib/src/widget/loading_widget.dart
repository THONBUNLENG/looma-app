import 'package:flutter/material.dart';

import 'text_widget.dart';

mixin LoadingWidget {
  static Widget loadingCenterWidget() {
    return const Center(child: CircularProgressIndicator());
  }
}
mixin ErrorWidgetUtils {
  static Widget errorWidget(String message) {
    return Center(child: TextWidget(message));
  }
}
