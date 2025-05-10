part of 'network_checker_bloc.dart';

sealed class NetworkCheckerEvent extends Equatable {
  const NetworkCheckerEvent();
}

class NetworkCheckerSubscriptionRequested extends NetworkCheckerEvent {
  const NetworkCheckerSubscriptionRequested();

  @override
  List<Object?> get props => [];
}
