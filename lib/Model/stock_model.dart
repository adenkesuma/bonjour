class Stock {
  String kodeStock;
  String namaStock;
  String kodeJenisProduk;
  String satuan;
  String? deskripsi;
  int aktif;
  double? hargaJual;
  double? hargaBeli;
  double? hargaMinimum;
  int saldoAwal;

  Stock({
    required this.kodeStock, 
    required this.namaStock, 
    required this.kodeJenisProduk,
    required this.satuan,
    this.deskripsi,
    required this.aktif,
    this.hargaJual,
    this.hargaBeli,
    this.hargaMinimum,
    this.saldoAwal = 0,
});

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      kodeStock: json['kodeStock'] as String, 
      namaStock: json['namaStock'] as String,
      kodeJenisProduk: json['kodeJenisProduk'] as String,
      satuan: json['satuan'] as String,
      deskripsi: json['deskripsi'] as String,
      aktif: json['aktif'] as int,
      hargaJual: json['hargaJual'] as double?, 
      hargaBeli: json['hargaBeli'] as double?, 
      hargaMinimum: json['hargaMinimum'] as double?,
      saldoAwal: json['saldoAwal'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kodeStock': kodeStock,
      'namaStock': namaStock,
      'kodeJenisProduk': kodeJenisProduk,
      'satuan': satuan,
      'deskripsi': deskripsi,
      'aktif': aktif,
      'hargaJual': hargaJual,
      'hargaBeli': hargaBeli,
      'hargaMinimum': hargaMinimum,
      'saldoAwal': saldoAwal,
    };
  }
}