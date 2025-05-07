part of 'tren_penyebab_stres_usaha_bloc.dart';

enum TrenPenyebabStresUsahaStatus { initial, loading, success, failure }

class TrenPenyebabStresUsahaState extends Equatable {
  final TrenPenyebabStresUsahaStatus status;
  final List<PenyebabStres> data;
  final String? errorMessage;

  const TrenPenyebabStresUsahaState({
    required this.status,
    required this.data,
    this.errorMessage,
  });

  const TrenPenyebabStresUsahaState.initial()
    : this(status: TrenPenyebabStresUsahaStatus.initial, data: const []);

  double get maxDataYBB {
    if(data.isEmpty) return 0;

    return data.map((e) => e.skorBebanBerlebih).reduce((a, b) => a > b ? a : b);
  }

  double get maxDataYTP {
    if(data.isEmpty) return 0;

    return data.map((e) => e.skorKetaksaanPeran).reduce((a, b) => a > b ? a : b);
  }

  double get maxDataYKP {
    if(data.isEmpty) return 0;

    return data.map((e) => e.skorKonfilePeran).reduce((a, b) => a > b ? a : b);
  }

  double get maxDataYPK {
    if(data.isEmpty) return 0;

    return data.map((e) => e.skorPengembanganKarir).reduce((a, b) => a > b ? a : b);
  }

  double get maxDataYTJO {
    if(data.isEmpty) return 0;

    return data
      .map((e) => e.skorTanggungJawabOrangLain)
      .reduce((a, b) => a > b ? a : b);
  }

  TrenPenyebabStresUsahaState copyWith({
    TrenPenyebabStresUsahaStatus? status,
    List<PenyebabStres>? data,
    String? errorMessage,
  }) {
    return TrenPenyebabStresUsahaState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, data];
}
