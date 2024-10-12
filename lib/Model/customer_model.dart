class Customer {
  String kodeCustomer;
  String namaCustomer;
  String? email;
  String? alamat;
  String? noTelp;

  Customer({
    required this.kodeCustomer, 
    required this.namaCustomer, 
    this.email, 
    this.alamat, 
    this.noTelp, 
});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      kodeCustomer: json['kodeCustomer'] as String, 
      namaCustomer: json['namaCustomer'] as String,
      email: json['email'] as String,
      alamat: json['alamat'] as String,
      noTelp: json['noTelp'] as String,      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kodeCustomer': kodeCustomer,
      'namaCustomer': namaCustomer,
      'email': email,      
      'alamat': alamat,
      'noTelp': noTelp,
    };
  }
}