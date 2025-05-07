import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waraspada_app/data/repository/survei_karyawan_repository.dart';

part 'check_survei_event.dart';
part 'check_survei_state.dart';

class CheckSurveiBloc extends Bloc<CheckSurveiEvent, CheckSurveiState> {
  final SurveiKaryawanRepository _surveiKaryawanRepository;
  CheckSurveiBloc(this._surveiKaryawanRepository)
    : super(CheckSurveiState.initial()) {
    on<CheckSurveiRequested>((event, emit) async {
      emit(state.copyWith(status: CheckSurveiStatus.loading));
      final result = await _surveiKaryawanRepository.checkKaryawanSudahSurvei(
        event.karyawanId,
      );
      result.fold(
        (l) => emit(
          state.copyWith(status: CheckSurveiStatus.failure, errorMessage: l),
        ),
        (r) => emit(
          state.copyWith(status: CheckSurveiStatus.loaded, isSudahSurvei: r),
        ),
      );
    });
  }
}
