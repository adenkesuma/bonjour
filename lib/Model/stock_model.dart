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
  double saldoAwal;
  String img;

  Stock({
    required this.kodeStock,
    required this.namaStock,
    required this.kodeJenisProduk,
    required this.satuan,
    this.deskripsi,
    required this.aktif,
    this.hargaJual = 0,
    this.hargaBeli = 0,
    this.hargaMinimum = 0,
    this.saldoAwal = 0,
    this.img = '',
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      kodeStock: json['KODE_STOCK'] as String,
      namaStock: json['NAMA_STOCK'] as String,
      kodeJenisProduk: json['KODE_PRODUK'] as String,
      satuan: json['SATUAN'] as String,
      deskripsi: json['DESKRIPSI'] as String?,
      aktif: json['AKTIF'] as int,
      hargaJual: (json['HARGA_JUAL'])?.toDouble() ?? 0.0,
      hargaBeli: (json['HARGA_BELI'])?.toDouble() ?? 0.0,
      hargaMinimum: (json['HARGA_MINIMUM'])?.toDouble() ?? 0.0,
      saldoAwal: (json['STOCK_AWAL'])?.toDouble() ?? 0.0,
      img: json['IMAGE'] as String? ?? "",
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
      'img': img,
    };
  }
}

class Product {
  final String kodeStock;
  final String namaStock;
  final String kodeProduk;
  final String satuan;
  final double hargaBeli;
  final double hargaMinimum;
  final String deskripsi;
  final double hargaJual;
  final int aktif;

  Product({
    required this.kodeStock,
    required this.namaStock,
    required this.kodeProduk,
    required this.satuan,
    required this.hargaBeli,
    required this.hargaMinimum,
    required this.deskripsi,
    required this.hargaJual,
    required this.aktif,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      kodeStock: json['KODE_STOCK'],
      namaStock: json['NAMA_STOCK'],
      kodeProduk: json['KODE_PRODUK'],
      satuan: json['SATUAN'],
      hargaBeli: json['HARGA_BELI'].toDouble(),
      hargaMinimum: json['HARGA_MINIMUM'].toDouble(),
      deskripsi: json['DESKRIPSI'],
      hargaJual: json['HARGA_JUAL'].toDouble(),
      aktif: json['AKTIF'],
    );
  }
}
