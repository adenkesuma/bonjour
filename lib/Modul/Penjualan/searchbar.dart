import 'package:bonjour/Model/customer_model.dart';
import 'package:bonjour/Provider/dbcust_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchableCustomerList extends StatefulWidget {
  final Customer? selectedCustomer;
  final Function(Customer?) onChanged;

  const SearchableCustomerList({
    Key? key,
    required this.selectedCustomer,
    required this.onChanged,
  }) : super(key: key);

  @override
  _SearchableCustomerListState createState() => _SearchableCustomerListState();
}

class _SearchableCustomerListState extends State<SearchableCustomerList> {
  List<Customer> filteredCustomers = [];
  TextEditingController searchController = TextEditingController();
  bool isListVisible = false; // Control visibility of the filtered list

  @override
  void initState() {
    super.initState();
    // Initialize filteredCustomers with all customers
    filteredCustomers = context.read<CustomerProvider>().customerList;
  }

  void filterCustomers(String query) {
    final customerProvider = context.read<CustomerProvider>();
    if (query.isEmpty) {
      filteredCustomers = customerProvider.customerList;
      isListVisible = false; // Hide the list when the query is empty
    } else {
      filteredCustomers = customerProvider.customerList
          .where((customer) =>
              customer.namaCustomer.toLowerCase().contains(query.toLowerCase()))
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
          onChanged: filterCustomers,
          decoration: InputDecoration(
            labelText: 'Nama Customer',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.grey.shade100,
          ),
        ),
        const SizedBox(height: 10),
        // Display the filtered customers in a ListView if the list is visible
        if (isListVisible && filteredCustomers.isNotEmpty) ...[
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: filteredCustomers.length,
              itemBuilder: (context, index) {
                final customer = filteredCustomers[index];
                return ListTile(
                  title: Text(customer.namaCustomer),
                  onTap: () {
                    // Update the search controller with the selected customer's name
                    searchController.text = customer.namaCustomer;
                    widget.onChanged(customer);
                    // Hide the filtered customers list after selection
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
