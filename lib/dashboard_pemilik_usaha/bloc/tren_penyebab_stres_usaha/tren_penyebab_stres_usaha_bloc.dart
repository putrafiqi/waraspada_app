import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/data.dart';

part 'tren_penyebab_stres_usaha_event.dart';
part 'tren_penyebab_stres_usaha_state.dart';

class TrenPenyebabStresUsahaBloc
    extends Bloc<TrenPenyebabStresUsahaEvent, TrenPenyebabStresUsahaState> {
  final DataVisualisasiRepository _dataVisualisasiRepository;

  TrenPenyebabStresUsahaBloc(
    DataVisualisasiRepository dataVisualisasiRepository,
  ) : _dataVisualisasiRepository = dataVisualisasiRepository,
      super(TrenPenyebabStresUsahaState.initial()) {
    on<TrenPenyebabStresUsahaRequested>((event, emit) async {
      emit(state.copyWith(status: TrenPenyebabStresUsahaStatus.loading));

      final response = await _dataVisualisasiRepository
          .ambilDataVisualisasiTrenPenyebabStresPerBulan(
            event.usahaId,
            event.filterTahun,
          );

      response.fold(
        (error) {
          emit(
            state.copyWith(
              status: TrenPenyebabStresUsahaStatus.failure,
              errorMessage: error,
            ),
          );
        },
        (data) {
          emit(
            state.copyWith(
              status: TrenPenyebabStresUsahaStatus.success,
              data: data,
            ),
          );
        },
      );
    });
  }
}
