

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

part 'network_checker_event.dart';
part 'network_checker_state.dart';

class NetworkCheckerBloc extends Bloc<NetworkCheckerEvent, NetworkCheckerState> {
  NetworkCheckerBloc() : super(NetworkCheckerState.initial()) {

    on<NetworkCheckerSubscriptionRequested>((event, emit) async {
      await emit.onEach(InternetConnection().onStatusChange, onData: (data) {
        emit(NetworkCheckerState(data == InternetStatus.connected));
      },);
    });
  }


}
