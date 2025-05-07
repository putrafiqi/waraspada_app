import 'package:equatable/equatable.dart';

class DistribusiPenyebabStres extends Equatable {
  final String kategoriStres;
  final List<Map<String, dynamic>> penyebab;

  const DistribusiPenyebabStres({
    required this.kategoriStres,
    required this.penyebab,
  });

  factory DistribusiPenyebabStres.fromJson(Map<String, dynamic> json) {
    return DistribusiPenyebabStres(
      penyebab:
          (json['penyebab'] as List<dynamic>)
              .map<Map<String, dynamic>>((e) => e)
              .toList(),
      kategoriStres: json['kategori'] as String,
    );
  }

  @override
  List<Object?> get props => [kategoriStres, penyebab];
}
