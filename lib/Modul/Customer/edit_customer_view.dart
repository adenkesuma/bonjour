import 'package:bonjour/Model/customer_model.dart';
import 'package:bonjour/Modul/Customer/customer_view.dart';
import 'package:bonjour/Provider/dbcust_provider.dart';
import 'package:bonjour/data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditCustomerView extends StatefulWidget {
  final Customer customer;

  const EditCustomerView({required this.customer});

  @override
  State<EditCustomerView> createState() => _EditCustomerViewState();
}

class _EditCustomerViewState extends State<EditCustomerView> {
  TextEditingController kodeController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController noTelpController = TextEditingController();  
  @override
  void initState() {
    super.initState();
    kodeController.text = widget.customer.kodeCustomer;
    namaController.text = widget.customer.namaCustomer;
    emailController.text = widget.customer.email ?? "";
    alamatController.text = widget.customer.alamat ?? "";
    noTelpController.text = widget.customer.noTelp ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final provCust = Provider.of<CustomerProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Edit Customer'),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              readOnly: true,
              controller: kodeController,
              decoration: InputDecoration(
                labelText: 'Kode Customer',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1.0,
                  ),
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 2.0,
                  ),
                ),
                labelStyle: TextStyle(
                  color: Colors.grey.shade600,
                ),
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                ),
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
                    provCust.updateCustomer(Customer(kodeCustomer: kodeController.text, namaCustomer: namaController.text, email: emailController.text, alamat: alamatController.text, noTelp: noTelpController.text));
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => CustomerView()),
                        (Route<dynamic> route) => false);
              },
              child: Text('Edit Customer'),
            ),
          ],
        ),
      ),
    );
  }
}