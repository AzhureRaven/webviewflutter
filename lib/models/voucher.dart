import 'dart:convert';

class Voucher {
  final String kode;
  final String tgl;
  final String alias;
  final String tglFp;
  final String control;
  final String nmbank;
  final String nmsub;
  final String message;

  Voucher({
    required this.kode,
    required this.tgl,
    required this.alias,
    required this.tglFp,
    required this.control,
    required this.nmbank,
    required this.nmsub,
    required this.message,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      kode: json['kode'],
      tgl: json['tgl'],
      alias: json['alias'],
      tglFp: json['tgl_fp'],
      control: json['control'],
      nmbank: json['nmbank'],
      nmsub: json['nmsub'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kode'] = this.kode;
    data['tgl'] = this.tgl;
    data['alias'] = this.alias;
    data['tgl_fp'] = this.tglFp;
    data['control'] = this.control;
    data['nmbank'] = this.nmbank;
    data['nmsub'] = this.nmsub;
    data['message'] = this.message;
    return data;
  }
}


Voucher parseVoucher(String? json) {
  if (json == null) {
    return Voucher(kode: "", tgl: '', alias: '', tglFp: '', control: '', nmbank: '', nmsub: '', message: '');
  }
  final parsed = jsonDecode(json);
  return Voucher.fromJson(parsed);
}
