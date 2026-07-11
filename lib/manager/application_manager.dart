import 'package:flutter_localization/flutter_localization.dart';

class ApplicationManager {
  factory ApplicationManager() => _instance;

  ApplicationManager._();

  static final ApplicationManager _instance = ApplicationManager._();

  final FlutterLocalization translator = FlutterLocalization.instance;
}
