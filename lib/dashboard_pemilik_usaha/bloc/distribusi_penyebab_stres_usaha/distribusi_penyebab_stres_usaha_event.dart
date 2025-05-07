part of 'distribusi_penyebab_stres_usaha_bloc.dart';

sealed class DistribusiPenyebabStresUsahaEvent extends Equatable {
  const DistribusiPenyebabStresUsahaEvent();
}

class DistribusiPenyebabStresUsahaRequested
    extends DistribusiPenyebabStresUsahaEvent {
  final String usahaId;
  final int tahun;
  final int bulan;

  const DistribusiPenyebabStresUsahaRequested(
    this.usahaId,
    this.tahun,
    this.bulan,
  );

  @override
  List<Object?> get props => [usahaId, tahun, bulan];
}
