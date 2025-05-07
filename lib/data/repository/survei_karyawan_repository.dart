import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../data_source/survei_karyawan_api.dart';
import 'package:fpdart/fpdart.dart';

import '../model/model.dart';

abstract class SurveiKaryawanRepository {
  Future<Either<String, bool>> submitSurveiKaryawan(
    String karyawanId,
    HasilSurvei hasilSurvei,
  );
  Future<Either<String, bool>> checkKaryawanSudahSurvei(String karyawanId);

  Future<Either<String, List<Soal>>> ambilListSoalSurvei();
}

class SurveiKaryawanRepositoryImpl implements SurveiKaryawanRepository {
  final SurveiKaryawanApi _surveiKaryawanApi;

  const SurveiKaryawanRepositoryImpl(this._surveiKaryawanApi);

  @override
  Future<Either<String, bool>> checkKaryawanSudahSurvei(
    String karyawanId,
  ) async {
    try {
      final response = await _surveiKaryawanApi.checkKaryawanSudahSurvei(
        karyawanId,
      );
      return right(response);
    } on PostgrestException catch (e) {
      log(e.message);
      return left(e.message);
    } catch (e, r) {
      log(r.toString());
      log(e.toString());
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> submitSurveiKaryawan(
    String karyawanId,
    HasilSurvei hasilSurvei,
  ) async {
    try {
      final response = await _surveiKaryawanApi.submitSurveiKaryawan(
        karyawanId,
        hasilSurvei,
      );
      return right(response);
    } on PostgrestException catch (e) {
      log(e.message);
      return left(e.message);
    } catch (e) {
      log(e.toString());
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, List<Soal>>> ambilListSoalSurvei() async {
    try {
      final response = await _surveiKaryawanApi.ambilListSoalSurvei();
      return right(response);
    } catch (e) {
      log(e.toString());
      return left(e.toString());
    }
  }
}
