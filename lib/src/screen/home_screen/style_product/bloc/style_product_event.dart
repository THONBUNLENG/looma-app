part of 'style_product_bloc.dart';

@immutable
sealed class StyleProductEvent {}

final class StyleProductStarted extends StyleProductEvent {}

final class StyleFilterChanged extends StyleProductEvent {
  final String style;
  StyleFilterChanged(this.style);
}

final class StyleSearchQueryChanged extends StyleProductEvent {
  final String query;
  StyleSearchQueryChanged(this.query);
}
