import 'package:bonjour/Model/customer_model.dart';
import 'package:bonjour/Model/stock_model.dart';
import 'package:bonjour/Modul/Customer/customer_controller.dart';
import 'package:bonjour/Modul/Penjualan/inputform.dart';
import 'package:bonjour/Modul/Penjualan/pemilihan_stock.dart';
import 'package:bonjour/Modul/Penjualan/searchbar.dart';
import 'package:bonjour/Provider/dbcust_provider.dart';
import 'package:bonjour/data.dart';
import 'package:bonjour/database/firebase_control.dart';
import 'package:bonjour/drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Item {
  String namaBarang;
  int jumlahBarang;
  int hargaBarang;
  int total;

  Item({
    required this.namaBarang,
    required this.jumlahBarang,
    required this.hargaBarang,
    required this.total,
  });
}

class InputPenjualan extends StatefulWidget {
  @override
  State<InputPenjualan> createState() => inputPenjualan();
}

class inputPenjualan extends State<InputPenjualan> {
  Customer? selectedCustomer;
  Stock? selectedStock;
  bool isppn = false;
  DateTime? selectedDate = DateTime.now();
  final TextEditingController noPoController = TextEditingController();
  final TextEditingController hargaBarangController = TextEditingController();
  final TextEditingController jumlahBarangController = TextEditingController();
  final TextEditingController namaBarangController = TextEditingController();
  final firebase_storage = Firebase_penjualan();
  List<Item> items = [];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: MainDrawer(),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<TextControllerProvider>().clearText();
            Navigator.of(context).pop(); // Navigate back
          },
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text('Tambah Purchase Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedDate == null
                          ? 'Pilih Tanggal'
                          : DateFormat('yyyy-MM-dd').format(selectedDate!),
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Pilih Tanggal'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8.0), // Atur border radius di sini
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 20.0), // Atur padding sesuai kebutuhan
                      backgroundColor:
                          primaryColor, // Atur warna latar belakang tombol
                      foregroundColor: Colors.white, // Atur warna teks tombol
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SearchableCustomerList(
                selectedCustomer: selectedCustomer,
                onChanged: (Customer? newValue) {
                  setState(() {
                    selectedCustomer = newValue;
                  });
                },
              ),
              const SizedBox(height: 10),
              buildInputField(
                label: 'No PO',
                controller: noPoController,
                hintText: 'Masukkan No PO',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'No PO harus diisi';
                  }
                  return null; // Return null if the input is valid
                },
              ),
              const SizedBox(height: 10),
              buildItemForm(),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: showItemListDialog,
                child: Text('Tampilkan Daftar Item'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItemForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SearchableStockList(
              selectedStock: selectedStock,
              onChanged: (Stock? stock) {
                setState(() {
                  selectedStock = stock;
                  namaBarangController.text = stock?.namaStock ?? '';
                });
              },
            ),
            const SizedBox(height: 10),
            buildNumericField(
              label: 'Jumlah Barang',
              controller: jumlahBarangController,
              hintText: 'Masukkan Jumlah Barang',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Jumlah Barang harus diisi';
                }
                return null; // Return null if the input is valid
              },
            ),
            const SizedBox(height: 10),
            buildNumericField(
              label: 'Harga Barang',
              controller: hargaBarangController,
              hintText: 'Masukkan Harga Barang',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Harga barang harus diisi';
                }
                return null; // Return null if the input is valid
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: isppn,
                  onChanged: (bool? value) {
                    setState(() {
                      isppn = value ?? false;
                    });
                  },
                ),
                Text('PPN'),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  if (jumlahBarangController.text.isEmpty ||
                      hargaBarangController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Semua field harus diisi sebelum menambah item'),
                      ),
                    );
                    return; // Exit if validation fails
                  } else if (namaBarangController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Pilih sesuai dengan nama stok yang terdaftar'),
                      ),
                    );
                    return; // Exit if validation fails
                  }
                  setState(() {
                    items.add(Item(
                      namaBarang: namaBarangController.text,
                      jumlahBarang:
                          int.tryParse(jumlahBarangController.text) ?? 0,
                      hargaBarang:
                          int.tryParse(hargaBarangController.text) ?? 0,
                      total: (int.tryParse(jumlahBarangController.text) ?? 0) *
                          (int.tryParse(hargaBarangController.text) ?? 0),
                    ));
                    context.read<TextControllerProvider>().clearText();

                    selectedStock = null;
                    namaBarangController.clear();
                    jumlahBarangController.clear();
                    hargaBarangController.clear();
                  });
                },
                child: Text('Tambah Item'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedDate == null ||
                      selectedCustomer == null ||
                      items.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Harap lengkapi semua data sebelum menyimpan'),
                      ),
                    );
                    return;
                  }

                  try {
                    List<Map<String, dynamic>> itemData = items.map((item) {
                      return {
                        'harga barang': item.hargaBarang,
                        'jumlah barang': item.jumlahBarang,
                        'nama barang': item.namaBarang,
                        'total': item.total,
                      };
                    }).toList();

                    // Kirim ke Firebase
                    Firebase_penjualan().addPenjualan(
                      selectedCustomer!.namaCustomer,
                      selectedDate!,
                      noPoController.text,
                      isppn.toString(),
                      itemData, // Tidak perlu membungkus dengan []
                    );
                    print(itemData);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Data berhasil disimpan')),
                    );

                    // Reset form
                    setState(() {
                      noPoController.clear();
                      isppn = false;
                      selectedDate = null;
                      items.clear();
                      selectedCustomer = null; // Reset selected customer
                    });

                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal menyimpan data: $e')),
                    );
                  }
                },
                child: Text('Simpan'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8.0), // Atur border radius di sini
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 20.0), // Atur padding sesuai kebutuhan
                  backgroundColor:
                      primaryColor, // Atur warna latar belakang tombol
                  foregroundColor: Colors.white, // Atur warna teks tombol
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItemList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          title: Text(item.namaBarang),
          subtitle: Text(
              'Jumlah: ${item.jumlahBarang} x ${item.hargaBarang} = ${item.total}'),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              setState(() {
                items.removeAt(index);
              });
            },
          ),
        );
      },
    );
  }

  void showItemListDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Daftar Item'),
          content: Container(
            width: double.maxFinite, // Memastikan dialog cukup lebar
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(item.namaBarang),
                  subtitle: Text(
                      'Jumlah: ${item.jumlahBarang} x ${item.hargaBarang} = ${item.total}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        items.removeAt(index);
                      });
                      Navigator.of(context)
                          .pop(); // Tutup dialog setelah menghapus
                      showItemListDialog(); // Tampilkan kembali dialog untuk memperbarui daftar
                    },
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
}
