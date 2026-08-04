import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../../model/brand_model.dart';

part 'brand_event.dart';
part 'brand_state.dart';

class BrandBloc extends Bloc<BrandEvent, BrandState> {
  BrandBloc() : super(BrandInitial()) {
    on<LoadBrands>((event, emit) async {
      emit(BrandLoading());
      try {
        await Future.delayed(const Duration(milliseconds: 300));
        emit(BrandLoaded(featuredBrands));
      } catch (e) {
        emit(BrandError(e.toString()));
      }
    });
  }
}
