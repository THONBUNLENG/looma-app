part of 'brand_bloc.dart';

@immutable
sealed class BrandState {}

final class BrandInitial extends BrandState {}

final class BrandLoading extends BrandState {}

final class BrandLoaded extends BrandState {
  final List<BrandModel> brands;
  BrandLoaded(this.brands);
}

final class BrandError extends BrandState {
  final String message;
  BrandError(this.message);
}
