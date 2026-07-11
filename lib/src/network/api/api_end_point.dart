class EcommerceAPIEndPoint {
  EcommerceAPIEndPoint._internal();

  static final EcommerceAPIEndPoint _instance =
      EcommerceAPIEndPoint._internal();

  static EcommerceAPIEndPoint get instance => _instance;

  ///------------------------ SERVER DOMAIN -----------------------------

  static const String _domain = 'http://127.0.0.1:8000';

  ///-----------------------------------------------------

  final String _basePath = '/api/payment_repository-gateway/v1/payments';

  String get purchase => '$_domain$_basePath/purchase';

  String get categories => '$_domain/api/v1/categories_repository';

  ///----------------item Products ----------------------------------------

  String get items => '$_domain/api/v1/items';

  String get baseUrl => '$_domain/api/payment_repository-gateway/v1/payments';

  String get women => '$_domain/api/categories_repository/women';

  String get men => '$_domain/api/categories_repository/men';

  String get kids => '$_domain/api/categories_repository/kids';

  String get beauty => '$_domain/api/categories_repository/beauty';

  String get flashSale => '$_domain/api/categories_repository/flash-sale';

  String get newProducts => '$_domain/api/categories_repository/new-products';

  String get bestSelling => '$_domain/api/categories_repository/best-selling';

  String get topRated => '$_domain/api/categories_repository/top-rated';

  String get swatches => '$_domain/api/categories_repository/swatches';

  String get filter => '$_domain/api/categories_repository/filter';

  String get products => '$_domain/api/products';

  String get polo => '$_domain/api/products/polo';

  String get jeans => '$_domain/api/products/jeans';

  String get shirts => '$_domain/api/products/shirts';

  String get shoes => '$_domain/api/products/shoes';

  String get accessories => '$_domain/api/products/accessories';

  String get jackets => '$_domain/api/products/jackets';

  String get dresses => '$_domain/api/products/dresses';

  String get verbs => '$_domain/api/products/verbs';

  String get skirt => '$_domain/api/products/skirt';

  String get shorts => '$_domain/api/products/shorts';

  String get pants => '$_domain/api/products/pants';

  String get tshirts => '$_domain/api/products/tshirts';

  String get hoodies => '$_domain/api/products/hoodies';

  String get bags => '$_domain/api/products/bags';

  String get watch => '$_domain/api/products/watch';

  String get toys => '$_domain/api/products/toys';

  String get jewelry => '$_domain/api/products/jewelry';

  String get sports => '$_domain/api/products/sports';

  String get lingerie => '$_domain/api/products/lingerie';

  String get footwear => '$_domain/api/products/footwear';

  String get gift => '$_domain/api/products/gift';

  String get perfume => '$_domain/api/products/perfume';

  String get mostPopular => '$_domain/api/products/most-popular';

  String get cosmetics => '$_domain/api/products/cosmetics';

  String get home => '$_domain/api/products/home';

  String get kitchen => '$_domain/api/products/kitchen';

  ///--------------payment_repository---------------------------------

  String get cart => '$_domain/api/payment_repository/cart';

  String get cartItem => '$_domain/api/payment_repository/cart-item';

  String get checkout => '$_domain/api/payment_repository/checkout';

  String get order => '$_domain/api/payment_repository/order';

  String get orderStatus => '$_domain/api/payment_repository/order-status';

  String get orderDetail => '$_domain/api/payment_repository/order-detail';

  String get orderHistory => '$_domain/api/payment_repository/order-history';

  String get orderDetailHistory => '$_domain/api/payment_repository/order-detail-history';

  String get orderStatusHistory => '$_domain/api/payment_repository/order-status-history';

  String get productDetail => '$_domain/api/payment_repository/product-detail';

  String get productReview => '$_domain/api/payment_repository/product-review';

  String get productReviewDetail =>
      '$_domain/api/payment_repository/product-review-detail';

  String get productReviewHistory =>
      '$_domain/api/payment_repository/product-review-history';

  String get productReviewDetailHistory =>
      '$_domain/api/payment_repository/product-review-detail-history';
  ///-----------------------Profile--------------------------------

  String get profileUser => '$_domain/api/payment_repository/user';

  String get profileUpdate => '$_domain/api/payment_repository/update';

  String get profileUpdatePassword => '$_domain/api/payment_repository/update-password';

  String get profileAddress => '$_domain/api/payment_repository/address';

  String get profileAddressAdd => '$_domain/api/payment_repository/address-add';

  String get profileAddressUpdate => '$_domain/api/payment_repository/address-update';

  String get profileAddressDelete => '$_domain/api/payment_repository/address-delete';

  String get profileOrder => '$_domain/api/payment_repository/order';

  String get profileOrderHistory => '$_domain/api/payment_repository/order-history';

  String get profileOrderCancel => '$_domain/api/payment_repository/order-cancel';

  String get editProfile => '$_domain/api/payment_repository/edit-profile';

  String get editProfileAddress => '$_domain/api/payment_repository/edit-profile-address';
}

enum DioMethod { post, get }
