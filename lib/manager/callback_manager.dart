typedef HomeScreenCallback = void Function();
typedef RefreshIndexStack = void Function(int index);


class CallbackManager {
  factory CallbackManager() => _instance;

  CallbackManager._();

  static final CallbackManager _instance = CallbackManager._();

  HomeScreenCallback? homeScreenCallback;
  RefreshIndexStack? refreshIndexStack;

}
