part of 'check_survei_bloc.dart';

sealed class CheckSurveiEvent extends Equatable {
  const CheckSurveiEvent();
}

final class CheckSurveiRequested extends CheckSurveiEvent {
  final String karyawanId;
  const CheckSurveiRequested(this.karyawanId);

  @override
  List<Object?> get props => [karyawanId];
}
