typedef HomeScreenCallback = void Function();
typedef RefreshIndexStack = void Function(int index);
typedef RefreshWishlist = void Function();

class CallbackManager {
  factory CallbackManager() => _instance;

  CallbackManager._();

  static final CallbackManager _instance = CallbackManager._();

  HomeScreenCallback? homeScreenCallback;
  RefreshIndexStack? refreshIndexStack;
  RefreshWishlist? refreshWishlist;
}
