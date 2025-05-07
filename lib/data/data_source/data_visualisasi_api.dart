import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/model.dart';

abstract class DataVisualisasiApi {
  Future<List<TingkatStres>> ambilDataVisualisasiTrenTingkatStresPerBulan(
    String usahaId,
    int tahun,
  );
  Future<List<PenyebabStres>> ambilDataVisualisasiTrenPenyebabStresPerBulan(
    String usahaId,
    int tahun,
  );
  Future<List<DistribusiTingkatStres>>
  ambilDataVisualisasiDistribusiTingkatStres(
    String usahaId,
    int tahun,
    int bulan,
  );

  Future<List<DistribusiPenyebabStres>>
  ambilDataVisualisasiDistribusiPenyebabStres(
    String usahaId,
    int tahun,
    int bulan,
  );

  Future<List<TingkatStresKaryawan>>
  ambilDataVisualisasiTrenTingkatStresPerBulanKaryawan(
    String karyawanId,
    int tahun,
  );

  Future<List<PenyebabStresKaryawan>>
  ambilDataVisualisasiTrenPenyebabStresPerBulanKaryawan(
    String karyawanId,
    int tahun,
  );
}

class DataVisualisasiApiImpl implements DataVisualisasiApi {
  final SupabaseClient _supabaseClient;

  const DataVisualisasiApiImpl({required SupabaseClient supabaseClient})
    : _supabaseClient = supabaseClient;

  @override
  Future<List<PenyebabStres>> ambilDataVisualisasiTrenPenyebabStresPerBulan(
    String usahaId,
    int tahun,
  ) async {
    final data =
        await _supabaseClient
            .rpc(
              'get_average_stress_causes_per_month',
              params: {'p_usaha_id': usahaId, 'p_tahun': tahun},
            )
            .select();

    return data.map(PenyebabStres.fromJson).toList();
  }

  @override
  Future<List<TingkatStres>> ambilDataVisualisasiTrenTingkatStresPerBulan(
    String usahaId,
    int tahun,
  ) async {
    final response =
        await _supabaseClient
            .rpc(
              'get_complete_average_stress_per_month',
              params: {'p_usaha_id': usahaId, 'p_tahun': tahun},
            )
            .select();

    return response.map(TingkatStres.fromJson).toList();
  }

  @override
  Future<List<DistribusiTingkatStres>>
  ambilDataVisualisasiDistribusiTingkatStres(
    String usahaId,
    int tahun,
    int bulan,
  ) async {
    final response =
        await _supabaseClient
            .rpc(
              'get_stress_distribution',
              params: {
                'p_usaha_id': usahaId,
                'p_tahun': tahun,
                'p_bulan': bulan,
              },
            )
            .select();
    return response.map(DistribusiTingkatStres.fromJson).toList();
  }

  @override
  Future<List<DistribusiPenyebabStres>>
  ambilDataVisualisasiDistribusiPenyebabStres(
    String usahaId,
    int tahun,
    int bulan,
  ) async {
    final response =
        await _supabaseClient
            .rpc(
              'get_cause_stress_distribution',
              params: {
                'p_usaha_id': usahaId,
                'p_tahun': tahun,
                'p_bulan': bulan,
              },
            )
            .select();

    return response.map(DistribusiPenyebabStres.fromJson).toList();
  }

  @override
  Future<List<PenyebabStresKaryawan>>
  ambilDataVisualisasiTrenPenyebabStresPerBulanKaryawan(
    String karyawanId,
    int tahun,
  ) async {
    final response =
        await _supabaseClient
            .rpc(
              'get_average_stress_causes_per_month_karyawan',
              params: {'p_karyawan_id': karyawanId, 'p_tahun': tahun},
            )
            .select();

    return response.map(PenyebabStresKaryawan.fromJson).toList();
  }

  @override
  Future<List<TingkatStresKaryawan>>
  ambilDataVisualisasiTrenTingkatStresPerBulanKaryawan(
    String karyawanId,
    int tahun,
  ) async {
    final response =
        await _supabaseClient
            .rpc(
              'get_trend_stres_karyawan',
              params: {'p_karyawan_id': karyawanId, 'p_tahun': tahun},
            )
            .select();

    return response.map(TingkatStresKaryawan.fromJson).toList();
  }
}
