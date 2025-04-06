import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/diamond_model.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<ClearCart>(_onClearCart);
    _loadCartFromPrefs();
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    if (!state.cartItems.any((d) => d.lotId == event.diamond.lotId)) {
      final updated = [...state.cartItems, event.diamond];
      emit(CartState(cartItems: updated));
      _saveToPrefs(updated);
    }
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    final updated =
        state.cartItems.where((d) => d.lotId != event.diamond.lotId).toList();
    emit(CartState(cartItems: updated));
    _saveToPrefs(updated);
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(const CartState(cartItems: []));
    _saveToPrefs([]);
  }

  Future<void> _saveToPrefs(List<Diamond> items) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(items.map((d) => d.toMap()).toList());
    await prefs.setString('cart_data', encoded);
  }

  Future<void> _loadCartFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('cart_data');
    if (data != null) {
      final decoded = jsonDecode(data) as List;
      final diamonds = decoded.map((e) => Diamond.fromMap(e)).toList();
      emit(CartState(cartItems: diamonds));
    }
  }
}
