class Gudang {
  String kodeGudang;
  String namaGudang;
  String? alamat;
  String? kepalaGudang;
  int aktif;

  Gudang({
    required this.kodeGudang, 
    required this.namaGudang, 
    this.alamat, 
    this.kepalaGudang, 
    required this.aktif, 
});

  factory Gudang.fromJson(Map<String, dynamic> json) {
    return Gudang(
      kodeGudang: json['kodeGudang'] as String, 
      namaGudang: json['namaGudang'] as String,
      alamat: json['alamat'] as String,
      kepalaGudang: json['kepalaGudang'] as String,
      aktif: json['aktif'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kodeGudang': kodeGudang,
      'namaGudang': namaGudang,
      'alamat': alamat,
      'kepalaGudang': kepalaGudang,
      'aktif': aktif,
    };
  }
}