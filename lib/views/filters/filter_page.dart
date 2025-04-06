import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgk_dia/models/diamond_model.dart';
import 'package:kgk_dia/views/cart/cart_page.dart';
import 'package:kgk_dia/views/filters/bloc/filter_bloc.dart';
import 'package:kgk_dia/views/filters/bloc/filter_event.dart';
import 'package:kgk_dia/views/filters/result_page.dart';
import 'package:kgk_dia/views/settings/settings_view.dart';

class FilterPage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  double _minCarat = 0.5;
  double _maxCarat = 5.0;
  String? _selectedLab;
  String? _selectedShape;
  String? _selectedColor;
  String? _selectedClarity;

  List<String> labs = [];
  List<String> shapes = [];
  List<String> colors = [];
  List<String> clarities = [];

  @override
  void initState() {
    super.initState();
    _loadExcelFromAssets();
  }

  Future<void> _loadExcelFromAssets() async {
    final ByteData data = await rootBundle.load('assets/testdata.xlsx');
    final Uint8List bytes = data.buffer.asUint8List();
    final excel = Excel.decodeBytes(bytes);

    List<Diamond> diamonds = [];
    Set<String> labSet = {};
    Set<String> shapeSet = {};
    Set<String> colorSet = {};
    Set<String> claritySet = {};
    for (var table in excel.tables.keys) {
      var rows = excel.tables[table]!.rows;

      for (int i = 1; i < rows.length; i++) {
        // start from index 1, skipping header
        var row = rows[i];

        // Safely extract fields using the correct indices (based on actual Excel structure)
        String lab = row[7]?.value.toString() ?? '';
        String shape = row[8]?.value.toString() ?? '';
        String color = row[9]?.value.toString() ?? '';
        String clarity = row[10]?.value.toString() ?? '';
        double carat = double.tryParse(row[6]?.value.toString() ?? '0') ?? 0;

        // Skip if essential fields are empty
        if (lab.isEmpty ||
            shape.isEmpty ||
            color.isEmpty ||
            clarity.isEmpty ||
            carat == 0) continue;

        diamonds.add(Diamond(
          lab: lab,
          shape: shape,
          color: color,
          clarity: clarity,
          carat: carat,
          cut: row[11]?.value.toString() ?? '',
          polish: row[12]?.value.toString() ?? '',
          symmetry: row[13]?.value.toString() ?? '',
          fluorescence: row[14]?.value.toString() ?? '',
          discount: double.tryParse(row[15]?.value.toString() ?? '0') ?? 0,
          perCaratRate: double.tryParse(row[16]?.value.toString() ?? '0') ?? 0,
          finalAmount: double.tryParse(row[17]?.value.toString() ?? '0') ?? 0,
          keyToSymbol: row[18]?.value.toString() ?? '',
          labComment: row[19]?.value.toString() ?? '',
          lotId: row[4]?.value.toString() ?? '',
          size: 0,
        ));

        labSet.add(lab);
        shapeSet.add(shape);
        colorSet.add(color);
        claritySet.add(clarity);
      }
    }

    setState(() {
      labs = labSet.toList();
      shapes = shapeSet.toList();
      colors = colorSet.toList();
      clarities = claritySet.toList();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FilterBloc>().add(ImportDiamonds(diamonds));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter Diamonds",
            style: TextStyle(fontWeight: FontWeight.bold)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, SettingsView.routeName);
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Filters",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 10),
            _buildCaratSlider(),
            _buildDropdown("Lab", labs, _selectedLab,
                (val) => setState(() => _selectedLab = val)),
            _buildDropdown("Shape", shapes, _selectedShape,
                (val) => setState(() => _selectedShape = val)),
            _buildDropdown("Color", colors, _selectedColor,
                (val) => setState(() => _selectedColor = val)),
            _buildDropdown("Clarity", clarities, _selectedClarity,
                (val) => setState(() => _selectedClarity = val)),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 5,
                ),
                onPressed: () {
                  context.read<FilterBloc>().add(
                        ApplyFilters(
                          minCarat: _minCarat,
                          maxCarat: _maxCarat,
                          lab: _selectedLab?.isNotEmpty == true
                              ? _selectedLab
                              : null,
                          shape: _selectedShape?.isNotEmpty == true
                              ? _selectedShape
                              : null,
                          color: _selectedColor?.isNotEmpty == true
                              ? _selectedColor
                              : null,
                          clarity: _selectedClarity?.isNotEmpty == true
                              ? _selectedClarity
                              : null,
                        ),
                      );

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ResultPage()),
                  );
                },
                child: const Text("Search",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Carat Range Slider with Stylish UI
  Widget _buildCaratSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Carat Range",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87)),
        SizedBox(height: 5),
        RangeSlider(
          values: RangeValues(_minCarat, _maxCarat),
          min: 0.5,
          max: 5.0,
          divisions: 50,
          activeColor: Colors.indigo,
          inactiveColor: Colors.grey[300],
          labels: RangeLabels("$_minCarat", "$_maxCarat"),
          onChanged: (values) {
            setState(() {
              _minCarat = values.start;
              _maxCarat = values.end;
            });
          },
        ),
      ],
    );
  }

  /// Custom Dropdown with Modern UI
  Widget _buildDropdown(String label, List<String> items, String? selected,
      Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5),
          ],
        ),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            labelText: label,
            border: InputBorder.none,
          ),
          dropdownColor: Colors.white,
          value: selected,
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
