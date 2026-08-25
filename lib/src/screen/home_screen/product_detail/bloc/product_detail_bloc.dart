// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shopping_app/src/model/product_model.dart';

part 'product_detail_event.dart';
part 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  ProductDetailBloc({required ProductModel product, required bool isFavorite})
      : super(ProductDetailInitial(product, isFavorite)) {
    on<ProductDetailChangeSizeEvent>(_onChangeSize);
    on<ProductDetailChangeColorEvent>(_onChangeColor);
    on<ProductDetailUpdateQuantityEvent>(_onUpdateQuantity);
    on<ProductDetailToggleFavoriteEvent>(_onToggleFavorite);
    on<ProductDetailPageChangedEvent>(_onPageChanged);
  }

  void _onChangeSize(
      ProductDetailChangeSizeEvent event, Emitter<ProductDetailState> emit) {
    emit(state.copyWith(selectedSize: event.index));
  }

  void _onChangeColor(
      ProductDetailChangeColorEvent event, Emitter<ProductDetailState> emit) {
    emit(state.copyWith(selectedColor: event.index));
  }

  void _onUpdateQuantity(
      ProductDetailUpdateQuantityEvent event, Emitter<ProductDetailState> emit) {
    emit(state.copyWith(quantity: event.quantity));
  }

  void _onToggleFavorite(
      ProductDetailToggleFavoriteEvent event, Emitter<ProductDetailState> emit) {
    emit(state.copyWith(isFavorite: !state.isFavorite));
  }

  void _onPageChanged(
      ProductDetailPageChangedEvent event, Emitter<ProductDetailState> emit) {
    emit(state.copyWith(currentPage: event.index));
  }
}
