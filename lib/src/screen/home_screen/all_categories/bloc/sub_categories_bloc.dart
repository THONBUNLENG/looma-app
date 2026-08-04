import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'sub_categories_event.dart';
part 'sub_categories_state.dart';

class SubCategoriesBloc extends Bloc<SubCategoriesEvent, SubCategoriesState> {
  SubCategoriesBloc() : super(SubCategoriesInitial()) {
    on<SubCategoriesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
