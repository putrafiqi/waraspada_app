import 'dart:io';
import 'dart:developer';

import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../common/dialog/dialog.dart';
import '../../common/widget/widget.dart';
import '../bloc/auth_bloc.dart';

class SignUpPemilikUsahaPage extends StatelessWidget {
  const SignUpPemilikUsahaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SignUpPemilikUsahaView();
  }
}

class SignUpPemilikUsahaView extends StatefulWidget {
  const SignUpPemilikUsahaView({super.key});

  @override
  State<SignUpPemilikUsahaView> createState() => _SignUpPemilikUsahaViewState();
}

class _SignUpPemilikUsahaViewState extends State<SignUpPemilikUsahaView> {
  final GlobalKey<FormState> formKeyAkun = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyUsaha = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController namaLengkapController = TextEditingController();
  final TextEditingController jenisKelaminController = TextEditingController();

  final TextEditingController namaUsahaController = TextEditingController();
  final TextEditingController alamatUsahaController = TextEditingController();

  bool isShowPassword = false;

  File? profileFile;
  File? logoFile;
  int activeStep = 0;

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            ShowToast.showSuccess('Berhasil mendaftar');
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Loader();
          }
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  EasyStepper(
                    showLoadingAnimation: false,
                    enableStepTapping: false,

                    activeStep: activeStep,
                    finishedStepBackgroundColor: Colors.green.shade600,
                    steps: [
                      EasyStep(
                        finishIcon: Icon(LucideIcons.check),
                        icon: Icon(LucideIcons.userPen),
                        title: 'Akun',
                      ),
                      EasyStep(icon: Icon(LucideIcons.hotel), title: 'Usaha'),
                    ],
                  ),
                  Gap(16),
                  IndexedStack(
                    index: activeStep,
                    alignment: Alignment.center,
                    children: [
                      Form(
                        key: formKeyAkun,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Profile
                            SizedBox(
                              child: Center(
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(64),
                                  onTap: handlePickImageAkun,
                                  child: Stack(
                                    alignment: AlignmentDirectional.bottomEnd,
                                    children: [
                                      CircleAvatar(
                                        radius: 56,
                                        backgroundImage:
                                            profileFile != null
                                                ? FileImage(profileFile!)
                                                : null,
                                        child:
                                            profileFile == null
                                                ? Icon(
                                                  LucideIcons.userPen,
                                                  size: 56,
                                                  color: Colors.green.shade900,
                                                )
                                                : null,
                                      ),
                                      IconButton.filled(
                                        style: IconButton.styleFrom(
                                          disabledBackgroundColor: Colors.green,
                                        ),
                                        onPressed: null,
                                        icon: Icon(
                                          LucideIcons.pen,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Gap(8),
                            Text(
                              'Foto Profile',
                              style: textTheme.labelLarge,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              '* Foto profile wajib diisi',
                              style: textTheme.labelSmall?.copyWith(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            //Nama Lengkap
                            Gap(16),
                            Text('Nama Lengkap', style: textTheme.labelLarge),
                            Gap(8),
                            TextFormField(
                              controller: namaLengkapController,
                              validator:
                                  ValidationBuilder(
                                    localeName: 'id',
                                  ).required().minLength(3).build(),
                              onTapOutside: (_) {
                                FocusScope.of(context).unfocus();
                              },
                              decoration: InputDecoration(
                                hintText: 'Masukan nama lengkap anda',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                              ),
                            ),

                            //Email
                            Gap(16),
                            Text('Email', style: textTheme.labelLarge),
                            Gap(8),
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

                            //Password
                            Gap(16),
                            Text('Password', style: textTheme.labelLarge),
                            Gap(8),
                            TextFormField(
                              controller: passwordController,
                              obscureText: !isShowPassword,
                              validator:
                                  ValidationBuilder(localeName: 'id')
                                      .required()
                                      .regExp(
                                        RegExp(r'^\S+$'),
                                        'Password tidak boleh mengandung spasi',
                                      )
                                      .minLength(8)
                                      .build(),
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
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                              ),
                            ),

                            //Jenis Kelamin
                            Gap(16),
                            Text('Jenis Kelamin', style: textTheme.labelLarge),
                            Gap(8),
                            DropdownButtonFormField<String>(
                              hint: Text('Pilih Jenis Kelamin'),
                              validator:
                                  ValidationBuilder(
                                    localeName: 'id',
                                  ).required().build(),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              items: [
                                DropdownMenuItem(
                                  value: 'Laki-laki',
                                  child: Text(
                                    'Laki-laki',
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'Perempuan',
                                  child: Text(
                                    'Perempuan',
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    jenisKelaminController.text = value;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      Form(
                        key: formKeyUsaha,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Logo
                            SizedBox(
                              child: Center(
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(64),
                                  onTap: handlePickImageUsaha,
                                  child: Stack(
                                    alignment: AlignmentDirectional.bottomEnd,
                                    children: [
                                      CircleAvatar(
                                        radius: 56,
                                        backgroundImage:
                                            logoFile != null
                                                ? FileImage(logoFile!)
                                                : null,
                                        child:
                                            logoFile == null
                                                ? Icon(
                                                  LucideIcons.userPen,
                                                  size: 56,
                                                  color: Colors.green.shade900,
                                                )
                                                : null,
                                      ),
                                      IconButton.filled(
                                        style: IconButton.styleFrom(
                                          disabledBackgroundColor: Colors.green,
                                        ),
                                        onPressed: null,
                                        icon: Icon(
                                          LucideIcons.pen,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Gap(8),
                            Text(
                              'Logo Usaha',
                              style: textTheme.labelLarge,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              '* Logo usaha wajib diisi',
                              style: textTheme.labelSmall?.copyWith(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            //Nama Lengkap
                            Gap(16),
                            Text('Nama Usaha', style: textTheme.labelLarge),
                            Gap(8),
                            TextFormField(
                              controller: namaUsahaController,
                              validator:
                                  ValidationBuilder(
                                    localeName: 'id',
                                  ).required().minLength(3).build(),
                              onTapOutside: (_) {
                                FocusScope.of(context).unfocus();
                              },
                              decoration: InputDecoration(
                                hintText: 'Masukan nama usaha anda',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                              ),
                            ),

                            //Email
                            Gap(16),
                            Text('Alamat', style: textTheme.labelLarge),
                            Gap(8),
                            TextFormField(
                              controller: alamatUsahaController,
                              validator:
                                  ValidationBuilder(
                                    localeName: 'id',
                                  ).required().build(),
                              onTapOutside: (_) {
                                FocusScope.of(context).unfocus();
                              },
                              decoration: InputDecoration(
                                hintText: 'Masukan alamat usaha anda',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  //Button
                  Gap(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FilledButton(
                        onPressed:
                            activeStep == 0
                                ? null
                                : () {
                                  setState(() {
                                    activeStep--;
                                  });
                                },

                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          // minimumSize: Size.fromHeight(46),
                        ),
                        child: Text('Kembali'),
                      ),

                      FilledButton(
                        onPressed: () {
                          if (activeStep == 0) {
                            if (formKeyAkun.currentState!.validate() &&
                                profileFile != null) {
                              setState(() {
                                activeStep++;
                              });
                            }
                          } else if (activeStep == 1) {
                            if (formKeyUsaha.currentState!.validate() &&
                                logoFile != null) {
                              log(jenisKelaminController.text);

                              context.read<AuthBloc>().add(
                                AuthSignUpPemilikUsahaRequested(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                  namaLengkapController.text.trim(),
                                  namaUsahaController.text.trim(),
                                  alamatUsahaController.text.trim(),
                                  jenisKelaminController.text.trim(),
                                  profileFile!,
                                  logoFile!,
                                ),
                              );
                            }
                          }
                        },

                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          // minimumSize: Size.fromHeight(46),
                        ),
                        child: Text(activeStep == 0 ? 'Selanjutnya' : 'Daftar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void handlePickImageAkun() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(source: ImageSource.gallery);
    if (imageFile == null) return;
    setState(() {
      profileFile = File(imageFile.path);
    });
  }

  void handlePickImageUsaha() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(source: ImageSource.gallery);
    if (imageFile == null) return;
    setState(() {
      logoFile = File(imageFile.path);
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    jenisKelaminController.dispose();
    namaLengkapController.dispose();
    passwordController.dispose();
    formKeyAkun.currentState?.dispose();
    alamatUsahaController.dispose();
    namaUsahaController.dispose();
    formKeyUsaha.currentState?.dispose();
    super.dispose();
  }
}
