import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/data.dart';

part 'kelola_karyawan_event.dart';
part 'kelola_karyawan_state.dart';

class KelolaKaryawanBloc
    extends Bloc<KelolaKaryawanEvent, KelolaKaryawanState> {
  final KelolaKaryawanRepository _kelolaKaryawanRepository;

  KelolaKaryawanBloc(this._kelolaKaryawanRepository)
    : super(KelolaKaryawanState.initial()) {
    on<AmbilListKaryawanRequested>((event, emit) async {
      emit(state.copyWith(status: KelolaKaryawanStatus.loading));

      final response = await _kelolaKaryawanRepository.getListKaryawan(
        event.usahaId,
      );

      response.fold(
        (l) {
          emit(
            state.copyWith(
              status: KelolaKaryawanStatus.failure,
              errorMessage: l,
            ),
          );
        },
        (r) {
          emit(
            state.copyWith(
              status: KelolaKaryawanStatus.success,
              listKaryawan: r,
            ),
          );
        },
      );
    });

    on<UndangKaryawanPressed>((event, emit) async {
      emit(state.copyWith(status: KelolaKaryawanStatus.loading));

      final response = await _kelolaKaryawanRepository.undangKaryawan(
        event.email,
        event.usahaId,
      );

      response.fold(
        (l) {
          emit(
            state.copyWith(
              status: KelolaKaryawanStatus.failure,
              errorMessage: l,
            ),
          );
        },
        (r) {
          add(AmbilListKaryawanRequested(event.usahaId));
        },
      );
    });
  }
}
