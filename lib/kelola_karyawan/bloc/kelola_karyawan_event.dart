part of 'kelola_karyawan_bloc.dart';

sealed class KelolaKaryawanEvent extends Equatable {
  const KelolaKaryawanEvent();
}

class AmbilListKaryawanRequested extends KelolaKaryawanEvent {
  const AmbilListKaryawanRequested(this.usahaId);

  final String usahaId;

  @override
  List<Object?> get props => [usahaId];
}

class UndangKaryawanPressed extends KelolaKaryawanEvent {
  const UndangKaryawanPressed(
      this.usahaId,
      this.email,
      );

  final String usahaId;
  final String email;

  @override
  List<Object?> get props => [usahaId, email];
}
