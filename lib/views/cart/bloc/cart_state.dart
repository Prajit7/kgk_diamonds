import 'package:equatable/equatable.dart';
import '../../../models/diamond_model.dart';

class CartState extends Equatable {
  final List<Diamond> cartItems;

  const CartState({this.cartItems = const []});

  double get totalCarat => cartItems.fold(0.0, (sum, d) => sum + d.carat);

  double get totalPrice => cartItems.fold(0.0, (sum, d) => sum + d.finalAmount);

  double get averagePrice =>
      cartItems.isNotEmpty ? totalPrice / cartItems.length : 0;

  double get averageDiscount => cartItems.isNotEmpty
      ? cartItems.fold(0.0, (sum, d) => sum + d.discount) / cartItems.length
      : 0;

  @override
  List<Object> get props => [cartItems];

  Map<String, dynamic> toMap() => {
        'cartItems': cartItems.map((e) => e.toMap()).toList(),
      };

  factory CartState.fromMap(Map<String, dynamic> map) {
    return CartState(
      cartItems: List<Diamond>.from(
        (map['cartItems'] ?? []).map((x) => Diamond.fromMap(x)),
      ),
    );
  }
}
