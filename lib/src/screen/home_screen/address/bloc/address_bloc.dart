import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../../../manager/profile_manager.dart';

part 'address_event.dart';
part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final ProfileManager _profileManager = ProfileManager();

  AddressBloc() : super(AddressInitial()) {
    on<LoadAddresses>((event, emit) {
      emit(AddressLoading());
      try {
        final addresses = List<Map<String, dynamic>>.from(_profileManager.addresses);
        emit(AddressLoaded(addresses));
      } catch (e) {
        emit(AddressError(e.toString()));
      }
    });

    on<AddAddress>((event, emit) async {
      if (state is AddressLoaded) {
        final currentAddresses = List<Map<String, dynamic>>.from((state as AddressLoaded).addresses);
        if (event.address['isDefault'] == true) {
          for (var addr in currentAddresses) {
            addr['isDefault'] = false;
          }
        }
        currentAddresses.add(event.address);
        await _profileManager.saveAddresses(currentAddresses);
        emit(AddressLoaded(currentAddresses));
      }
    });

    on<UpdateAddress>((event, emit) async {
      if (state is AddressLoaded) {
        final currentAddresses = List<Map<String, dynamic>>.from((state as AddressLoaded).addresses);
        if (event.address['isDefault'] == true) {
          for (var addr in currentAddresses) {
            addr['isDefault'] = false;
          }
        }
        currentAddresses[event.index] = event.address;
        await _profileManager.saveAddresses(currentAddresses);
        emit(AddressLoaded(currentAddresses));
      }
    });

    on<DeleteAddress>((event, emit) async {
      if (state is AddressLoaded) {
        final currentAddresses = List<Map<String, dynamic>>.from((state as AddressLoaded).addresses);
        currentAddresses.removeAt(event.index);
        await _profileManager.saveAddresses(currentAddresses);
        emit(AddressLoaded(currentAddresses));
      }
    });

    on<SetDefaultAddress>((event, emit) async {
      if (state is AddressLoaded) {
        final currentAddresses = List<Map<String, dynamic>>.from((state as AddressLoaded).addresses);
        for (int i = 0; i < currentAddresses.length; i++) {
          currentAddresses[i]['isDefault'] = (i == event.index);
        }
        await _profileManager.saveAddresses(currentAddresses);
        emit(AddressLoaded(currentAddresses));
      }
    });
  }
}
