import 'package:bonjour/Model/gudang_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GudangController with ChangeNotifier{
  final CollectionReference dbgudang = FirebaseFirestore.instance.collection('dbgudang');

  List<Gudang> dataGudang = [];
  List<Gudang> filteredGudang = [];
  bool fetching = false;
  bool processing = false;
 
  Future<void> fetchData() async {
    try {
      QuerySnapshot querySnapshot = await dbgudang.get();
      dataGudang = querySnapshot.docs
          .map((doc) => Gudang.fromJson({...doc.data() as Map<String, dynamic>, "docId": doc.id}))
          .toList();
      filteredGudang = List.from(dataGudang);
      print(filteredGudang);
      notifyListeners();
    } catch (e) {
      print("Error : $e");
    }
  }

  void filterStocks(String query) {
    if (query.isEmpty) {
      filteredGudang = List.from(dataGudang);
    } else {
      filteredGudang = dataGudang.where((stock) {
        return stock.namaGudang.toLowerCase().contains(query.toLowerCase()) ||
            stock.kodeGudang.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  Future<bool> addNewStock(Gudang gudang) async {
    processing = true;
    notifyListeners(); 
    try {
      Map<String, dynamic> stockdata = {...gudang.toJson()};
      await dbgudang.add(stockdata);
      processing = false;
      await fetchData();
      notifyListeners(); 
      return true;
    } catch (e) {
      print("Error : $e");
      processing = false;
      notifyListeners(); 
      return false;
    }
  }

  Future<bool> updateStock(Gudang gudang) async {
    processing = true;
    notifyListeners();
    try {
      Map<String, dynamic> updatedData = {...gudang.toJson()};
      await dbgudang.doc(gudang.docId).update(updatedData);
      await fetchData();
      processing = false;
      notifyListeners();
      return true;
    } catch (e) {
      print("Error : $e");
      processing = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteStock(String docId) async {
    processing = true;
    notifyListeners(); 
    try {
      await dbgudang.doc(docId).delete();
      await fetchData();
      processing = false;
      notifyListeners(); 
      return true;
    } catch (e) {
      print("Error : $e");
      processing = false;
      notifyListeners(); 
      return false;
    }
  }

}
