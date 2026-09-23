// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../style_product_data.dart';

part 'style_product_event.dart';
part 'style_product_state.dart';

class StyleProductBloc extends Bloc<StyleProductEvent, StyleProductState> {
  StyleProductBloc() : super(StyleProductInitial()) {
    on<StyleProductStarted>(_onStarted);
    on<StyleFilterChanged>(_onFilterChanged);
    on<StyleSearchQueryChanged>(_onSearchQueryChanged);
  }

  void _onStarted(StyleProductStarted event, Emitter<StyleProductState> emit) {
    emit(StyleProductLoading());
    final allProducts = _getAllProducts();
    emit(StyleProductLoaded(products: allProducts));
  }

  void _onFilterChanged(StyleFilterChanged event, Emitter<StyleProductState> emit) {
    if (state is StyleProductLoaded) {
      final currentState = state as StyleProductLoaded;
      final filteredProducts = _filterProducts(
        event.style,
        currentState.searchQuery,
      );
      emit(currentState.copyWith(
        products: filteredProducts,
        selectedStyle: event.style,
      ));
    }
  }

  void _onSearchQueryChanged(StyleSearchQueryChanged event, Emitter<StyleProductState> emit) {
    if (state is StyleProductLoaded) {
      final currentState = state as StyleProductLoaded;
      final filteredProducts = _filterProducts(
        currentState.selectedStyle,
        event.query,
      );
      emit(currentState.copyWith(
        products: filteredProducts,
        searchQuery: event.query,
      ));
    }
  }

  List<Map<String, dynamic>> _getAllProducts() {
    final List<Map<String, dynamic>> combined = [];
    styleProduct.forEach((styleName, productList) {
      for (final product in productList) {
        combined.add({...product, 'style': styleName});
      }
    });
    return combined;
  }

  List<Map<String, dynamic>> _filterProducts(String style, String query) {
    List<Map<String, dynamic>> products;
    if (style == "ALL") {
      products = _getAllProducts();
    } else {
      products = (styleProduct[style] ?? [])
          .map((item) => {...item, 'style': style})
          .toList();
    }

    if (query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      products = products.where((product) {
        final title = (product['title'] ?? '').toString().toLowerCase();
        return title.contains(lowerQuery);
      }).toList();
    }

    return products;
  }
}
