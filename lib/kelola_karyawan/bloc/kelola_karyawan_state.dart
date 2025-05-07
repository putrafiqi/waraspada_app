part of 'kelola_karyawan_bloc.dart';

enum KelolaKaryawanStatus { initial, loading, success, failure }

class KelolaKaryawanState extends Equatable {
  final KelolaKaryawanStatus status;
  final List<Karyawan> listKaryawan;
  final String? errorMessage;

  const KelolaKaryawanState(this.status, this.listKaryawan, this.errorMessage);

  const KelolaKaryawanState.initial()
      : status = KelolaKaryawanStatus.initial,
        listKaryawan = const [],
        errorMessage = null;

  KelolaKaryawanState copyWith({
    KelolaKaryawanStatus? status,
    List<Karyawan>? listKaryawan,
    String? errorMessage,
}) {
    return KelolaKaryawanState(
      status ?? this.status,
      listKaryawan ?? this.listKaryawan,
      errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, listKaryawan];
}
