part of 'bag_bloc.dart';

@immutable
sealed class BagState {}

final class BagInitial extends BagState {}

final class BagLoading extends BagState {}

final class BagLoaded extends BagState {
  final List<Map<String, dynamic>> items;
  final double subtotal;
  final int totalQuantity;
  final bool isAllSelected;
  final String? appliedCode;
  final double appliedDiscount;

  BagLoaded({
    required this.items,
    required this.subtotal,
    required this.totalQuantity,
    required this.isAllSelected,
    this.appliedCode,
    this.appliedDiscount = 0.0,
  });

  BagLoaded copyWith({
    List<Map<String, dynamic>>? items,
    double? subtotal,
    int? totalQuantity,
    bool? isAllSelected,
    String? appliedCode,
    double? appliedDiscount,
  }) {
    return BagLoaded(
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      isAllSelected: isAllSelected ?? this.isAllSelected,
      appliedCode: appliedCode ?? this.appliedCode,
      appliedDiscount: appliedDiscount ?? this.appliedDiscount,
    );
  }
}

final class BagError extends BagState {
  final String message;
  BagError(this.message);
}
