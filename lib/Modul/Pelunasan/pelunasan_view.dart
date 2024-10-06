import 'package:bonjour/data.dart';
import 'package:bonjour/drawer.dart';
import 'package:flutter/material.dart';

class PelunasanView extends StatefulWidget {
  const PelunasanView({super.key});

  @override
  State<PelunasanView> createState() => _PelunasanViewState();
}

class _PelunasanViewState extends State<PelunasanView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Pelunasan'),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      drawer: MainDrawer(),
      body: Center(
        child: Text('Pelunasan'),
      ),
    );
  }
}