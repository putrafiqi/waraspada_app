import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'authencation/authentication.dart';
import 'common/widget/widget.dart';
import 'home_karyawan/home_karyawan.dart';
import 'home_pemilik_usaha/home_pemilik_usaha.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const SignInPage()),
              (route) => false,
            );
          } else if (state is Authenticated) {
            if (state.user.role == 'pemilik_usaha') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePemilikUsahaPage()),
                (route) => false,
              );
            } else if (state.user.role == 'karyawan') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeKaryawanPage()),
                (route) => false,
              );
            }
          }
        },
        child: const Loader(),
      ),
    );
  }
}
