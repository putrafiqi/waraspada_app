import 'package:equatable/equatable.dart';

class TingkatStres extends Equatable {
  const TingkatStres({required this.bulan, required this.rataRataStres});

  final int bulan;
  final double rataRataStres;

  factory TingkatStres.fromJson(Map<String, dynamic> json) {
    return TingkatStres(
      bulan: json['bulan'] as int,
      rataRataStres: (json['rata_rata_tingkat_stres'] as num).toDouble(),
    );
  }
  @override
  List<Object?> get props => [bulan, rataRataStres];
}
