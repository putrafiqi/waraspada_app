import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart'
    as supabase
    show SupabaseClient, SignOutScope, User;

import '../model/model.dart';

abstract class AuthenticationApi {
  Future<User> signIn({required String email, required String password});

  Future<User> signUpPemilikUsaha({
    required String email,
    required String password,
    required String namaLengkap,
    required String namaUsaha,
    required String alamatUsaha,
    required File profileFile,
    required File logoFile,
    required String jenisKelamin,
  });

  Future<User> signUpKaryawan({
    required String email,
    required String password,
    required String namaLengkap,
    required String kodeUndangan,
    required File profileFile,
    required String jenisKelamin,
  });

  Future<User> getCurrentUser();

  Future<void> signOut();

  void close();
}

class AuthenticationApiImpl implements AuthenticationApi {
  const AuthenticationApiImpl({required supabase.SupabaseClient supabaseClient})
    : _supabaseClient = supabaseClient;

  final supabase.SupabaseClient _supabaseClient;

  @override
  Future<User> getCurrentUser() async {
    final session = _supabaseClient.auth.currentSession;
    final user = _supabaseClient.auth.currentUser;

    if (session == null || user == null) {
      throw 'Terjadi Kesalahan, silakan login kembali';
    }

    final userRole = user.userMetadata!['role'] as String;
    switch (userRole) {
      case 'pemilik_usaha':
        return _fetchPemilikUsaha(user);
      case 'karyawan':
        return _fetchKaryawan(user);
      default:
        throw 'Peran tidak valid, silakan login kembali';
    }
  }

  Future<User> _fetchPemilikUsaha(supabase.User user) async {
    final pemilikUsaha =
        await _supabaseClient
            .from('pemilik_usaha')
            .select()
            .eq('user_id', user.id)
            .single();

    final usaha =
        await _supabaseClient
            .from('usaha')
            .select('id,logo_url,alamat_usaha,nama_usaha')
            .eq('pemilik_id', pemilikUsaha['id'])
            .single();

    return User(
      id: pemilikUsaha['id'] as String,
      email: user.email!,
      namaLengkap: pemilikUsaha['nama_lengkap'] as String,
      usahaId: usaha['id'] as String,
      jenisKelamin: pemilikUsaha['jenis_kelamin'] as String,
      profileUrl: pemilikUsaha['profile_url'] as String,
      role: 'pemilik_usaha',
      logoUrl: usaha['logo_url'] as String,
      namaUsaha: usaha['nama_usaha'] as String,
      alamatUsaha: usaha['alamat_usaha'] as String,
    );
  }

  Future<User> _fetchKaryawan(supabase.User user) async {
    final karyawan =
        await _supabaseClient
            .from('karyawan')
            .select()
            .eq('user_id', user.id)
            .single();

    final usaha =
        await _supabaseClient
            .from('usaha')
            .select('id,logo_url,alamat_usaha,nama_usaha')
            .eq('id', karyawan['usaha_id'])
            .single();

    return User(
      id: karyawan['id'] as String,
      email: user.email!,
      namaLengkap: karyawan['nama_lengkap'] as String,
      usahaId: karyawan['usaha_id'] as String,
      jenisKelamin: karyawan['jenis_kelamin'] as String,
      profileUrl: karyawan['profile_url'] as String,
      role: 'karyawan',
      logoUrl: usaha['logo_url'] as String,
      namaUsaha: usaha['nama_usaha'] as String,
      alamatUsaha: usaha['alamat_usaha'] as String,
    );
  }

  @override
  Future<User> signIn({required String email, required String password}) async {
    await _supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return getCurrentUser();
  }

  @override
  Future<void> signOut() async {
    await _supabaseClient.auth.signOut(scope: supabase.SignOutScope.global);
  }

  @override
  Future<User> signUpKaryawan({
    required String email,
    required String password,
    required String namaLengkap,
    required String kodeUndangan,
    required File profileFile,
    required String jenisKelamin,
  }) async {
    //Cek kode undangan
    final undangan =
        await _supabaseClient
            .from('undangan')
            .select()
            .eq('kode_undangan', kodeUndangan)
            .eq('email', email)
            .eq('diterima', false)
            .maybeSingle();

    if (undangan == null) {
      throw 'Kode undangan tidak valid';
    }

    return _signUp(
      email: email,
      password: password,
      role: 'karyawan',
      metadata: {
        'nama_lengkap': namaLengkap,
        'kode_undangan': kodeUndangan,
        'jenis_kelamin': jenisKelamin,
      },
      profileFile: profileFile,
    );
  }

  @override
  Future<User> signUpPemilikUsaha({
    required String email,
    required String password,
    required String namaLengkap,
    required String namaUsaha,
    required String alamatUsaha,
    required File profileFile,
    required File logoFile,
    required String jenisKelamin,
  }) async {
    return _signUp(
      email: email,
      password: password,
      role: 'pemilik_usaha',
      metadata: {
        'nama_lengkap': namaLengkap,
        'nama_usaha': namaUsaha,
        'alamat_usaha': alamatUsaha,
        'jenis_kelamin': jenisKelamin,
      },
      profileFile: profileFile,
      logoFile: logoFile,
    );
  }

  Future<User> _signUp({
    required String email,
    required String password,
    required String role,
    required Map<String, dynamic> metadata,
    required File profileFile,
    File? logoFile,
  }) async {
    // Register user
    final authResponse = await _supabaseClient.auth.signUp(
      email: email,
      password: password,
      data: {...metadata, 'role': role},
    );

    if (authResponse.session == null || authResponse.user == null) {
      throw 'Terjadi kesalahan, silakan coba lagi';
    }

    // Upload files
    final userId = authResponse.user!.id;
    final profileFileName = '$role/$userId';
    await _uploadFile('profile', profileFileName, profileFile);

    String? logoUrl;
    if (logoFile != null) {
      final logoFileName = 'logo/${metadata['nama_usaha']}-$userId';
      await _uploadFile('logo', logoFileName, logoFile);
      logoUrl = await _createSignedUrl('logo', logoFileName);
    }

    final profileUrl = await _createSignedUrl('profile', profileFileName);

    // Update profile URL in the database
    await _supabaseClient
        .from(role == 'pemilik_usaha' ? 'pemilik_usaha' : 'karyawan')
        .update({'profile_url': profileUrl})
        .eq('user_id', userId);

    if (role == 'pemilik_usaha') {
      final pemilikId =
          await _supabaseClient
              .from('pemilik_usaha')
              .select('id')
              .eq('user_id', userId)
              .single();

      await _supabaseClient
          .from('usaha')
          .update({'logo_url': logoUrl})
          .eq('pemilik_id', pemilikId['id']);
    }

    return getCurrentUser();
  }

  Future<void> _uploadFile(
    String bucketName,
    String fileName,
    File file,
  ) async {
    await _supabaseClient.storage.from(bucketName).upload(fileName, file);
  }

  Future<String> _createSignedUrl(String bucketName, String fileName) async {
    final signedUrl = await _supabaseClient.storage
        .from(bucketName)
        .createSignedUrl(fileName, 60 * 60 * 24 * 365 * 10);
    return signedUrl;
  }

  @override
  void close() {
    _supabaseClient.auth.dispose();
  }
}
