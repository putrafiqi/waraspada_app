import 'package:equatable/equatable.dart';

class DistribusiTingkatStres extends Equatable {
  final String kateogri;
  final int jumlah;

  const DistribusiTingkatStres({required this.kateogri, required this.jumlah});

  factory DistribusiTingkatStres.fromJson(Map<String, dynamic> json) {
    return DistribusiTingkatStres(
      kateogri: json['kategori'] as String,
      jumlah: json['jumlah'] as int,
    );
  }

  @override
  List<Object?> get props => [kateogri, jumlah];
}
