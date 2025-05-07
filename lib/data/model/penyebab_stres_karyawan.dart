import 'package:equatable/equatable.dart';

class PenyebabStresKaryawan extends Equatable {
  final int bulan;
  final double skorKetaksaanPeran;
  final double skorKonfilePeran;
  final double skorBebanBerlebih;
  final double skorPengembanganKarir;
  final double skorTanggungJawabOrangLain;

  const PenyebabStresKaryawan({
    required this.bulan,
    required this.skorKetaksaanPeran,
    required this.skorKonfilePeran,
    required this.skorBebanBerlebih,
    required this.skorPengembanganKarir,
    required this.skorTanggungJawabOrangLain,
  });

  factory PenyebabStresKaryawan.fromJson(Map<String, dynamic> json) {
    return PenyebabStresKaryawan(
      bulan: json['bulan'] as int,
      skorKetaksaanPeran: (json['rata_rata_ketaksaan_peran'] as num).toDouble(),
      skorKonfilePeran: (json['rata_rata_konflik_peran'] as num).toDouble(),
      skorBebanBerlebih: (json['rata_rata_beban_berlebih'] as num).toDouble(),
      skorPengembanganKarir:
          (json['rata_rata_pengembangan_karir'] as num).toDouble(),
      skorTanggungJawabOrangLain:
          (json['rata_rata_tanggung_jawab_orang_lain'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [
    bulan,
    skorKetaksaanPeran,
    skorKonfilePeran,
    skorBebanBerlebih,
    skorPengembanganKarir,
    skorTanggungJawabOrangLain,
  ];
}
