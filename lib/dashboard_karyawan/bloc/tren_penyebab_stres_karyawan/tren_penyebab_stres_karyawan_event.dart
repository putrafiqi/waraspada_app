part of 'tren_penyebab_stres_karyawan_bloc.dart';

sealed class TrenPenyebabStresKaryawanEvent extends Equatable {
  const TrenPenyebabStresKaryawanEvent();
}

class TrenPenyebabStresKaryawanRequested
    extends TrenPenyebabStresKaryawanEvent {
  final String karyawanId;
  final int tahun;
  const TrenPenyebabStresKaryawanRequested(this.karyawanId, this.tahun);

  @override
  List<Object?> get props => [karyawanId, tahun];
}
