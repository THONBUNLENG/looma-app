import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'bag_event.dart';
part 'bag_state.dart';

class BagBloc extends Bloc<BagEvent, BagState> {
  BagBloc() : super(BagInitial()) {
    on<BagEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
