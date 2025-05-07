import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/model.dart';

abstract class KelolaKaryawanApi {
  Future<List<Karyawan>> getListKaryawan(String usahaId);
  Future<void> undangKaryawan(String email, String usahaId);
}

class KelolaKaryawanApiImpl implements KelolaKaryawanApi {
  final SupabaseClient _supabaseClient;
  const KelolaKaryawanApiImpl(SupabaseClient supabaseClient)
    : _supabaseClient = supabaseClient;

  @override
  Future<List<Karyawan>> getListKaryawan(String usahaId) async {
    final dataKaryawan =
        await _supabaseClient
            .rpc(
              'get_karyawan_by_usaha_id',
              params: {'usaha_id_param': usahaId},
            )
            .select();

    return dataKaryawan.map(Karyawan.fromJson).toList();
  }

  @override
  Future<void> undangKaryawan(String email, String usahaId) async {
    await _supabaseClient.from('undangan').insert({
      'email': email,
      'usaha_id': usahaId,
    });

    //TODO: kirim kode undangan ke email karyawan
  }
}
