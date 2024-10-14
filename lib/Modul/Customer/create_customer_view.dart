import 'package:bonjour/data.dart';
import 'package:flutter/material.dart';

class CreateCustomerView extends StatefulWidget {
  const CreateCustomerView({super.key});

  @override
  State<CreateCustomerView> createState() => _CreateCustomerViewState();
}

class _CreateCustomerViewState extends State<CreateCustomerView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Add Customer'),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
    );
  }
}