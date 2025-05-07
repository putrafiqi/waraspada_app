import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/data.dart';

part 'tren_tingkat_stres_karyawan_event.dart';
part 'tren_tingkat_stres_karyawan_state.dart';

class TrenTingkatStresKaryawanBloc
    extends Bloc<TrenTingkatStresKaryawanEvent, TrenTingkatStresKaryawanState> {
  final DataVisualisasiRepository _dataVisualisasiRepository;

  TrenTingkatStresKaryawanBloc(this._dataVisualisasiRepository)
    : super(TrenTingkatStresKaryawanState.initial()) {
    on<TrenTingkatStresKaryawanRequested>((event, emit) async {
      emit(state.copyWith(status: TrenTingkatStresKaryawanStatus.loading));

      final response = await _dataVisualisasiRepository
          .ambilDataVisualisasiTrenTingkatStresPerBulanKaryawan(
            event.karyawanId,
            event.tahun,
          );

      response.fold(
        (l) => emit(
          state.copyWith(
            status: TrenTingkatStresKaryawanStatus.failure,
            errorMessage: l,
          ),
        ),
        (r) => emit(
          state.copyWith(
            status: TrenTingkatStresKaryawanStatus.success,
            data: r,
          ),
        ),
      );
    });
  }
}
