import 'package:bonjour/Model/customer_model.dart';
import 'package:bonjour/Modul/Customer/customer_view.dart';
import 'package:bonjour/Provider/dbcust_provider.dart';
import 'package:bonjour/data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateCustomerView extends StatefulWidget {
  const CreateCustomerView({super.key});

  @override
  State<CreateCustomerView> createState() => _CreateCustomerViewState();
}

class _CreateCustomerViewState extends State<CreateCustomerView> {
  final TextEditingController kodeController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController noTelpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final provCust = Provider.of<CustomerProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Add Customer'),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: kodeController,
              decoration: InputDecoration(
                labelText: 'Kode Customer',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: namaController,
              decoration: InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 10),
            TextField(
              controller: alamatController,
              decoration: InputDecoration(
                labelText: 'Alamat',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: noTelpController,
              decoration: InputDecoration(
                labelText: 'No. Telepon',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                provCust.addCustomer(Customer(
                    kodeCustomer: kodeController.text,
                    namaCustomer: namaController.text,
                    email: emailController.text,
                    alamat: alamatController.text,
                    noTelp: noTelpController.text));
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => CustomerView()),
                    (Route<dynamic> route) => false);
              },
              child: Text('Tambah Customer'),
            ),
          ],
        ),
      ),
    );
  }
}
