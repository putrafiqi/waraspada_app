part of 'distribusi_tingkat_stres_usaha_bloc.dart';

enum DistribusiTingkatStresUsahaStatus { initial, loading, success, failure }

class DistribusiTingkatStresUsahaState extends Equatable {
  final DistribusiTingkatStresUsahaStatus status;
  final List<DistribusiTingkatStres> distribusiTingkatStres;
  final String? errorMessage;
  const DistribusiTingkatStresUsahaState({
    required this.status,
    required this.distribusiTingkatStres,
    this.errorMessage,
  });

  const DistribusiTingkatStresUsahaState.initial()
    : this(
        status: DistribusiTingkatStresUsahaStatus.initial,
        distribusiTingkatStres: const [],
      );

  DistribusiTingkatStresUsahaState copyWith({
    DistribusiTingkatStresUsahaStatus? status,
    List<DistribusiTingkatStres>? distribusiTingkatStres,
    String? errorMessage,
  }) {
    return DistribusiTingkatStresUsahaState(
      status: status ?? this.status,
      distribusiTingkatStres:
          distribusiTingkatStres ?? this.distribusiTingkatStres,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status,distribusiTingkatStres];
}
