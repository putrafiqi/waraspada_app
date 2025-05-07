import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/data.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticationRepository _authenticationRepository;
  AuthBloc(AuthenticationRepository authenticationRepository)
    : _authenticationRepository = authenticationRepository,
      super(AuthInitial()) {
    on<AuthCheckRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await _authenticationRepository.getCurrentUser();
      result.fold(
        (failure) => emit(Unauthenticated(false)),
        (user) => emit(Authenticated(user)),
      );
    });

    on<AuthSignInRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await _authenticationRepository.signIn(
        email: event.email,
        password: event.password,
      );
      result.fold(
        (failure) => emit(Unauthenticated(true, failure.message)),
        (user) => emit(Authenticated(user)),
      );
    });

    on<AuthSignUpKaryawanRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await _authenticationRepository.signUpKaryawan(
        email: event.email,
        password: event.password,
        namaLengkap: event.namaLengkap,
        kodeUndangan: event.kodeUndangan,
        profileFile: event.profileFile,
        jenisKelamin: event.jenisKelamin,
      );
      result.fold(
        (failure) => emit(Unauthenticated(true, failure.message)),
        (user) => emit(Authenticated(user)),
      );
    });

    on<AuthSignUpPemilikUsahaRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await _authenticationRepository.signUpPemilikUsaha(
        email: event.email,
        password: event.password,
        namaLengkap: event.namaLengkap,
        namaUsaha: event.namaUsaha,
        alamatUsaha: event.alamatUsaha,
        profileFile: event.profileFile,
        logoFile: event.logoFile,
        jenisKelamin: event.jenisKelamin,
      );
      result.fold(
        (failure) => emit(Unauthenticated(true, failure.message)),
        (user) => emit(Authenticated(user)),
      );
    });

    on<AuthSignOutRequested>((event, emit) async {
      emit(AuthLoading());
      await _authenticationRepository.signOut();
      emit(Unauthenticated(false));
    });
  }
}
