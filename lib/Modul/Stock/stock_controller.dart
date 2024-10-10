import 'package:bonjour/Model/stock_model.dart';
import 'package:flutter/material.dart';

class StockController with ChangeNotifier{

  List dataStock = [];

  StockController() {
    for (int i = 1; i<21; i++) {
      String kode = "Kode-Stock-${i}";
      String nama = "Nama Stock ${i}";
      dataStock.add(Stock(kodeStock: kode, namaStock: nama));
    }
  }

  

}
