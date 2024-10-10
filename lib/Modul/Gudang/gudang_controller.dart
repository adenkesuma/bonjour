import 'package:bonjour/Model/gudang_model.dart';
import 'package:flutter/material.dart';

class GudangController with ChangeNotifier{

  List dataGudang = [];

  GudangController () {
    for (int i = 1; i<3; i++) {
      String kode = "KodeGudang${i}";
      String nama = "Gudang ${i}";
      dataGudang.add(Gudang(kodeGudang: kode, namaGudang: nama));
    }
  }

}
