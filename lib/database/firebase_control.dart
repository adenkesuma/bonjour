import 'package:cloud_firestore/cloud_firestore.dart';

class Firebase_penjualan {
  final CollectionReference penjualan =
      FirebaseFirestore.instance.collection('dbpenjualan');

  Future<void> addPenjualan(String customer, DateTime tanggal, String noPo,
    String status, List<Map<String, dynamic>> items) async {
  try {
    await penjualan.add({
      'customer': customer,
      'tanggal': tanggal,
      'no_po': noPo,
      'status': status,
      'item': items, // Simpan langsung seluruh list
    });
    print('Data berhasil ditambahkan');
  } catch (e) {
    print('Gagal menambahkan data: $e');
  }
}

  Future<List<Map<String, dynamic>>> readPenjualan() async {
    List<Map<String, dynamic>> Polist = [];
    try {
      QuerySnapshot data = await penjualan.get();
      data.docs.forEach((ele) {
        Polist.add(ele.data() as Map<String, dynamic>);
      });
      return Polist;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> updateMhs(
      String nama, String kelas, String nim, bool gender) async {
    try {
      await penjualan.doc(nama).update({
        'nama': nama,
        'kelas': kelas,
        'nim': nim,
        'gender': gender,
      });
    } catch (e) {
      print('Error updating penjualan: $e');
    }
  }

  // Metode delete dengan ID dokumen spesifik
  Future<void> deleteMhs(String docId) async {
    try {
      await penjualan.doc(docId).delete();
    } catch (e) {
      print('Error deleting penjualan: $e');
    }
  }
}
