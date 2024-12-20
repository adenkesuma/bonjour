import 'package:bonjour/Model/supplier_model.dart';
import 'package:bonjour/Modul/Supplier/supplier_controller.dart';
import 'package:bonjour/Provider/dbcust_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchableSupplierList extends StatefulWidget {
  final Supplier? selectedSupplier;
  final Function(Supplier?) onChanged;

  const SearchableSupplierList({
    Key? key,
    required this.selectedSupplier,
    required this.onChanged,
  }) : super(key: key);

  @override
  _SearchableSupplierListState createState() => _SearchableSupplierListState();
}

class _SearchableSupplierListState extends State<SearchableSupplierList> {
  List<Supplier> filteredSuppliers = [];
  TextEditingController searchController = TextEditingController();
  bool isListVisible = false; // Control visibility of the filtered list

  @override
  void initState() {
    super.initState();
    // Initialize filteredSuppliers with all Suppliers
    filteredSuppliers = context.read<SupplierController>().filteredSupplier;
  }

  void filterSuppliers(String query) {
    final SupplierProvider = context.read<SupplierController>();
    if (query.isEmpty) {
      filteredSuppliers = context.read<SupplierController>().filteredSupplier;
      isListVisible = false; // Hide the list when the query is empty
    } else {
      filteredSuppliers = SupplierProvider.filteredSupplier
          .where((supplier) =>
              supplier.namaSupplier.toLowerCase().contains(query.toLowerCase()))
          .toList();
      isListVisible = true; // Show the list when there are results
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: searchController,
          onChanged: filterSuppliers,
          decoration: InputDecoration(
            labelText: 'Nama Supplier',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.grey.shade100,
          ),
        ),
        const SizedBox(height: 10),
        // Display the filtered Suppliers in a ListView if the list is visible
        if (isListVisible && filteredSuppliers.isNotEmpty) ...[
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: filteredSuppliers.length,
              itemBuilder: (context, index) {
                final supplier = filteredSuppliers[index];
                return ListTile(
                  title: Text(supplier.namaSupplier),
                  onTap: () {
                    // Update the search controller with the selected supplier's name
                    searchController.text = supplier.namaSupplier;
                    widget.onChanged(supplier);
                    // Hide the filtered Suppliers list after selection
                    isListVisible = false;
                    setState(() {});
                  },
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
