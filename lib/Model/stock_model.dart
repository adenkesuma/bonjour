class Stock {
  String kodeStock;
  String namaStock;
  double? hargaJual;
  double? hargaBeli;
  double? hargaMinimum;
  int sisaStock;

  Stock({
    required this.kodeStock, 
    required this.namaStock, 
    this.hargaJual,
    this.hargaBeli,
    this.hargaMinimum,
    this.sisaStock = 0,
});

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      kodeStock: json['kodeStock'] as String, 
      namaStock: json['namaStock'] as String,
      hargaJual: json['hargaJual'] as double?, 
      hargaBeli: json['hargaBeli'] as double?, 
      hargaMinimum: json['hargaMinimum'] as double?,
      sisaStock: json['sisaStock'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kodeStock': kodeStock,
      'namaStock': namaStock,
      'hargaJual': hargaJual,
      'hargaBeli': hargaBeli,
      'hargaMinimum': hargaMinimum,
      'sisaStock': sisaStock,
    };
  }
}