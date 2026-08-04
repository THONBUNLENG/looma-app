import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'flash_sale_event.dart';
part 'flash_sale_state.dart';

class FlashSaleBloc extends Bloc<FlashSaleEvent, FlashSaleState> {
  FlashSaleBloc() : super(FlashSaleInitial()) {
    on<FlashSaleEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
