import 'package:bonjour/data.dart';
import 'package:flutter/material.dart';

class CreateGudangView extends StatefulWidget {
  const CreateGudangView({super.key});

  @override
  State<CreateGudangView> createState() => _CreateGudangViewState();
}

class _CreateGudangViewState extends State<CreateGudangView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Add Gudang'),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
    );
  }
}