import 'package:bonjour/data.dart';
import 'package:bonjour/drawer.dart';
import 'package:flutter/material.dart';

class PenjualanView extends StatefulWidget {
  const PenjualanView({super.key});

  @override
  State<PenjualanView> createState() => _PenjualanViewState();
}

class _PenjualanViewState extends State<PenjualanView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Penjualan'),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      drawer: MainDrawer(),
      body: Center(
        child: Text('Penjualan'),
      ),
    );
  }
}