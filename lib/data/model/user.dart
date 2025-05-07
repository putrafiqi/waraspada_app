import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.namaLengkap,
    required this.email,
    required this.profileUrl,
    required this.jenisKelamin,
    required this.usahaId,
    required this.role,
    required this.logoUrl,
    required this.namaUsaha,
    required this.alamatUsaha,
  });

  final String id;
  final String namaLengkap;
  final String jenisKelamin;
  final String email;
  final String profileUrl;
  final String usahaId;
  final String role;
  final String logoUrl;
  final String namaUsaha;
  final String alamatUsaha;

  @override
  List<Object?> get props => [
    id,
    namaLengkap,
    email,
    jenisKelamin,
    profileUrl,
    usahaId,
    role,
  ];
}
