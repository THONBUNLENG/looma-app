part of 'bag_bloc.dart';

@immutable
sealed class BagEvent {}

final class BagStarted extends BagEvent {}

final class BagItemRemoved extends BagEvent {
  final int index;
  BagItemRemoved(this.index);
}

final class BagItemUpdated extends BagEvent {
  final int index;
  final Map<String, dynamic> item;
  BagItemUpdated(this.index, this.item);
}

final class BagSelectionToggled extends BagEvent {
  final int index;
  BagSelectionToggled(this.index);
}

final class BagAllSelected extends BagEvent {
  final bool selected;
  BagAllSelected(this.selected);
}

final class BagSelectedRemoved extends BagEvent {}

final class BagVoucherApplied extends BagEvent {
  final String code;
  BagVoucherApplied(this.code);
}
