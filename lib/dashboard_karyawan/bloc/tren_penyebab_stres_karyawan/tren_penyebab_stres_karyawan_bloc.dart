import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/data.dart';

part 'tren_penyebab_stres_karyawan_event.dart';
part 'tren_penyebab_stres_karyawan_state.dart';

class TrenPenyebabStresKaryawanBloc
    extends
        Bloc<TrenPenyebabStresKaryawanEvent, TrenPenyebabStresKaryawanState> {
  final DataVisualisasiRepository _dataVisualisasiRepository;
  TrenPenyebabStresKaryawanBloc(this._dataVisualisasiRepository)
    : super(TrenPenyebabStresKaryawanState.initial()) {
    on<TrenPenyebabStresKaryawanRequested>((event, emit) async {
      emit(state.copyWith(status: TrenPenyebabStresKaryawanStatus.loading));
      final response = await _dataVisualisasiRepository
          .ambilDataVisualisasiTrenPenyebabStresPerBulanKaryawan(
            event.karyawanId,
            event.tahun,
          );
      response.fold(
        (l) => emit(
          state.copyWith(
            status: TrenPenyebabStresKaryawanStatus.failure,
            errorMessage: l,
          ),
        ),
        (r) => emit(
          state.copyWith(
            status: TrenPenyebabStresKaryawanStatus.success,
            data: r,
          ),
        ),
      );
    });
  }
}
