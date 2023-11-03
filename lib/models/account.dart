import 'dart:convert';

class Account {
  final String kode;
  final String? nama;
  final String? jenis;
  final String? username;

  Account({
    required this.kode,
    this.nama,
    this.jenis,
    this.username
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      kode: json['kode'],
      nama: json['nama'],
      jenis: json['jenis'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kode'] = this.kode;
    data['nama'] = this.nama;
    data['jenis'] = this.jenis;
    data['username'] = this.username;
    return data;
  }
}

Account parseAccount(String? json) {
  if (json == null) {
    return Account(kode: "");
  }
  final parsed = jsonDecode(json);
  return Account.fromJson(parsed);
}
