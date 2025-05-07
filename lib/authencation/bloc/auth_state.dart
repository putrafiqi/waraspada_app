part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();
}

final class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

final class AuthLoading extends AuthState {
  @override
  List<Object> get props => [];
}

final class Authenticated extends AuthState {
  final User user;

  const Authenticated(this.user);

  @override
  List<Object> get props => [user];
}

final class Unauthenticated extends AuthState {
   final String? message;
   final bool isError;

  const Unauthenticated(this.isError,[this.message]);

  @override
  List<Object> get props => [isError];
}
