import 'package:equatable/equatable.dart';

class Karyawan extends Equatable {
  final String? id;
  final String? namaLengkap;
  final String email;
  final String? jenisKelamin;
  final String? profileUrl;
  final bool undanganStatus;

  const Karyawan({
    this.jenisKelamin,
    this.namaLengkap,
    required this.email,
    this.profileUrl,
    required this.undanganStatus,
    this.id,
  });

  factory Karyawan.fromJson(Map<String, dynamic> json) {
    return Karyawan(
      id: json['id'] as String?,
      jenisKelamin: json['jenis_kelamin'] as String?,
      namaLengkap: json['nama_lengkap'] as String?,
      email: json['email'] as String,
      profileUrl: json['profile_url'] as String?,
      undanganStatus: json['undangan_status'] as bool,
    );
  }

  @override
  List<Object?> get props => [email, undanganStatus];
}
