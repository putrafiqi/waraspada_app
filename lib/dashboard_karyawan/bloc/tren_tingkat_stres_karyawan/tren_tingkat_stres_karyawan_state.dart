part of 'tren_tingkat_stres_karyawan_bloc.dart';

enum TrenTingkatStresKaryawanStatus { initial, loading, success, failure }

class TrenTingkatStresKaryawanState extends Equatable {
  const TrenTingkatStresKaryawanState({
    required this.status,
    required this.data,
    this.errorMessage,
  });

  final TrenTingkatStresKaryawanStatus status;
  final List<TingkatStresKaryawan> data;
  final String? errorMessage;

  const TrenTingkatStresKaryawanState.initial()
    : this(status: TrenTingkatStresKaryawanStatus.initial, data: const []);

  TrenTingkatStresKaryawanState copyWith({
    TrenTingkatStresKaryawanStatus? status,
    List<TingkatStresKaryawan>? data,
    String? errorMessage,
  }) {
    return TrenTingkatStresKaryawanState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, data];
}
