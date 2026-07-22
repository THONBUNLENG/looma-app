import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'product_datil_event.dart';
part 'product_datil_state.dart';

class ProductDatilBloc extends Bloc<ProductDatilEvent, ProductDatilState> {
  ProductDatilBloc() : super(ProductDatilInitial()) {
    on<ProductDatilEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
