import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:waraspada_app/common/dialog/dialog.dart';

import '../../common/blocs/blocs.dart';
import '../../common/widget/widget.dart';
import '../../home_karyawan/home_karyawan.dart';
import '../../home_pemilik_usaha/home_pemilik_usaha.dart';
import '../bloc/auth_bloc.dart';
import 'sign_up_karyawan_page.dart';
import 'sign_up_pemilik_usaha_page.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SignInView();
  }
}

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isShowPassword = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<NetworkCheckerBloc, NetworkCheckerState>(
        listener: (context, state) {
          log('NetworkCheckerState: ${state.isConnected}');
          if (!state.isConnected) {
            ShowToast.showEror('Tidak ada koneksi internet');
          }
        },
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              if (state.user.role == 'pemilik_usaha') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePemilikUsahaPage(),
                  ),
                  (route) => false,
                );
              } else if (state.user.role == 'karyawan') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeKaryawanPage()),
                  (route) => false,
                );
              }
            } else if (state is Unauthenticated) {
              if (state.isError && state.message != null) {
                ShowToast.showEror(state.message ?? 'Terjadi kesalahan');
              }
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Loader();
            }
            return SafeArea(
              child: Form(
                key: formKey,
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          height: 200,
                          width: 200,
                        ),
                        Text(
                          'WARASPADA',
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade900,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Gap(12),
                        Text('Email', style: textTheme.labelLarge),
                        const Gap(8),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          validator:
                              ValidationBuilder(
                                localeName: 'id',
                              ).email().build(),
                          onTapOutside: (_) {
                            FocusScope.of(context).unfocus();
                          },
                          decoration: InputDecoration(
                            hintText: 'Masukan email anda',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const Gap(16),
                        Text('Password', style: textTheme.labelLarge),
                        const Gap(8),
                        TextFormField(
                          controller: passwordController,
                          obscureText: !isShowPassword,
                          validator:
                              ValidationBuilder(
                                localeName: 'id',
                              ).required().build(),
                          onTapOutside: (_) {
                            FocusScope.of(context).unfocus();
                          },
                          decoration: InputDecoration(
                            hintText: 'Masukan password anda',
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isShowPassword = !isShowPassword;
                                });
                              },
                              icon: Icon(
                                isShowPassword
                                    ? LucideIcons.eye
                                    : LucideIcons.eyeOff,
                              ),
                            ),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const Gap(24),
                        _KButton(
                          title: const Text('Sign In'),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                AuthSignInRequested(
                                  emailController.text,
                                  passwordController.text,
                                ),
                              );
                              emailController.clear();
                              passwordController.clear();
                            }
                          },
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Belum punya akun? '),
                            _DaftarTextButton(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    formKey.currentState?.dispose();
    super.dispose();
  }
}

class _KButton extends StatelessWidget {
  const _KButton({required this.onPressed, required this.title});

  final VoidCallback onPressed;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    final isConnected = context.watch<NetworkCheckerBloc>().state.isConnected;
    return FilledButton(
      onPressed: !isConnected ? null : onPressed,

      style: FilledButton.styleFrom(
        disabledForegroundColor: Colors.grey.shade600,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        minimumSize: const Size.fromHeight(46),
      ),
      child: isConnected ? title : const Icon(LucideIcons.wifiOff),
    );
  }
}

class _DaftarTextButton extends StatelessWidget {
  const _DaftarTextButton();

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return TextButton(
      onPressed: () {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder:
              (context) => BottomSheet(
                backgroundColor: Colors.white,
                enableDrag: false,
                onClosing: () {},
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Daftar Sebagai',
                          style: textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                        const Gap(16),
                        _KButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SignUpPemilikUsahaPage(),
                              ),
                            );
                          },
                          title: const Text('Pemilik Usaha'),
                        ),

                        const Gap(16),
                        _KButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SignUpKaryawanPage(),
                              ),
                            );
                          },
                          title: const Text('Karyawan'),
                        ),
                      ],
                    ),
                  );
                },
              ),
        );
      },
      child: const Text('Daftar'),
    );
  }
}
