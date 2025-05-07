part of 'survei_karyawan_bloc.dart';

enum SurveiStatus { initial, loading, success, error }

class SurveiKaryawanState extends Equatable {
  final List<Soal> soalList;
  final SurveiStatus status;
  final String? errorMessage;

  const SurveiKaryawanState({
    this.soalList = const [],
    this.status = SurveiStatus.initial,
    this.errorMessage,
  });

  int get totalAnswered =>
      soalList.where((soal) => soal.jawaban != null).length;

  SurveiKaryawanState copyWith({
    List<Soal>? soalList,
    SurveiStatus? status,
    String? errorMessage,
  }) {
    return SurveiKaryawanState(
      soalList: soalList ?? this.soalList,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [soalList, status, errorMessage];
}
