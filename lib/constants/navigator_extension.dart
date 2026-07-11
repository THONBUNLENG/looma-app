import 'package:flutter/material.dart';

abstract class Go {
  static final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();

  ///This is navigatorKey you have to pass it in the MaterialApp in the main.dart
  static GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  ///If you need context in any file in your code you can use it
  static BuildContext get context => _navigatorKey.currentContext!;

  ///This is simple navigation all you have to do
  ///just pass your [widget] to go
  static Future<T?> to<T extends Object?>(
    Widget page, {
    bool allowSnapshotting = true,
    bool barrierDismissible = false,
    bool fullscreenDialog = false,
    bool maintainState = true,
    RouteSettings? settings,
  }) async {
    return navigatorKey.currentState?.push<T>(
      MaterialPageRoute(
        builder: (context) => page,
        allowSnapshotting: allowSnapshotting,
        barrierDismissible: barrierDismissible,
        fullscreenDialog: fullscreenDialog,
        maintainState: maintainState,
        settings: settings,
      ),
    );
  }

  ///This is simple navigation all you have to do
  ///just pass your [widget] to go and it will
  ///remove previous route from the tree
  static Future<T?> toReplace<T extends Object?, TO extends Object?>(
    Widget page, {
    bool allowSnapshotting = true,
    bool barrierDismissible = false,
    bool fullscreenDialog = false,
    bool maintainState = true,
    RouteSettings? settings,
  }) async {
    return navigatorKey.currentState?.pushReplacement<T, TO>(
      MaterialPageRoute(
        builder: (context) => page,
        allowSnapshotting: allowSnapshotting,
        barrierDismissible: barrierDismissible,
        fullscreenDialog: fullscreenDialog,
        maintainState: maintainState,
        settings: settings,
      ),
    );
  }

  ///This is simple navigation all you have to do
  ///just pass your [widget] to go and it will
  ///remove all routes from the tree
  static Future<T?> toRemoveUntil<T extends Object?>(
    Widget page, {
    bool allowSnapshotting = true,
    bool barrierDismissible = false,
    bool fullscreenDialog = false,
    bool maintainState = true,
    RouteSettings? settings,
    bool Function(Route<dynamic>)? predicate,
  }) async {
    predicate ??= (route) => false;

    return navigatorKey.currentState?.pushAndRemoveUntil<T>(
      MaterialPageRoute(
        builder: (context) => page,
        allowSnapshotting: allowSnapshotting,
        barrierDismissible: barrierDismissible,
        fullscreenDialog: fullscreenDialog,
        maintainState: maintainState,
        settings: settings,
      ),
      predicate,
    );
  }

  ///If you want to pop sothing before
  ///pushing to another widget you could use it,
  ///just pass your [widget] to go
  static Future<void> backAndTo(Widget page) async {
    back();
    to(page);
  }

  ///If you need to back to previous page you can use this function,
  ///however if you need to pop many routes you simply
  ///have to pass how many time you want to pop
  ///using [numOfBacks].
  ///There is no need to pass [numOfBacks] if you just want to pop one time.
  static Future<void> multiBack([int? numOfBacks]) async {
    if (numOfBacks == null) {
      navigatorKey.currentState?.pop();
    } else {
      for (var i = 0; i < numOfBacks; i++) {
        navigatorKey.currentState?.pop();
      }
    }
  }

  static Future<void> back<T extends Object?>([T? result]) async {
    return navigatorKey.currentState?.pop(result);
  }
}

abstract class GoMessenger {
  ///If you wnat to [showAdaptiveDialog] without using context
  ///you have to use this function and the package will pass the context automaticlly.
  ///You can use all [showAdaptiveDialog] proparties as usuall.
  static Future<T?> dialog<T>(
    Widget content, {
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
    TraversalEdgeBehavior? traversalEdgeBehavior,
  }) async {
    return showDialog<T>(
      context: Go.context,
      builder: (context) => content,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      anchorPoint: anchorPoint,
      traversalEdgeBehavior: traversalEdgeBehavior,
    );
  }

  ///If you wnat to [showModalBottomSheet] without using context
  ///you have to use this function and the package will pass the context automaticlly.
  ///You can use all [showModalBottomSheet] proparties as usuall.
  static Future<T?> bottomSheet<T>(
    Widget content, {
    Color? backgroundColor,
    String? barrierLabel,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
    Color? barrierColor,
    bool isScrollControlled = false,
    double scrollControlDisabledMaxHeightRatio = 9.0 / 16.0,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    bool? showDragHandle,
    bool useSafeArea = false,
    RouteSettings? routeSettings,
    AnimationController? transitionAnimationController,
    Offset? anchorPoint,
    AnimationStyle? sheetAnimationStyle,
  }) async {
    return showModalBottomSheet<T>(
      context: Go.context,
      builder: (context) => content,
      backgroundColor: backgroundColor,
      barrierLabel: barrierLabel,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      constraints: constraints,
      barrierColor: barrierColor,
      isScrollControlled: isScrollControlled,
      scrollControlDisabledMaxHeightRatio: scrollControlDisabledMaxHeightRatio,
      useRootNavigator: useRootNavigator,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      showDragHandle: showDragHandle,
      useSafeArea: useSafeArea,
      routeSettings: routeSettings,
      transitionAnimationController: transitionAnimationController,
      anchorPoint: anchorPoint,
      sheetAnimationStyle: sheetAnimationStyle,
    );
  }

  ///If you wnat to [showSnackBar] without using context
  ///you have to use this function and the package will pass the context automaticlly.
  ///You can use all [showSnackBar] proparties as usuall.
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(
    SnackBar snackBar, {
    AnimationStyle? snackBarAnimationStyle,
  }) {
    return ScaffoldMessenger.of(
      Go.context,
    ).showSnackBar(snackBar, snackBarAnimationStyle: snackBarAnimationStyle);
  }

  ///If you wnat to [showMaterialBanner] without using context
  ///you have to use this function and the package will pass the context automaticlly.
  ///You can use all [showMaterialBanner] proparties as usuall.
  static ScaffoldFeatureController<MaterialBanner, MaterialBannerClosedReason>
  materialBanner(MaterialBanner materialBanner) {
    return ScaffoldMessenger.of(Go.context).showMaterialBanner(materialBanner);
  }
}

abstract class GofContext {
  ///If you need any thing from [Theme.of(context)]
  ///you can use it wherevere in your code without need any context.
  static ThemeData get theme => Theme.of(Go.context);

  ///If you need any thing from [MediaQuery.of(context)]
  ///you can use it wherevere in your code without need any context.
  static MediaQueryData get mediaQuery => MediaQuery.of(Go.context);

  static double get mediaQueryWidth => MediaQuery.of(Go.context).size.width;

  static double get mediaQueryHeight => MediaQuery.of(Go.context).size.height;

  ///If you need any thing from [Focus.of(Go.context)]
  ///you can use it wherevere in your code without need any context.
  static FocusNode get focus => Focus.of(Go.context);

  ///If you need any thing from [FocusScope.of(Go.context)]
  ///you can use it wherevere in your code without need any context.
  static FocusNode get focusScope => FocusScope.of(Go.context);

  ///If you need any thing from [DefaultAssetBundle.of(Go.context)]
  ///you can use it wherevere in your code without need any context.
  static AssetBundle get defaultAssetBundle =>
      DefaultAssetBundle.of(Go.context);

  ///If you need any thing from [MaterialLocalizations.of(context)]
  ///you can use it wherevere in your code without need any context.
  static MaterialLocalizations get materialLocalizations =>
      MaterialLocalizations.of(Go.context);

  ///If you need any thing from [Scaffold.of(context)]
  ///you can use it wherevere in your code without need any context.
  static ScaffoldState get scaffold => Scaffold.of(Go.context);

  ///If you need any thing from [ScaffoldMessenger.of(context)]
  ///you can use it wherevere in your code without need any context.
  static ScaffoldMessengerState get scaffoldMessenger =>
      ScaffoldMessenger.of(Go.context);

  ///If you need any thing from [Navigator.of(context)]
  ///you can use it where ever in your code without need any context.
  static NavigatorState get navigator => Navigator.of(Go.context);

  static void get dismissKeyboard =>
      FocusManager.instance.primaryFocus?.unfocus();
}
