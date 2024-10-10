class Gudang {
  String kodeGudang;
  String namaGudang;

  Gudang({
    required this.kodeGudang, 
    required this.namaGudang, 
});

  factory Gudang.fromJson(Map<String, dynamic> json) {
    return Gudang(
      kodeGudang: json['kodeGudang'] as String, 
      namaGudang: json['namaGudang'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kodeGudang': kodeGudang,
      'namaGudang': namaGudang,
    };
  }
}