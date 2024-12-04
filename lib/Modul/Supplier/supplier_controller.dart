import 'package:bonjour/Model/supplier_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SupplierController with ChangeNotifier{
  final CollectionReference dbsupplier = FirebaseFirestore.instance.collection('dbsupplier');

  List<Supplier> dataSupplier = [];
  List<Supplier> filteredSupplier = [];
  bool fetching = false;
  bool processing = false;
 
  Future<void> fetchData() async {
    try {
      QuerySnapshot querySnapshot = await dbsupplier.get();
      dataSupplier = querySnapshot.docs
          .map((doc) => Supplier.fromJson({...doc.data() as Map<String, dynamic>, "docId": doc.id}))
          .toList();
      filteredSupplier = List.from(dataSupplier);
      print(filteredSupplier);
      notifyListeners();
    } catch (e) {
      print("Error : $e");
    }
  }

  void filterSupplier(String query) {
    if (query.isEmpty) {
      filteredSupplier = List.from(dataSupplier);
    } else {
      filteredSupplier = dataSupplier.where((supplier) {
        return supplier.namaSupplier.toLowerCase().contains(query.toLowerCase()) ||
            supplier.kodeSupplier.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  Future<bool> addNewSupplier(Supplier supplier) async {
    processing = true;
    notifyListeners(); 
    try {
      Map<String, dynamic> supplierData = {...supplier.toJson()};
      await dbsupplier.add(supplierData);
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

  Future<bool> updateSupplier(Supplier supplier) async {
    processing = true;
    notifyListeners();
    try {
      Map<String, dynamic> updatedData = {...supplier.toJson()};
      await dbsupplier.doc(supplier.docId).update(updatedData);
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

  Future<bool> deleteSupplier(String docId) async {
    processing = true;
    notifyListeners(); 
    try {
      await dbsupplier.doc(docId).delete();
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
