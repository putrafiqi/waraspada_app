import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:waraspada_app/common/dialog/dialog.dart';

import '../../authencation/authentication.dart';
import '../../common/blocs/blocs.dart';
import '../../data/data.dart';
import '../../survei_karyawan/page/survei_karyawan_page.dart';
import '../bloc/check_survei/check_survei_bloc.dart';
import '../bloc/tren_penyebab_stres_karyawan/tren_penyebab_stres_karyawan_bloc.dart';
import '../bloc/tren_tingkat_stres_karyawan/tren_tingkat_stres_karyawan_bloc.dart';
import '../widget/tren_penyebab_stres_karyawan_widget.dart';
import '../widget/tren_tingkat_stres_karyawan_widget.dart';

class DashboardKaryawanPage extends StatelessWidget {
  const DashboardKaryawanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final karyawanId =
        (context.read<AuthBloc>().state as Authenticated).user.id;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  CheckSurveiBloc(context.read<SurveiKaryawanRepository>())
                    ..add(CheckSurveiRequested(karyawanId)),
        ),
        BlocProvider(
          create:
              (context) => TrenPenyebabStresKaryawanBloc(
                context.read<DataVisualisasiRepository>(),
              )..add(
                TrenPenyebabStresKaryawanRequested(
                  karyawanId,
                  DateTime.now().year,
                ),
              ),
        ),
        BlocProvider(
          create:
              (context) => TrenTingkatStresKaryawanBloc(
                context.read<DataVisualisasiRepository>(),
              )..add(
                TrenTingkatStresKaryawanRequested(
                  karyawanId,
                  DateTime.now().year,
                ),
              ),
        ),
      ],
      child: const DashboardKaryawanView(),
    );
  }
}

class DashboardKaryawanView extends StatefulWidget {
  const DashboardKaryawanView({super.key});

  @override
  State<DashboardKaryawanView> createState() => _DashboardKaryawanViewState();
}

class _DashboardKaryawanViewState extends State<DashboardKaryawanView> {
  int selectedTahunTrenTingkatStres = DateTime.now().year;
  int selectedTahunTrenPenyebabStres = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text('Dashboard'),
      ),
      body: _KrefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration.zero);
          if (!context.mounted) return;
          final karyawanId =
              (context.read<AuthBloc>().state as Authenticated).user.id;

          context.read<TrenTingkatStresKaryawanBloc>().add(
            TrenTingkatStresKaryawanRequested(
              karyawanId,
              selectedTahunTrenTingkatStres,
            ),
          );

          context.read<TrenPenyebabStresKaryawanBloc>().add(
            TrenPenyebabStresKaryawanRequested(
              karyawanId,
              selectedTahunTrenPenyebabStres,
            ),
          );
          context.read<CheckSurveiBloc>().add(CheckSurveiRequested(karyawanId));
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BlocConsumer<CheckSurveiBloc, CheckSurveiState>(
                  listener: (context, state) {
                    if (state.status == CheckSurveiStatus.failure) {
                      ShowToast.showEror(
                        state.errorMessage ?? 'Terjadi kesalahan',
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state.isSudahSurvei == true) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Anda sudah melakukan survei bulan ini',
                              style: textTheme.titleMedium?.copyWith(
                                color: Colors.green.shade900,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return _KinkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (_) => BlocProvider.value(
                                  value: context.read<CheckSurveiBloc>(),
                                  child: const SurveiKaryawanPage(),
                                ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Ada Survei Bulan ini',
                              style: textTheme.titleMedium,
                            ),
                            const Icon(LucideIcons.chevronRight),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                TrenTingkatStresKaryawanWidget(
                  selectedTahun: selectedTahunTrenTingkatStres,
                  onYearChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedTahunTrenTingkatStres = int.parse(value);
                      });
                      context.read<TrenTingkatStresKaryawanBloc>().add(
                        TrenTingkatStresKaryawanRequested(
                          (context.read<AuthBloc>().state as Authenticated)
                              .user
                              .id,
                          selectedTahunTrenTingkatStres,
                        ),
                      );
                    }
                  },
                ),
                TrenPenyebabStresKaryawanWidget(
                  selectedTahun: selectedTahunTrenPenyebabStres,
                  onYearChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedTahunTrenPenyebabStres = int.parse(value);
                      });
                      context.read<TrenPenyebabStresKaryawanBloc>().add(
                        TrenPenyebabStresKaryawanRequested(
                          (context.read<AuthBloc>().state as Authenticated)
                              .user
                              .id,
                          selectedTahunTrenPenyebabStres,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
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

class _KinkWell extends StatelessWidget {
  const _KinkWell({required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isConnected = context.watch<NetworkCheckerBloc>().state.isConnected;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap:
          isConnected
              ? onTap
              : () async {
                ShowToast.showEror('Tidak ada koneksi internet');
              },
      child: child,
    );
  }
}
