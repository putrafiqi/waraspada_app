import 'dart:developer';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart'
    as supabase
    show AuthException, PostgrestException;

import '../../common/exception/exception.dart';
import '../data_source/data_source.dart';
import '../model/model.dart';
import 'package:fpdart/fpdart.dart';

typedef AuthencationResult = Either<AuthException, User>;

abstract class AuthenticationRepository {
  Future<AuthencationResult> signIn({
    required String email,
    required String password,
  });

  Future<AuthencationResult> signUpPemilikUsaha({
    required String email,
    required String password,
    required String namaLengkap,
    required String namaUsaha,
    required String alamatUsaha,
    required File profileFile,
    required File logoFile,
    required String jenisKelamin,
  });

  Future<AuthencationResult> signUpKaryawan({
    required String email,
    required String password,
    required String namaLengkap,
    required String kodeUndangan,
    required File profileFile,
    required String jenisKelamin,
  });

  Future<AuthencationResult> getCurrentUser();

  Future<void> signOut();

  void dispose();
}

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  const AuthenticationRepositoryImpl({
    required AuthenticationApi authenticationApi,
  }) : _authenticationApi = authenticationApi;

  final AuthenticationApi _authenticationApi;

  @override
  Future<AuthencationResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _authenticationApi.signIn(
        email: email,
        password: password,
      );
      return right(user);
    } on supabase.AuthException catch (e) {
      return left(AuthException(e.message));
    } on supabase.PostgrestException catch (e) {
      return left(AuthException(e.message));
    } catch (e) {
      return left(AuthException(e.toString()));
    }
  }

  @override
  void dispose() {
    _authenticationApi.close();
  }

  @override
  Future<AuthencationResult> getCurrentUser() async {
    try {
      final user = await _authenticationApi.getCurrentUser();
      return right(user);
    } on supabase.AuthException catch (e) {
      return left(AuthException(e.message));
    } on supabase.PostgrestException catch (e) {
      return left(AuthException(e.message));
    } catch (e) {
      return left(AuthException(e.toString()));
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _authenticationApi.signOut();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthencationResult> signUpKaryawan({
    required String email,
    required String password,
    required String namaLengkap,
    required String kodeUndangan,
    required File profileFile,
    required String jenisKelamin,
  }) async {
    try {
      final user = await _authenticationApi.signUpKaryawan(
        email: email,
        password: password,
        namaLengkap: namaLengkap,
        kodeUndangan: kodeUndangan,
        profileFile: profileFile,
        jenisKelamin: jenisKelamin,
      );
      return right(user);
    } on supabase.AuthException catch (e) {
      return left(AuthException(e.message));
    } on supabase.PostgrestException catch (e) {
      return left(AuthException(e.message));
    } catch (e) {
      return left(AuthException(e.toString()));
    }
  }

  @override
  Future<AuthencationResult> signUpPemilikUsaha({
    required String email,
    required String password,
    required String namaLengkap,
    required String namaUsaha,
    required String alamatUsaha,
    required File profileFile,
    required File logoFile,
    required String jenisKelamin,
  }) async {
    try {
      final user = await _authenticationApi.signUpPemilikUsaha(
        email: email,
        password: password,
        namaLengkap: namaLengkap,
        namaUsaha: namaUsaha,
        alamatUsaha: alamatUsaha,
        profileFile: profileFile,
        logoFile: logoFile,
        jenisKelamin: jenisKelamin,
      );
      return right(user);
    } on supabase.AuthException catch (e) {
      log('AuthException: ${e.message}');
      return left(AuthException(e.message));
    } on supabase.PostgrestException catch (e) {
      log('PostgrestException: ${e.message}');
      return left(AuthException(e.message));
    } catch (e) {
      return left(AuthException(e.toString()));
    }
  }
}
