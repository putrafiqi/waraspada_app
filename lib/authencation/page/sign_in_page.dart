import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:waraspada_app/common/dialog/dialog.dart';

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
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
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
                  padding: EdgeInsets.symmetric(horizontal: 16),
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
                      Gap(12),
                      Text('Email', style: textTheme.labelLarge),
                      Gap(8),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        validator:
                            ValidationBuilder(localeName: 'id').email().build(),
                        onTapOutside: (_) {
                          FocusScope.of(context).unfocus();
                        },
                        decoration: InputDecoration(
                          hintText: 'Masukan email anda',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                      ),
                      Gap(16),
                      Text('Password', style: textTheme.labelLarge),
                      Gap(8),
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
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                      ),
                      Gap(24),
                      FilledButton(
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

                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          minimumSize: Size.fromHeight(46),
                        ),
                        child: Text('Sign In'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Belum punya akun? '),
                          TextButton(
                            onPressed: () async {
                              final isPemilikUsaha = await showDialog<bool>(
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Daftar Sebagai',
                                                style: textTheme.titleMedium,
                                                textAlign: TextAlign.center,
                                              ),
                                              Gap(16),
                                              FilledButton(
                                                onPressed: () {
                                                  Navigator.pop(context, true);
                                                },

                                                style: FilledButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                          Radius.circular(8),
                                                        ),
                                                  ),
                                                  minimumSize: Size.fromHeight(
                                                    46,
                                                  ),
                                                ),
                                                child: Text('Pemilik Usaha'),
                                              ),
                                              Gap(16),
                                              FilledButton(
                                                onPressed: () {
                                                  Navigator.pop(context, false);
                                                },

                                                style: FilledButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                          Radius.circular(8),
                                                        ),
                                                  ),
                                                  minimumSize: Size.fromHeight(
                                                    46,
                                                  ),
                                                ),
                                                child: Text('Karyawan'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                              );
                              if (isPemilikUsaha == null) return;
                              if (isPemilikUsaha) {
                                if (!context.mounted) return;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => const SignUpPemilikUsahaPage(),
                                  ),
                                );
                              } else {
                                if (!context.mounted) return;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SignUpKaryawanPage(),
                                  ),
                                );
                              }
                            },
                            child: Text('Daftar'),
                          ),
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
