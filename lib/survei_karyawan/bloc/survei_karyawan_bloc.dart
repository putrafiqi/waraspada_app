import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waraspada_app/data/data.dart';

part 'survei_karyawan_event.dart';
part 'survei_karyawan_state.dart';

class SurveiKaryawanBloc
    extends Bloc<SurveiKaryawanEvent, SurveiKaryawanState> {
  final SurveiKaryawanRepository _surveiKaryawanRepository;
  SurveiKaryawanBloc(this._surveiKaryawanRepository)
    : super(SurveiKaryawanState()) {
    on<SurveiKaryawanSubmitted>((event, emit) async {
      emit(state.copyWith(status: SurveiStatus.loading));

      final response = await _surveiKaryawanRepository.submitSurveiKaryawan(
        event.karyawanId,
        event.hasilSurvei,
      );

      response.fold(
        (l) =>
            emit(state.copyWith(status: SurveiStatus.error, errorMessage: l)),
        (r) {
          if (r) {
            emit(state.copyWith(status: SurveiStatus.success));
          } else {
            emit(
              state.copyWith(
                status: SurveiStatus.error,
                errorMessage: 'Gagal mengirim survei',
              ),
            );
          }
        },
      );
    });
    on<SurveiKaryawanReset>(_onReset);
    on<SoalJawabanChanged>(_onJawabanChanged);
    on<SurveiKaryawanInitialized>(_onInitialized);
  }
  void _onInitialized(
    SurveiKaryawanInitialized event,
    Emitter<SurveiKaryawanState> emit,
  ) async {
    emit(state.copyWith(status: SurveiStatus.loading));

    final response = await _surveiKaryawanRepository.ambilListSoalSurvei();

    response.fold(
      (l) => emit(state.copyWith(status: SurveiStatus.error, errorMessage: l)),
      (r) => emit(state.copyWith(soalList: r, status: SurveiStatus.initial)),
    );
  }

  void _onJawabanChanged(
    SoalJawabanChanged event,
    Emitter<SurveiKaryawanState> emit,
  ) {
    final updatedSoalList = List<Soal>.from(state.soalList);
    updatedSoalList[event.index] = updatedSoalList[event.index].copyWith(
      jawaban: event.jawaban,
    );

    emit(state.copyWith(soalList: updatedSoalList));
  }

  void _onReset(SurveiKaryawanReset event, Emitter<SurveiKaryawanState> emit) {
    final resetSoalList =
        state.soalList.map((soal) => soal.copyWith(jawaban: null)).toList();

    emit(state.copyWith(soalList: resetSoalList));
  }
}
