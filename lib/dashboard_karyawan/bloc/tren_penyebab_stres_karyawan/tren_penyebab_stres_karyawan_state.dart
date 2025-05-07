part of 'tren_penyebab_stres_karyawan_bloc.dart';

enum TrenPenyebabStresKaryawanStatus { initial, loading, success, failure }

class TrenPenyebabStresKaryawanState extends Equatable {
  final TrenPenyebabStresKaryawanStatus status;
  final List<PenyebabStresKaryawan> data;
  final String? errorMessage;

  const TrenPenyebabStresKaryawanState({
    required this.status,
    required this.data,
    this.errorMessage,
  });

  const TrenPenyebabStresKaryawanState.initial()
    : this(status: TrenPenyebabStresKaryawanStatus.initial, data: const []);

  TrenPenyebabStresKaryawanState copyWith({
    TrenPenyebabStresKaryawanStatus? status,
    List<PenyebabStresKaryawan>? data,
    String? errorMessage,
  }) {
    return TrenPenyebabStresKaryawanState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, data];
}
