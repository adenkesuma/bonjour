import 'package:bonjour/Modul/Pembelian/showdialog_pembelian.dart';
import 'package:bonjour/Modul/Penjualan/input_penjualan.dart';
import 'package:bonjour/data.dart';
import 'package:bonjour/database/firebase_control.dart';
import 'package:bonjour/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PenjualanView extends StatefulWidget {
  const PenjualanView({super.key});

  @override
  State<PenjualanView> createState() => _PenjualanViewState();
}

class _PenjualanViewState extends State<PenjualanView> {
  List<Map<String, dynamic>> _penjualanData = [];
  bool _isLoading = true; // Untuk menampilkan indikator loading
  String _searchQuery = '';
  List<Map<String, dynamic>> _filteredPenjualanData = [];

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  Future<void> _loadPenjualanData() async {
    try {
      List<Map<String, dynamic>> data =
          await Firebase_penjualan().readPenjualan();

      // Filter data: hanya tampilkan jika 'bayar' != true
      List<Map<String, dynamic>> filteredData = data.where((item) {
        final bayar = item['bayar'] ?? false; // Nilai default false jika null
        return bayar == false; // Hanya data dengan bayar == false
      }).toList();

      setState(() {
        _penjualanData = filteredData; // Simpan data yang sudah difilter
        _filteredPenjualanData =
            filteredData; // Inisialisasi data yang ditampilkan
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showItemDialog(List<Map<String, dynamic>>? items) {
    if (items == null || items.isEmpty) {
      // Tampilkan pesan jika tidak ada item
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak ada item untuk ditampilkan')),
      );
      return;
    }
    void editItem(Map<String, dynamic> item) {
      print('Edit item: $item');
      // Tambahkan logika pengeditan di sini
    }

    void deleteItem(Map<String, dynamic> item) {
      print('Delete item: $item');
      // Tambahkan logika penghapusan di sini
    }

    showDialog(
      context: context,
      builder: (context) {
        return ItemDialog(
          items: items,
          onEdit: editItem,
          onDelete: deleteItem,
        );
      },
    );
  }

  void _filterData(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredPenjualanData = _penjualanData;
      } else {
        _filteredPenjualanData = _penjualanData.where((item) {
          print(item['bayar']);
          print('Bayar: ${item['bayar']}');
          final noPoMatch = item['no_po']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase());
          final bayarCondition = item['bayar'] == true; // Debug
          print('NoPoMatch: $noPoMatch, BayarCondition: $bayarCondition');
          return noPoMatch && !bayarCondition; // Negasi untuk exclude true
        }).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPenjualanData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(AppLocalizations.of(context)!.penjualan),
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                await Get.to(InputPenjualan());
                _loadPenjualanData();
                // await Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => InputPenjualan()));
                // _loadPenjualanData();
              },
              icon: Icon(Icons.add))
        ],
      ),
      drawer: MainDrawer(),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              // First Container with Shadow
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  height: 170,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Search Bar
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: TextField(
                    onChanged: _filterData, // Panggil fungsi filter
                    decoration: InputDecoration(
                      hintText: 'Cari Penjualan berdasarkan No. PO...',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),
                ),
              ),

              // Scrollable Card List
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: 500,
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : _filteredPenjualanData.isEmpty
                          ? Center(child: Text('Tidak ada data penjualan'))
                          : ListView.builder(
                              itemCount: _filteredPenjualanData.length,
                              itemBuilder: (context, index) {
                                final item = _filteredPenjualanData[index];
                                String formattedDate =
                                    formatTimestamp(item['tanggal']);

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      print('item: ${item['item']}');
                                      final List<Map<String, dynamic>> items =
                                          (item['item'] as List<dynamic>)
                                              .map((e) =>
                                                  Map<String, dynamic>.from(e))
                                              .toList();
                                      _showItemDialog(items);
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 5,
                                            offset: Offset(0, 2),
                                          )
                                        ],
                                      ),
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('No. PO: ${item['no_po']}'),
                                              Text('Tanggal: ${formattedDate}'),
                                              Text(
                                                  'Customer: ${item['customer']}'),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
