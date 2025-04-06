import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgk_dia/models/diamond_model.dart';
import 'package:kgk_dia/views/filters/bloc/filter_bloc.dart';
import 'package:kgk_dia/views/filters/bloc/filter_event.dart';
import 'package:kgk_dia/views/filters/bloc/filter_state.dart';
import 'package:kgk_dia/views/cart/bloc/cart_bloc.dart';
import 'package:kgk_dia/views/cart/bloc/cart_event.dart';

class ResultPage extends StatefulWidget {
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  String _selectedSort = "Final Price";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Filtered Diamonds")),
      body: BlocBuilder<FilterBloc, FilterState>(
        builder: (context, state) {
          if (state is FilterLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FilterLoaded) {
            final diamonds = state.filteredDiamonds;

            return diamonds.isNotEmpty
                ? Column(
                    children: [
                      _buildSortOptions(context),
                      Expanded(
                        child: ListView.builder(
                          itemCount: diamonds.length,
                          itemBuilder: (context, index) {
                            return _buildDiamondCard(context, diamonds[index]);
                          },
                        ),
                      ),
                    ],
                  )
                : const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("No results found!",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  );
            ;
          } else if (state is FilterError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text("No diamonds to show."));
          }
        },
      ),
    );
  }

  /// Sorting Options
  Widget _buildSortOptions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Sort By:", style: TextStyle(fontWeight: FontWeight.bold)),
          DropdownButton<String>(
            value: _selectedSort,
            items: const [
              DropdownMenuItem(
                  value: "Final Price", child: Text("Final Price")),
              DropdownMenuItem(
                  value: "Carat Weight", child: Text("Carat Weight")),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedSort = value);
                BlocProvider.of<FilterBloc>(context).add(
                  SortDiamonds(
                    sortBy: value == "Final Price" ? 'price' : 'carat',
                    ascending: true,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  /// Diamond Card UI
  Widget _buildDiamondCard(BuildContext context, Diamond diamond) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Lot ID: ${diamond.lotId}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text("Carat: ${diamond.carat} | Shape: ${diamond.shape}"),
            Text("Lab: ${diamond.lab} | Color: ${diamond.color}"),
            Text("Clarity: ${diamond.clarity}"),
            Text(
              "Price: \$${diamond.finalAmount}",
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text("Add to Cart"),
                  onPressed: () {
                    BlocProvider.of<CartBloc>(context)
                        .add(AddToCart(diamond, context: context));
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.remove_shopping_cart),
                  label: const Text("Remove"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    BlocProvider.of<CartBloc>(context)
                        .add(RemoveFromCart(diamond));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}