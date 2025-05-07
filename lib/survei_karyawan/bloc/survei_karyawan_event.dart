part of 'survei_karyawan_bloc.dart';

sealed class SurveiKaryawanEvent extends Equatable {
  const SurveiKaryawanEvent();
}

class SurveiKaryawanInitialized extends SurveiKaryawanEvent {
  @override
  List<Object?> get props => [];
}

class SoalJawabanChanged extends SurveiKaryawanEvent {
  final int index;
  final int jawaban;

  const SoalJawabanChanged({required this.index, required this.jawaban});

  @override
  List<Object?> get props => [index, jawaban];
}

class SurveiKaryawanReset extends SurveiKaryawanEvent {
  @override
  List<Object?> get props => [];
}

final class SurveiKaryawanSubmitted extends SurveiKaryawanEvent {
  final String karyawanId;
  final HasilSurvei hasilSurvei;

  const SurveiKaryawanSubmitted({
    required this.karyawanId,
    required this.hasilSurvei,
  });

  @override
  List<Object> get props => [karyawanId, hasilSurvei];
}
