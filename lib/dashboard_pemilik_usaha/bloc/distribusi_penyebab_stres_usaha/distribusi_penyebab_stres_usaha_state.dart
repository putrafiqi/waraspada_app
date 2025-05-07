part of 'distribusi_penyebab_stres_usaha_bloc.dart';

enum DistribusiPenyebabStresUsahaStatus { initial, loading, success, failure }

class DistribusiPenyebabStresUsahaState extends Equatable {
  final DistribusiPenyebabStresUsahaStatus status;
  final List<DistribusiPenyebabStres> distribusiPenyebabStres;
  final String? errorMessage;

  const DistribusiPenyebabStresUsahaState({
    required this.status,
    required this.distribusiPenyebabStres,
    this.errorMessage,
  });

  const DistribusiPenyebabStresUsahaState.initial()
    : this(
        status: DistribusiPenyebabStresUsahaStatus.initial,
        distribusiPenyebabStres: const [],
      );

  DistribusiPenyebabStresUsahaState copyWith({
    DistribusiPenyebabStresUsahaStatus? status,
    List<DistribusiPenyebabStres>? distribusiPenyebabStres,
    String? errorMessage,
  }) {
    return DistribusiPenyebabStresUsahaState(
      status: status ?? this.status,
      distribusiPenyebabStres:
          distribusiPenyebabStres ?? this.distribusiPenyebabStres,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, distribusiPenyebabStres];
}
