import 'package:equatable/equatable.dart';

class HasilSurvei extends Equatable {
  final int skorTP;
  final int skorBB;
  final int skorKP;
  final int skorPK;
  final int skorTJO;
  final double skorTingkatStres;

  const HasilSurvei({
    required this.skorTP,
    required this.skorBB,
    required this.skorKP,
    required this.skorPK,
    required this.skorTJO,
  }) : skorTingkatStres = (skorTP + skorBB + skorKP + skorPK + skorTJO) / 5;

  Map<String, dynamic> toMap() {
    return {
      'skor_ketaksaan_peran': skorTP,
      'skor_konflik_peran': skorKP,
      'skor_beban_berlebih': skorBB,
      'skor_pengembangan_karir': skorPK,
      'skor_tanggung_jawab_orang_lain': skorTJO,
      'skor_tingkat_stres': skorTingkatStres,
    };
  }

  @override
  List<Object?> get props => [
    skorTP,
    skorBB,
    skorKP,
    skorPK,
    skorTJO,
    skorTingkatStres,
  ];
}
