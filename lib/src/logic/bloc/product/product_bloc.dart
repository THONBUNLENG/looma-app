import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../model/product_model.dart';
import '../../../network/repository/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;

  ProductBloc(this._productRepository) : super(ProductInitial()) {
    on<FetchProductsByCategory>(_onFetchProducts);
    on<SearchProducts>(_onSearchProducts);
  }

  Future<void> _onFetchProducts(
    FetchProductsByCategory event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await _productRepository.getProductsByCategory(event.category);
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<ProductState> emit,
  ) async {
    // Basic filtering logic for search
    if (state is ProductLoaded) {
      final allProducts = (state as ProductLoaded).products;
      if (event.query.isEmpty) {
        emit(ProductLoaded(allProducts));
        return;
      }
      final filtered = allProducts.where((p) {
        return p.title.toLowerCase().contains(event.query.toLowerCase()) ||
               (p.description?.toLowerCase().contains(event.query.toLowerCase()) ?? false);
      }).toList();
      emit(ProductLoaded(filtered));
    } else {
      // If not loaded, fetch first then search (simplified)
      emit(ProductLoading());
      try {
        final products = await _productRepository.getProductsByCategory(event.category);
        final filtered = products.where((p) {
          return p.title.toLowerCase().contains(event.query.toLowerCase()) ||
                 (p.description?.toLowerCase().contains(event.query.toLowerCase()) ?? false);
        }).toList();
        emit(ProductLoaded(filtered));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    }
  }
}
