import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../data_source/data_source.dart';
import '../model/model.dart';
import 'package:fpdart/fpdart.dart';

abstract class DataVisualisasiRepository {
  Future<Either<String, List<TingkatStres>>>
  ambilDataVisualisasiTrenTingkatStresPerBulan(String usahaId, int tahun);
  Future<Either<String, List<PenyebabStres>>>
  ambilDataVisualisasiTrenPenyebabStresPerBulan(String usahaId, int tahun);

  Future<Either<String, List<DistribusiTingkatStres>>>
  ambilDataVisualisasiDistribusiTingkatStres(
    String usahaId,
    int tahun,
    int bulan,
  );

  Future<Either<String, List<DistribusiPenyebabStres>>>
  ambilDataVisualisasiDistribusiPenyebabStres(
    String usahaId,
    int tahun,
    int bulan,
  );

  Future<Either<String, List<TingkatStresKaryawan>>>
  ambilDataVisualisasiTrenTingkatStresPerBulanKaryawan(
    String karyawanId,
    int tahun,
  );

  Future<Either<String, List<PenyebabStresKaryawan>>>
  ambilDataVisualisasiTrenPenyebabStresPerBulanKaryawan(
    String karyawanId,
    int tahun,
  );
}

class DataVisualisasiRepositoryImpl implements DataVisualisasiRepository {
  final DataVisualisasiApi _dataVisualisasiApi;

  const DataVisualisasiRepositoryImpl({
    required DataVisualisasiApi dataVisualisasiApi,
  }) : _dataVisualisasiApi = dataVisualisasiApi;

  @override
  Future<Either<String, List<PenyebabStres>>>
  ambilDataVisualisasiTrenPenyebabStresPerBulan(
    String usahaId,
    int tahun,
  ) async {
    try {
      final response = await _dataVisualisasiApi
          .ambilDataVisualisasiTrenPenyebabStresPerBulan(usahaId, tahun);
      return right(response);
    } on PostgrestException catch (e) {
      if(e.message.split(' ')[0] == 'ClientException'){
        return left('Tidak Ada Koneksi Internet');
      }
      log(e.message);
      return left(e.message);
    } catch (e) {
      if(e.toString().split(' ')[0] == 'ClientException'){
        return left('Tidak Ada Koneksi Internet');
      }
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, List<TingkatStres>>>
  ambilDataVisualisasiTrenTingkatStresPerBulan(
    String usahaId,
    int tahun,
  ) async {
    try {
      final response = await _dataVisualisasiApi
          .ambilDataVisualisasiTrenTingkatStresPerBulan(usahaId, tahun);
      return right(response);
    } on PostgrestException catch (e) {
      if(e.message.split(' ')[0] == 'ClientException'){
        return left('Tidak Ada Koneksi Internet');
      }
      log(e.message);

      return left(e.message);
    } catch (e) {
      if(e.toString().split(' ')[0] == 'ClientException'){
        return left('Tidak Ada Koneksi Internet');
      }
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, List<DistribusiTingkatStres>>>
  ambilDataVisualisasiDistribusiTingkatStres(
    String usahaId,
    int tahun,
    int bulan,
  ) async {
    try {
      final response = await _dataVisualisasiApi
          .ambilDataVisualisasiDistribusiTingkatStres(usahaId, tahun, bulan);
      return right(response);
    } on PostgrestException catch (e) {
      if(e.message.split(' ')[0] == 'ClientException'){
        return left('Tidak Ada Koneksi Internet');
      }
      log(e.message);
      return left(e.message);
    } catch (e) {
      if(e.toString().split(' ')[0] == 'ClientException'){
        return left('Tidak Ada Koneksi Internet');
      }
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, List<DistribusiPenyebabStres>>>
  ambilDataVisualisasiDistribusiPenyebabStres(
    String usahaId,
    int tahun,
    int bulan,
  ) async {
    try {
      final response = await _dataVisualisasiApi
          .ambilDataVisualisasiDistribusiPenyebabStres(usahaId, tahun, bulan);
      return right(response);
    } on PostgrestException catch (e) {
      if(e.message.split(' ')[0] == 'ClientException'){
        return left('Tidak Ada Koneksi Internet');
      }
      log(e.message);
      return left(e.message);
    } catch (e) {
      if(e.toString().split(' ')[0] == 'ClientException'){
        return left('Tidak Ada Koneksi Internet');
      }
      log(e.toString());

      return left(e.toString());
    }
  }

  @override
  Future<Either<String, List<PenyebabStresKaryawan>>>
  ambilDataVisualisasiTrenPenyebabStresPerBulanKaryawan(
    String karyawanId,
    int tahun,
  ) async {
    try {
      final response = await _dataVisualisasiApi
          .ambilDataVisualisasiTrenPenyebabStresPerBulanKaryawan(
            karyawanId,
            tahun,
          );
      return right(response);
    } on PostgrestException catch (e) {
      if(e.message.split(' ')[0] == 'ClientException'){
        return left('Tidak Ada Koneksi Internet');
      }
      log(e.message);
      return left(e.message);
    } catch (e) {
      if(e.toString().split(' ')[0] == 'ClientException'){
        return left('Tidak Ada Koneksi Internet');
      }
      log(e.toString());
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, List<TingkatStresKaryawan>>>
  ambilDataVisualisasiTrenTingkatStresPerBulanKaryawan(
    String karyawanId,
    int tahun,
  ) async {
    try {
      final response = await _dataVisualisasiApi
          .ambilDataVisualisasiTrenTingkatStresPerBulanKaryawan(
            karyawanId,
            tahun,
          );
      return right(response);
    } on PostgrestException catch (e) {
      if(e.message.split(' ')[0] == 'ClientException'){
        return left('Tidak Ada Koneksi Internet');
      }
      log(e.message);
      return left(e.message);
    } catch (e) {
      if(e.toString().split(' ')[0] == 'ClientException'){
        return left('Tidak Ada Koneksi Internet');
      }
      log(e.toString());
      return left(e.toString());
    }
  }
}
