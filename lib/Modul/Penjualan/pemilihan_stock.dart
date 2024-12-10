import 'package:bonjour/Model/stock_model.dart';
import 'package:bonjour/Modul/Stock/stock_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TextControllerProvider with ChangeNotifier {
  TextEditingController textController = TextEditingController();

  void clearText() {
    textController.clear();
    notifyListeners(); // Notifies listeners to rebuild
  }
}

class SearchableStockList extends StatefulWidget {
  final Stock? selectedStock;
  final Function(Stock?) onChanged;

  const SearchableStockList({
    Key? key,
    required this.selectedStock,
    required this.onChanged,
  }) : super(key: key);

  @override
  _SearchableStockListState createState() => _SearchableStockListState();
}

class _SearchableStockListState extends State<SearchableStockList> {
  List<Stock> filteredStocks = [];
  bool isListVisible = false; // Control visibility of the filtered list

  @override
  void initState() {
    super.initState();
    // Fetch data from Firestore when the widget initializes
    final stockProvider = context.read<StockController>();
    stockProvider.fetchData().then((_) {
      setState(() {
        filteredStocks = stockProvider.dataStock; // Initialize with all stocks
      });
    });
  }

  void filterStocks(String query) {
    final stockProvider = context.read<StockController>();
    if (query.isEmpty) {
      filteredStocks = stockProvider.dataStock;
      isListVisible = false; // Hide the list when the query is empty
    } else {
      filteredStocks = stockProvider.dataStock
          .where((stock) =>
              stock.namaStock.toLowerCase().contains(query.toLowerCase()) ||
              stock.kodeStock.toLowerCase().contains(query.toLowerCase()) ||
              stock.kodeJenisProduk.toLowerCase().contains(query.toLowerCase()))
          .toList();
      isListVisible = true; // Show the list when there are results
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final textControllerProvider = context.watch<TextControllerProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: textControllerProvider.textController,
          onChanged: filterStocks,
          decoration: InputDecoration(
            labelText: 'Nama Barang',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.grey.shade100,
          ),
        ),
        const SizedBox(height: 10),
        // Display the filtered stocks in a ListView if the list is visible
        if (isListVisible && filteredStocks.isNotEmpty) ...[
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: filteredStocks.length,
              itemBuilder: (context, index) {
                final stock = filteredStocks[index];
                return ListTile(
                  title: Text(stock.namaStock),
                  onTap: () {
                    widget.onChanged(stock); // Notify the parent widget
                    textControllerProvider.textController.text =
                        stock.namaStock;
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
