import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'help_center_event.dart';
part 'help_center_state.dart';

class HelpCenterBloc extends Bloc<HelpCenterEvent, HelpCenterState> {
  HelpCenterBloc() : super(HelpCenterInitial()) {
    on<HelpCenterEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
