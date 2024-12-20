import 'package:bonjour/Modul/Pembelian/inputpembelian.dart';
import 'package:bonjour/Modul/Pembelian/showdialog_pembelian.dart';
import 'package:bonjour/data.dart';
import 'package:bonjour/database/firebase_control.dart';
import 'package:bonjour/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class PembelianView extends StatefulWidget {
  const PembelianView({super.key});

  @override
  State<PembelianView> createState() => _PenjualanViewState();
}

class _PenjualanViewState extends State<PembelianView> {
  List<Map<String, dynamic>> _PembelianData = [];
  bool _isLoading = true; // Untuk menampilkan indikator loading
  String _searchQuery = '';
  List<Map<String, dynamic>> _filteredPembelian = [];

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  void _showItemDialog(List<Map<String, dynamic>>? items) {
    if (items == null || items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak ada item untuk ditampilkan')),
      );
      return;
    }

    void editItem(Map<String, dynamic> item) {
      print('Edit item: $item');
      // Tambahkan logika pengeditan di sini
    }

    void deleteItem(Map<String, dynamic> item) async {
      print('Delete item: $item');

      try {
        String namaBarang = item['nama barang'];
        print('Nama Barang: $namaBarang');

        // Ambil semua dokumen dari koleksi dbpembelian
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('dbpembelian')
            .get(); // Mengambil seluruh koleksi tanpa filter

        if (querySnapshot.docs.isNotEmpty) {
          for (var docSnapshot in querySnapshot.docs) {
            List<dynamic> items =
                docSnapshot['item']; // Ambil list item dari dokumen

            // Debugging: Menampilkan isi dari list items sebelum diubah
            print('Items di dokumen sebelum diubah: $items');

            // Cek jika item ada dalam list dan nama barang sesuai
            bool itemFound = false;
            for (var mapItem in items) {
              if (mapItem['nama barang'] == namaBarang) {
                // Hapus item yang sesuai dengan nama barang
                items.remove(mapItem);
                itemFound = true;
                _loadPembelian();
                break;
              }
            }

            if (itemFound) {
              // Update dokumen jika item ditemukan dan dihapus
              await FirebaseFirestore.instance
                  .collection('dbpembelian')
                  .doc(docSnapshot.id) // Mendapatkan ID dokumen
                  .update({
                'item':
                    items, // Update array 'item' dengan array yang sudah diubah
              });

              // Jika tidak ada item tersisa, hapus dokumen PO
              if (items.isEmpty) {
                await FirebaseFirestore.instance
                    .collection('dbpembelian')
                    .doc(docSnapshot.id)
                    .delete(); // Hapus dokumen PO
                _loadPembelian();
                print(
                    'Dokumen PO dengan kode Beli ${docSnapshot['kodeBeli']} telah dihapus');
              }

              // Hapus item dari list lokal

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Item berhasil dihapus dari Firestore')),
              );
              return; // Hentikan loop jika item sudah dihapus
            }
          }

          // Jika item tidak ditemukan di semua dokumen
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Item tidak ditemukan di Firestore')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tidak ada dokumen di Firestore')),
          );
        }
      } catch (e) {
        print('Error deleting item: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus item')),
        );
      }
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

  Future<void> _loadPembelian() async {
    try {
      List<Map<String, dynamic>> data =
          await Firebase_penjualan().readpembelian();
      setState(() {
        _PembelianData = data;
        _filteredPembelian = data; // Inisialisasi data yang akan ditampilkan
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterData(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredPembelian = _PembelianData;
      } else {
        _filteredPembelian = _PembelianData.where((item) => item['kodeBeli']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase())).toList();
      }
    });
  }

 

  @override
  void initState() {
    super.initState();
    
    _loadPembelian();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(AppLocalizations.of(context)!.pembelian),
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                await Get.to(Inputpembelian());
                _loadPembelian();
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
                      hintText: 'Cari pembelian berdasarkan Kode pembelian',
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
                      : _filteredPembelian.isEmpty
                          ? Center(child: Text('Tidak ada data pembelian'))
                          : ListView.builder(
                              itemCount: _filteredPembelian.length,
                              itemBuilder: (context, index) {
                                final item = _filteredPembelian[index];

                                return Padding(
                                  padding: const EdgeInsets.all(12.0),
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
                                              Text(
                                                  'No. PO: ${item['kodeBeli']}'),
                                              Text(
                                                  'Tanggal: ${formatTimestamp(item['Tanggal'])}'),
                                              Text(
                                                  'Supplier: ${item['Supplier']}'),
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
