part of 'tren_tingkat_stres_usaha_bloc.dart';

sealed class TrenTingkatStresUsahaEvent extends Equatable {
  const TrenTingkatStresUsahaEvent();
}

final class TrenTingkatStresUsahaRequested extends TrenTingkatStresUsahaEvent {
  const TrenTingkatStresUsahaRequested(this.usahaId, this.filterTahun);

  final String usahaId;
  final int filterTahun;

  @override
  List<Object?> get props => [usahaId, filterTahun];
}
