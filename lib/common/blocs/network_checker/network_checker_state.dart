part of 'network_checker_bloc.dart';

class NetworkCheckerState extends Equatable {
  final bool isConnected;
  const NetworkCheckerState(this.isConnected);

  const NetworkCheckerState.initial() : isConnected = true;

  @override
  List<Object?> get props => [isConnected];
}
