part of 'distribusi_tingkat_stres_usaha_bloc.dart';

sealed class DistribusiTingkatStresUsahaEvent extends Equatable {
  const DistribusiTingkatStresUsahaEvent();
}

class DistribusiTingkatStresUsahaRequested
    extends DistribusiTingkatStresUsahaEvent {
  final String usahaId;
  final int tahun;
  final int bulan;

  const DistribusiTingkatStresUsahaRequested(
    this.usahaId,
    this.tahun,
    this.bulan,
  );

  @override
  List<Object?> get props => [usahaId, tahun, bulan];
}
