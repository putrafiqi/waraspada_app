import 'package:equatable/equatable.dart';

class TingkatStresKaryawan extends Equatable {
  const TingkatStresKaryawan({
    required this.bulan,
    required this.rataRataStres,
  });

  final int bulan;
  final double rataRataStres;

  factory TingkatStresKaryawan.fromJson(Map<String, dynamic> json) {
    return TingkatStresKaryawan(
      bulan: json['bulan'] as int,
      rataRataStres: (json['rata_rata_skor'] as num).toDouble(),
    );
  }
  @override
  List<Object?> get props => [bulan, rataRataStres];
}
