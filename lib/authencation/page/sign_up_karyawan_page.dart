import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../common/dialog/dialog.dart';
import '../../common/widget/widget.dart';
import '../bloc/auth_bloc.dart';

class SignUpKaryawanPage extends StatelessWidget {
  const SignUpKaryawanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SignUpKaryawanView();
  }
}

class SignUpKaryawanView extends StatefulWidget {
  const SignUpKaryawanView({super.key});

  @override
  State<SignUpKaryawanView> createState() => _SignUpKaryawanViewState();
}

class _SignUpKaryawanViewState extends State<SignUpKaryawanView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController namaLengkapController = TextEditingController();
  final TextEditingController jenisKelaminController = TextEditingController();
  final TextEditingController kodeUndanganController = TextEditingController();

  File? profileFile;
  bool isShowPassword = false;

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
            child: Form(
              key: formKey,
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Profile
                      SizedBox(
                        child: Center(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(64),
                            onTap: handlePickImage,
                            child: Stack(
                              alignment: AlignmentDirectional.bottomEnd,
                              children: [
                                CircleAvatar(
                                  radius: 64,
                                  backgroundImage:
                                      profileFile != null
                                          ? FileImage(profileFile!)
                                          : null,
                                  child:
                                      profileFile == null
                                          ? Icon(
                                            LucideIcons.userPen,
                                            size: 64,
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
                            borderRadius: BorderRadius.all(Radius.circular(8)),
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
                            borderRadius: BorderRadius.all(Radius.circular(8)),
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
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'Perempuan',
                            child: Text(
                              'Perempuan',
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            jenisKelaminController.text = value ?? '';
                          });
                        },
                      ),

                      //Kode Undangan
                      Gap(16),
                      Text('Kode Undangan', style: textTheme.labelLarge),
                      Gap(8),
                      TextFormField(
                        controller: kodeUndanganController,
                        validator:
                            ValidationBuilder(
                              localeName: 'id',
                            ).required().build(),
                        onTapOutside: (_) {
                          FocusScope.of(context).unfocus();
                        },
                        decoration: InputDecoration(
                          suffixIcon: Tooltip(
                            triggerMode: TooltipTriggerMode.tap,
                            message:
                                'Didapatkan ketika anda telah diundang oleh atasan anda.',
                            child: Icon(LucideIcons.circleHelp),
                          ),
                          hintText: 'Masukan Kode Undangan',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                      ),

                      Gap(24),
                      FilledButton(
                        onPressed: () {
                          if (formKey.currentState!.validate() &&
                              profileFile != null) {
                            context.read<AuthBloc>().add(
                              AuthSignUpKaryawanRequested(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                                namaLengkapController.text.trim(),
                                kodeUndanganController.text.trim(),
                                jenisKelaminController.text.trim(),
                                profileFile!,
                              ),
                            );
                          }
                        },

                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          minimumSize: Size.fromHeight(46),
                        ),
                        child: Text('Daftar'),
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

  void handlePickImage() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(source: ImageSource.gallery);
    if (imageFile == null) return;
    setState(() {
      profileFile = File(imageFile.path);
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    jenisKelaminController.dispose();
    namaLengkapController.dispose();
    passwordController.dispose();
    kodeUndanganController.dispose();
    formKey.currentState?.dispose();
    super.dispose();
  }
}
