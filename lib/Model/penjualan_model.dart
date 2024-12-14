import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PenjualanBayar {
  String no_po;
  String customer;
  String tanggal;
  List<dynamic> item;
  double jumlah;
  bool status;
  bool bayar;
  String? docId;

  PenjualanBayar({
    required this.no_po, 
    required this.customer, 
    required this.tanggal, 
    required this.item, 
    required this.jumlah,
    required this.status,
    this.bayar = false,
    this.docId,
});

  factory PenjualanBayar.fromJson(Map<String, dynamic> json) {
    final timestamp = json['tanggal'];
    String formattedDate = "";

    // Check if 'tanggal' is a Timestamp and format it
    if (timestamp is Timestamp) {
      formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp.toDate());
    } else if (timestamp is String) {
      formattedDate = timestamp; // Assume it's already formatted
    }
    
    double total = 0;
    if (json['item'] is List) {
      (json['item'] as List<dynamic>).forEach((e) {
        total += e['jumlah barang'] * e['harga barang'];
      });
    }

    return PenjualanBayar(
      no_po: json['no_po'] as String, 
      customer: json['customer'] ?? "" as String,
      tanggal: formattedDate as String,
      jumlah: total as double,
      item: json['item'] as List<dynamic>,
      status: json['status'] as bool,
      bayar: json['bayar'] ?? false as bool,
      docId: json['docId'] ?? "" as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'no_po': no_po,
      'customer': customer,
      'tanggal': tanggal,
      'item': item,
      'status': status,
      'bayar': bayar,
    };
  }
}