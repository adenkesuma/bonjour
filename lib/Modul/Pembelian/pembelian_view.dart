import 'package:bonjour/data.dart';
import 'package:bonjour/drawer.dart';
import 'package:flutter/material.dart';

class PembelianView extends StatefulWidget {
  const PembelianView({super.key});

  @override
  State<PembelianView> createState() => _PembelianViewState();
}

class _PembelianViewState extends State<PembelianView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Pembelian'),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      drawer: MainDrawer(),
      body: Center(
        child: Text('Pembelian'),
      ),
    );
  }
}