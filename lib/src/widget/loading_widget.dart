import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'text_widget.dart';

mixin LoadingWidget {
  static Widget loadingCenterWidget() {
    return Center(
      child: Lottie.asset(
        'assets/lottie/loading.json',
        width: 100,
        height: 100,
        fit: BoxFit.contain,
      ),
    );
  }
}
mixin ErrorWidgetUtils {
  static Widget errorWidget(String message) {
    return Center(child: TextWidget(message));
  }
}
