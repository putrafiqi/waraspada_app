import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../authencation/authentication.dart';
import '../../common/dialog/dialog.dart';
import '../../common/widget/widget.dart';
import '../../dashboard_karyawan/dashboard_karyawan.dart';
import '../../data/data.dart';
import '../bloc/survei_karyawan_bloc.dart';
import '../widget/soal_box.dart';
import 'hasil_survei_page.dart';

class SurveiKaryawanPage extends StatelessWidget {
  const SurveiKaryawanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              SurveiKaryawanBloc(context.read<SurveiKaryawanRepository>())
                ..add(SurveiKaryawanInitialized()),
      child: const SurveiKaryawanView(),
    );
  }
}

class SurveiKaryawanView extends StatelessWidget {
  const SurveiKaryawanView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final isCancel = await _handlePop(context);
        if (isCancel != null && isCancel) {
          if (!context.mounted) return;
          context.read<SurveiKaryawanBloc>().add(SurveiKaryawanReset());
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(context),
        body: _buildBody(context),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      title: const Text('Survei Stres Kerja'),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(LucideIcons.x),
        onPressed: () async {
          final isCancel = await _handlePop(context);
          if (isCancel != null && isCancel) {
            if (!context.mounted) return;
            context.read<SurveiKaryawanBloc>().add(SurveiKaryawanReset());
            Navigator.of(context).pop();
          }
        },
      ),
      actions: [
        BlocBuilder<SurveiKaryawanBloc, SurveiKaryawanState>(
          buildWhen:
              (previous, current) =>
                  previous.totalAnswered != current.totalAnswered ||
                  previous.status != current.status,
          builder: (context, state) {
            if (state.soalList.isEmpty) return const SizedBox.shrink();

            final totalAnswered = state.totalAnswered;
            final totalSoal = state.soalList.length;

            return totalAnswered != totalSoal
                ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    '$totalAnswered/$totalSoal',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                )
                : IconButton(
                  onPressed: () {
                    final karyawanId =
                        (context.read<AuthBloc>().state as Authenticated)
                            .user
                            .id;
                    final hasilSurvei = _hitungHasilSurvei(state.soalList);

                    context.read<SurveiKaryawanBloc>().add(
                      SurveiKaryawanSubmitted(
                        karyawanId: karyawanId,
                        hasilSurvei: hasilSurvei,
                      ),
                    );
                  },
                  icon: const Icon(LucideIcons.sendHorizontal),
                );
          },
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocConsumer<SurveiKaryawanBloc, SurveiKaryawanState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == SurveiStatus.success) {
          final karyawanId =
              (context.read<AuthBloc>().state as Authenticated).user.id;
          context.read<CheckSurveiBloc>().add(CheckSurveiRequested(karyawanId));

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (_) => HasilSurveiPage(
                    hasilSurvei: _hitungHasilSurvei(state.soalList),
                  ),
            ),
          );
        } else if (state.status == SurveiStatus.error) {
          ShowToast.showEror(state.errorMessage ?? 'Terjadi kesalahan');
        }
      },
      buildWhen:
          (previous, current) =>
              previous.status != current.status ||
              previous.soalList != current.soalList,
      builder: (context, state) {
        if (state.status == SurveiStatus.loading) {
          return const Center(child: Loader());
        }

        return SafeArea(
          child:
              state.soalList.isEmpty
                  ? const Center(child: Text('Tidak ada soal tersedia'))
                  : _buildSoalList(context, state.soalList),
        );
      },
    );
  }

  Widget _buildSoalList(BuildContext context, List<Soal> soalList) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: soalList.length + 1, // +1 for bottom padding
      itemBuilder: (context, index) {
        if (index == soalList.length) {
          return const Gap(16); // Bottom padding
        }

        final soal = soalList[index];
        return _SoalBoxWidget(soal: soal, index: index);
      },
    );
  }

  Future<bool?> _handlePop(BuildContext context) {
    return showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('Apakah Anda yakin ingin keluar?'),
            content: const Text(
              'Jawaban yang sudah Anda isi tidak akan disimpan.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Tidak'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Ya'),
              ),
            ],
          ),
    );
  }

  HasilSurvei _hitungHasilSurvei(List<Soal> soalList) {
    int getTotalByKategori(String kategori) {
      final soalKategori =
          soalList.where((soal) => soal.kategori == kategori).toList();

      int total = 0;
      for (var soal in soalKategori) {
        if (soal.jawaban != null) {
          total += soal.jawaban!;
        }
      }

      if (kategori == 'BB') {
        return total ~/ 2;
      }

      return total;
    }

    return HasilSurvei(
      skorTP: getTotalByKategori('TP'),
      skorBB: getTotalByKategori('BB'),
      skorKP: getTotalByKategori('KP'),
      skorPK: getTotalByKategori('PK'),
      skorTJO: getTotalByKategori('TJO'),
    );
  }
}

class _SoalBoxWidget extends StatelessWidget {
  final Soal soal;
  final int index;

  const _SoalBoxWidget({required this.soal, required this.index});

  @override
  Widget build(BuildContext context) {
    return SoalBox(
      soal: soal.teks,
      jawaban: soal.jawaban,
      onChanged: (value) {
        if (value != null) {
          context.read<SurveiKaryawanBloc>().add(
            SoalJawabanChanged(index: index, jawaban: value),
          );
        }
      },
    );
  }
}
