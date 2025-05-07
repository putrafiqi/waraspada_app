import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/data.dart';

part 'tren_tingkat_stres_usaha_event.dart';
part 'tren_tingkat_stres_usaha_state.dart';

class TrenTingkatStresUsahaBloc
    extends Bloc<TrenTingkatStresUsahaEvent, TrenTingkatStresUsahaState> {
  final DataVisualisasiRepository _dataVisualisasiRepository;
  TrenTingkatStresUsahaBloc(DataVisualisasiRepository dataVisualisasiRepository)
    : _dataVisualisasiRepository = dataVisualisasiRepository,
      super(TrenTingkatStresUsahaState.initial()) {
    on<TrenTingkatStresUsahaRequested>((event, emit) async {
      emit(state.copyWith(status: TrenTingkatStresUsahaStatus.loading));

      final result = await _dataVisualisasiRepository
          .ambilDataVisualisasiTrenTingkatStresPerBulan(
            event.usahaId,
            event.filterTahun,
          );

      result.fold(
        (failure) => emit(
          state.copyWith(
            status: TrenTingkatStresUsahaStatus.error,
            errorMessage: failure,
          ),
        ),
        (data) => emit(
          state.copyWith(
            status: TrenTingkatStresUsahaStatus.loaded,
            data: data,
          ),
        ),
      );
    });
  }
}
