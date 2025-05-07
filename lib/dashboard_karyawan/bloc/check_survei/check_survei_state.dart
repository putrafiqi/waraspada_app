part of 'check_survei_bloc.dart';

enum CheckSurveiStatus { initial, loading, loaded, failure }

class CheckSurveiState extends Equatable {
  final CheckSurveiStatus status;
  final bool isSudahSurvei;
  final String? errorMessage;

  const CheckSurveiState({
    required this.status,
    required this.isSudahSurvei,
    this.errorMessage,
  });

  const CheckSurveiState.initial()
    : this(status: CheckSurveiStatus.initial, isSudahSurvei: false);

  CheckSurveiState copyWith({
    CheckSurveiStatus? status,
    bool? isSudahSurvei,
    String? errorMessage,
  }) {
    return CheckSurveiState(
      status: status ?? this.status,
      isSudahSurvei: isSudahSurvei ?? this.isSudahSurvei,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, isSudahSurvei];
}
