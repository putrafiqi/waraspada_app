import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/data.dart';


part 'distribusi_tingkat_stres_usaha_event.dart';
part 'distribusi_tingkat_stres_usaha_state.dart';

class DistribusiTingkatStresUsahaBloc
    extends
        Bloc<
          DistribusiTingkatStresUsahaEvent,
          DistribusiTingkatStresUsahaState
        > {
  final DataVisualisasiRepository _dataVisualisasiRepository;

  DistribusiTingkatStresUsahaBloc(this._dataVisualisasiRepository)
    : super(DistribusiTingkatStresUsahaState.initial()) {
    on<DistribusiTingkatStresUsahaRequested>((event, emit) async {
      emit(state.copyWith(status: DistribusiTingkatStresUsahaStatus.loading));
      final response = await _dataVisualisasiRepository
          .ambilDataVisualisasiDistribusiTingkatStres(
            event.usahaId,
            event.tahun,
            event.bulan,
          );

      response.fold(
        (l) => emit(
          state.copyWith(
            status: DistribusiTingkatStresUsahaStatus.failure,
            errorMessage: l,
          ),
        ),
        (r) => emit(
          state.copyWith(
            status: DistribusiTingkatStresUsahaStatus.success,
            distribusiTingkatStres: r,
          ),
        ),
      );
    });
  }
}
