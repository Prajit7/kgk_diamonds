import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../models/diamond_model.dart';
import 'bloc/cart_bloc.dart';
import 'bloc/cart_state.dart';
import 'bloc/cart_event.dart';

class CartPage extends StatelessWidget {
  static const String routeName = '/cart';

  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          final cartItems = state.cartItems;

          if (cartItems.isEmpty) {
            return _buildEmptyCart();
          }

          return Column(
            children: [
              Expanded(child: _buildCartList(cartItems, context)),
              _buildCartSummary(state),
            ],
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Your Cart",
          style: TextStyle(fontWeight: FontWeight.bold)),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blueAccent, Colors.indigo]),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.white),
          onPressed: () {
            context.read<CartBloc>().add(ClearCart());
          },
        ),
      ],
    );
  }

  Widget _buildEmptyCart() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Your cart is empty!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildCartList(List<Diamond> cartItems, BuildContext context) {
    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final diamond = cartItems[index];
        return Dismissible(
          key: Key(diamond.lotId),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: Colors.red,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) {
            context.read<CartBloc>().add(RemoveFromCart(diamond));
          },
          child: _buildCartItem(diamond),
        );
      },
    );
  }

  Widget _buildCartItem(Diamond diamond) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text("${diamond.shape} - ${diamond.carat} Carat",
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Color: ${diamond.color} | Clarity: ${diamond.clarity}"),
        trailing: Text("\$${diamond.finalAmount}",
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green)),
        leading: const Icon(Icons.diamond, color: Colors.blueAccent),
      ),
    );
  }

  Widget _buildCartSummary(CartState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Cart Summary",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 8),
          _summaryRow("Total Carat:", state.totalCarat.toStringAsFixed(2)),
          _summaryRow(
              "Total Price:", "\$${state.totalPrice.toStringAsFixed(2)}"),
          _summaryRow(
              "Avg Discount:", "${state.averageDiscount.toStringAsFixed(2)}%"),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Add checkout logic
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, foregroundColor: Colors.indigo),
            child: const Text("Proceed to Checkout"),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white)),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }
}
