part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
}

final class AuthCheckRequested extends AuthEvent {
  @override
  List<Object> get props => [];
}

final class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInRequested(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

final class AuthSignUpKaryawanRequested extends AuthEvent {
  final String email;
  final String password;
  final String namaLengkap;
  final String kodeUndangan;
  final String jenisKelamin;
  final File profileFile;

  const AuthSignUpKaryawanRequested(
    this.email,
    this.password,
    this.namaLengkap,
    this.kodeUndangan,
    this.jenisKelamin,
    this.profileFile,
  );

  @override
  List<Object> get props => [
    email,
    password,
    namaLengkap,
    kodeUndangan,
    jenisKelamin,
    profileFile,
  ];
}

final class AuthSignUpPemilikUsahaRequested extends AuthEvent {
  final String email;
  final String password;
  final String namaLengkap;
  final String namaUsaha;
  final String alamatUsaha;
  final String jenisKelamin;
  final File profileFile;
  final File logoFile;
  const AuthSignUpPemilikUsahaRequested(
    this.email,
    this.password,
    this.namaLengkap,
    this.namaUsaha,
    this.alamatUsaha,
    this.jenisKelamin,
    this.profileFile,
    this.logoFile,
  );

  @override
  List<Object> get props => [email, password];
}

final class AuthSignOutRequested extends AuthEvent {
  @override
  List<Object> get props => [];
}
