import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../data_source/data_source.dart';
import '../model/model.dart';
import 'package:fpdart/fpdart.dart';

abstract class KelolaKaryawanRepository {
  Future<Either<String, List<Karyawan>>> getListKaryawan(String usahaId);
  Future<Either<String, bool>> undangKaryawan(String email, String usahaId);
}

class KelolaKaryawanRepositoryImpl implements KelolaKaryawanRepository {
  const KelolaKaryawanRepositoryImpl({
    required KelolaKaryawanApi kelolaKaryawan,
  }) : _kelolaKaryawan = kelolaKaryawan;

  final KelolaKaryawanApi _kelolaKaryawan;

  @override
  Future<Either<String, List<Karyawan>>> getListKaryawan(String usahaId) async {
    try {
      final dataKaryawan = await _kelolaKaryawan.getListKaryawan(usahaId);
      return right(dataKaryawan);
    } on PostgrestException {
      return left('Gagal mendapatkan data karyawan');
    } on Exception catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> undangKaryawan(
    String email,
    String usahaId,
  ) async {
    try {
      await _kelolaKaryawan.undangKaryawan(email, usahaId);
      return right(true);
    } on PostgrestException catch(e){
      log(e.message);
      return left('Gagal mengundang karyawan');
    } on Exception catch (e) {
      return left(e.toString());
    }
  }
}
