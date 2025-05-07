import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/data.dart';

part 'distribusi_penyebab_stres_usaha_event.dart';
part 'distribusi_penyebab_stres_usaha_state.dart';

class DistribusiPenyebabStresUsahaBloc
    extends
        Bloc<
          DistribusiPenyebabStresUsahaEvent,
          DistribusiPenyebabStresUsahaState
        > {
  final DataVisualisasiRepository _dataVisualisasiRepository;
  DistribusiPenyebabStresUsahaBloc(this._dataVisualisasiRepository)
    : super(DistribusiPenyebabStresUsahaState.initial()) {
    on<DistribusiPenyebabStresUsahaRequested>((event, emit) async {
      emit(state.copyWith(status: DistribusiPenyebabStresUsahaStatus.loading));
      final response = await _dataVisualisasiRepository
          .ambilDataVisualisasiDistribusiPenyebabStres(
            event.usahaId,
            event.tahun,
            event.bulan,
          );

      response.fold(
        (l) => emit(
          state.copyWith(
            status: DistribusiPenyebabStresUsahaStatus.failure,
            errorMessage: l,
          ),
        ),
        (r) => emit(
          state.copyWith(
            status: DistribusiPenyebabStresUsahaStatus.success,
            distribusiPenyebabStres: r,
          ),
        ),
      );
    });
  }
}
