part of 'product_detail_bloc.dart';


@immutable
sealed class ProductDetailEvent {}

class ProductDetailChangeSizeEvent extends ProductDetailEvent {
  final int index;
  ProductDetailChangeSizeEvent(this.index);
}

class ProductDetailChangeColorEvent extends ProductDetailEvent {
  final int index;
  ProductDetailChangeColorEvent(this.index);
}

class ProductDetailUpdateQuantityEvent extends ProductDetailEvent {
  final int quantity;
  ProductDetailUpdateQuantityEvent(this.quantity);
}

class ProductDetailToggleFavoriteEvent extends ProductDetailEvent {}

class ProductDetailPageChangedEvent extends ProductDetailEvent {
  final int index;
  ProductDetailPageChangedEvent(this.index);
}
