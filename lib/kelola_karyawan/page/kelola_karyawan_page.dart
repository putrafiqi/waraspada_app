import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../authencation/authentication.dart';
import '../../common/blocs/blocs.dart';
import '../../common/dialog/dialog.dart';
import '../../common/widget/widget.dart';
import '../../data/data.dart';
import '../bloc/kelola_karyawan_bloc.dart';

class KelolaKaryawanPage extends StatelessWidget {
  const KelolaKaryawanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final usahaId =
        (context.read<AuthBloc>().state as Authenticated).user.usahaId;
    return BlocProvider(
      create:
          (context) =>
              KelolaKaryawanBloc(context.read<KelolaKaryawanRepository>())
                ..add(AmbilListKaryawanRequested(usahaId)),
      child: const KelolaKaryawanView(),
    );
  }
}

class KelolaKaryawanView extends StatefulWidget {
  const KelolaKaryawanView({super.key});

  @override
  State<KelolaKaryawanView> createState() => _KelolaKaryawanViewState();
}

class _KelolaKaryawanViewState extends State<KelolaKaryawanView> {
  final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text('Kelola Karyawan'),
      ),
      backgroundColor: Colors.white,

      floatingActionButton: _KfloatingActionButton(
        onPressed: () {
          showDialog<bool>(
            barrierDismissible: false,
            context: context,
            builder:
                (_) => BlocProvider.value(
                  value: context.read<KelolaKaryawanBloc>(),
                  child: AlertDialog(
                    backgroundColor: Colors.white,
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () {
                          if (emailFormKey.currentState!.validate()) {
                            context.read<KelolaKaryawanBloc>().add(
                              UndangKaryawanPressed(
                                (context.read<AuthBloc>().state
                                        as Authenticated)
                                    .user
                                    .usahaId,
                                emailController.text.trim(),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Tambah'),
                      ),
                    ],
                    content: Form(
                      key: emailFormKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 16,
                        children: [
                          Text('Undang Karyawan', style: textTheme.titleLarge),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 8,
                            children: [
                              Text('Email', style: textTheme.labelLarge),
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
                                decoration: const InputDecoration(
                                  hintText: 'Masukan email karyawan anda',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          );

          emailController.clear();
        },
        child: Icon(LucideIcons.plus),
      ),
      body: _KrefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration.zero);
          if (!context.mounted) return;
          final usahaId =
              (context.read<AuthBloc>().state as Authenticated).user.usahaId;
          context.read<KelolaKaryawanBloc>().add(
            AmbilListKaryawanRequested(usahaId),
          );
        },
        child: BlocConsumer<KelolaKaryawanBloc, KelolaKaryawanState>(
          listener: (context, state) {
            if (state.status == KelolaKaryawanStatus.failure) {
              ShowToast.showEror(state.errorMessage ?? 'Gagal memuat data');
            }
          },
          builder: (context, state) {
            if (state.status == KelolaKaryawanStatus.loading) {
              return const Loader();
            }
            if (state.listKaryawan.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 16,
                  children: [
                    Icon(LucideIcons.userRoundX, size: 56, color: Colors.grey),
                    Text(
                      'Tidak ada karyawan',
                      style: textTheme.labelLarge?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: state.listKaryawan.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final karyawan = state.listKaryawan[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey.shade200),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    trailing: Text(
                      karyawan.undanganStatus ? 'Aktif' : 'Tidak Aktif',
                    ),
                    leading: CircleAvatar(
                      backgroundImage:
                          karyawan.profileUrl != null
                              ? NetworkImage(karyawan.profileUrl!)
                              : null,
                      child: const Icon(LucideIcons.user),
                    ),
                    title: Text(karyawan.namaLengkap ?? '-'),
                    subtitle: Text(karyawan.email),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _KrefreshIndicator extends StatelessWidget {
  const _KrefreshIndicator({required this.onRefresh, required this.child});

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isConnected = context.watch<NetworkCheckerBloc>().state.isConnected;
    return RefreshIndicator(
      onRefresh: isConnected ? onRefresh : () async {},
      child: child,
    );
  }
}

class _KfloatingActionButton extends StatelessWidget {
  const _KfloatingActionButton({required this.onPressed, required this.child});

  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isConnected = context.watch<NetworkCheckerBloc>().state.isConnected;
    return FloatingActionButton(
      onPressed: isConnected ? onPressed : null,
      child: child,
    );
  }
}
