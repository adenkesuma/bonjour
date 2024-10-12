import 'package:flutter/material.dart';
import 'package:bonjour/data.dart';

class CreateStockView extends StatefulWidget {
  const CreateStockView({Key? key}) : super(key: key);

  @override
  State<CreateStockView> createState() => _CreateStockViewState();
}

class _CreateStockViewState extends State<CreateStockView> {
  late TextEditingController kodeStock;
  late TextEditingController namaStock;
  late TextEditingController kodeJenisProduk;
  late TextEditingController satuan;
  late TextEditingController deskripsi;
  late TextEditingController hargaJual;
  late TextEditingController hargaBeli;
  late TextEditingController hargaMinimum;
  late TextEditingController saldoAwal;

  int aktif = 1;

  @override
  void initState() {
    super.initState();
    kodeStock = TextEditingController(text: '');
    namaStock = TextEditingController(text: '');
    kodeJenisProduk = TextEditingController(text: '');
    satuan = TextEditingController(text: '');
    deskripsi = TextEditingController(text: '');
    hargaJual = TextEditingController(text: '0');
    hargaBeli = TextEditingController(text: '0'); 
    hargaMinimum = TextEditingController(text: '0'); 
    saldoAwal = TextEditingController(text: '0'); 
  }

  @override
  void dispose() {
    kodeStock.dispose();
    namaStock.dispose();
    kodeJenisProduk.dispose();
    satuan.dispose();
    deskripsi.dispose();
    hargaJual.dispose();
    hargaBeli.dispose();
    hargaMinimum.dispose();
    saldoAwal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Add Stock'),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Kode Stock'),
                controller: kodeStock,
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(labelText: 'Nama Stock'),
                controller: namaStock,
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(labelText: 'Kode Jenis Produk'),
                controller: kodeJenisProduk,
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(labelText: 'Satuan'),
                controller: satuan,
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(labelText: 'Deskripsi'),
                controller: deskripsi,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text('Status Stock'),
                  SizedBox(width: 10,),
                  Switch(
                    value: aktif == 1,
                    onChanged: (value) {
                      setState(() {
                        aktif = value ? 1 : 0;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(labelText: 'Harga Jual'),
                keyboardType: TextInputType.number,
                controller: hargaJual,
                onChanged: (value) {
                  setState(() {
                    hargaJual.text = value;
                  });
                },
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(labelText: 'Harga Beli'),
                keyboardType: TextInputType.number,
                controller: hargaBeli,
                onChanged: (value) {
                  setState(() {
                    hargaBeli.text = value;
                  });
                },
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(labelText: 'Harga Minimum'),
                keyboardType: TextInputType.number,
                controller: hargaMinimum,
                onChanged: (value) {
                  setState(() {
                    hargaMinimum.text = value;
                  });
                },
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(labelText: 'Saldo Awal'),
                keyboardType: TextInputType.number,
                controller: saldoAwal,
                onChanged: (value) {
                  setState(() {
                    saldoAwal.text = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
