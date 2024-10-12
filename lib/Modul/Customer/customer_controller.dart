import 'package:bonjour/Model/customer_model.dart';
import 'package:flutter/material.dart';

class CustomerController with ChangeNotifier{

  List dataCustomer = [];

  CustomerController () {
    for (int i = 1; i<3; i++) {
      String kode = "KodeCustomer${i}";
      String nama = "Customer ${i}";
      dataCustomer.add(Customer(kodeCustomer: kode, namaCustomer: nama));
    }
  }

}
