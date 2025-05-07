part of 'tren_penyebab_stres_usaha_bloc.dart';

sealed class TrenPenyebabStresUsahaEvent extends Equatable {
  const TrenPenyebabStresUsahaEvent();
}

class TrenPenyebabStresUsahaRequested extends TrenPenyebabStresUsahaEvent {
  final String usahaId;
  final int filterTahun;

  const TrenPenyebabStresUsahaRequested(
     this.usahaId,
     this.filterTahun,
  );

  @override
  List<Object?> get props => [usahaId, filterTahun];
}
