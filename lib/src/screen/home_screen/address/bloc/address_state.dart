part of 'address_bloc.dart';

@immutable
sealed class AddressState {}

final class AddressInitial extends AddressState {}

final class AddressLoading extends AddressState {}

final class AddressLoaded extends AddressState {
  final List<Map<String, dynamic>> addresses;
  AddressLoaded(this.addresses);
}

final class AddressError extends AddressState {
  final String message;
  AddressError(this.message);
}
