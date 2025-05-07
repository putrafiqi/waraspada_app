part of 'tren_tingkat_stres_karyawan_bloc.dart';

sealed class TrenTingkatStresKaryawanEvent extends Equatable {
  const TrenTingkatStresKaryawanEvent();
}

class TrenTingkatStresKaryawanRequested extends TrenTingkatStresKaryawanEvent {
  final String karyawanId;
  final int tahun;
  const TrenTingkatStresKaryawanRequested(this.karyawanId, this.tahun);

  @override
  List<Object?> get props => [karyawanId, tahun];
}
