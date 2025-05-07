part of 'tren_tingkat_stres_usaha_bloc.dart';

enum TrenTingkatStresUsahaStatus { initial, loading, loaded, error }

class TrenTingkatStresUsahaState extends Equatable {
  final TrenTingkatStresUsahaStatus status;
  final List<TingkatStres> data;
  final String? errorMessage;

  const TrenTingkatStresUsahaState({
    required this.status,
    required this.data,
    this.errorMessage,
  });

  const TrenTingkatStresUsahaState.initial()
    : this(status: TrenTingkatStresUsahaStatus.initial, data: const []);

  double get maxDataY {
    if(data.isEmpty) return 0;
    return data.map((e) => e.rataRataStres).reduce((a, b) => a > b ? a : b);
  }

  TrenTingkatStresUsahaState copyWith({
    TrenTingkatStresUsahaStatus? status,
    List<TingkatStres>? data,
    String? errorMessage,
  }) {
    return TrenTingkatStresUsahaState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, data];
}
