part of 'address_bloc.dart';

@immutable
sealed class AddressEvent {}

class LoadAddresses extends AddressEvent {}

class AddAddress extends AddressEvent {
  final Map<String, dynamic> address;
  AddAddress(this.address);
}

class UpdateAddress extends AddressEvent {
  final int index;
  final Map<String, dynamic> address;
  UpdateAddress(this.index, this.address);
}

class DeleteAddress extends AddressEvent {
  final int index;
  DeleteAddress(this.index);
}

class SetDefaultAddress extends AddressEvent {
  final int index;
  SetDefaultAddress(this.index);
}
