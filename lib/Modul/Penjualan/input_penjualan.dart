import 'package:bonjour/database/firebase_control.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  DateTime? selectedDate;
  final TextEditingController noPoController = TextEditingController();
  bool isStatusActive = false;

  final TextEditingController hargaBarangController = TextEditingController();
  final TextEditingController jumlahBarangController = TextEditingController();
  final TextEditingController namaBarangController = TextEditingController();
  final TextEditingController totalController = TextEditingController();
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
      appBar: AppBar(
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
                  ),
                ],
              ),
              const SizedBox(height: 10),
              buildInputField(
                label: 'No PO',
                controller: noPoController,
                hintText: 'Masukkan No PO',
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: isStatusActive,
                    onChanged: (bool? value) {
                      setState(() {
                        isStatusActive = value ?? false;
                      });
                    },
                  ),
                  Text('Status Aktif'),
                ],
              ),
              const SizedBox(height: 10),
              buildItemForm(),
              const SizedBox(height: 10),
              buildItemList(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
    );
  }

  Widget buildNumericField({
    required String label,
    required TextEditingController controller,
    required String hintText,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.blue),
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
            buildInputField(
              label: 'Nama Barang',
              controller: namaBarangController,
              hintText: 'Masukkan Nama Barang',
            ),
            const SizedBox(height: 10),
            buildNumericField(
              label: 'Jumlah Barang',
              controller: jumlahBarangController,
              hintText: 'Masukkan Jumlah Barang',
            ),
            const SizedBox(height: 10),
            buildNumericField(
              label: 'Harga Barang',
              controller: hargaBarangController,
              hintText: 'Masukkan Harga Barang',
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  items.add(Item(
                    namaBarang: namaBarangController.text,
                    jumlahBarang:
                        int.tryParse(jumlahBarangController.text) ?? 0,
                    hargaBarang: int.tryParse(hargaBarangController.text) ?? 0,
                    total: (int.tryParse(jumlahBarangController.text) ?? 0) *
                        (int.tryParse(hargaBarangController.text) ?? 0),
                  ));

                  namaBarangController.clear();
                  jumlahBarangController.clear();
                  hargaBarangController.clear();
                });
              },
              child: Text('Tambah Item'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (noPoController.text.isEmpty ||
                    selectedDate == null ||
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
                  // Konversi items ke format list of maps
                  List<Map<String, dynamic>> itemData = items.map((item) {
                    return {
                      'harga barang': item.hargaBarang,
                      'jumlah barang': item.jumlahBarang,
                      'nama barang': item.namaBarang,
                      'total': item.total,
                    };
                  }).toList();

                  print(itemData);
                  // Kirim ke Firebase
                  Firebase_penjualan().addPenjualan(
                    "1",
                    selectedDate!,
                    noPoController.text,
                    isStatusActive.toString(),
                    itemData, // Tidak perlu membungkus dengan []
                  );
                  print(itemData);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Data berhasil disimpan')),
                  );

                  // Reset form
                  setState(() {
                    noPoController.clear();
                    isStatusActive = false;
                    selectedDate = null;
                    // items.clear();
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal menyimpan data: $e')),
                  );
                }
              },
              child: Text('Simpan'),
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
}
