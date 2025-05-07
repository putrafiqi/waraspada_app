import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../authencation/authentication.dart';
import '../../data/repository/repository.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/distribusi_penyebab_stres_usaha/distribusi_penyebab_stres_usaha_bloc.dart';
import '../bloc/distribusi_tingkat_stres_usaha/distribusi_tingkat_stres_usaha_bloc.dart';
import '../bloc/tren_penyebab_stres_usaha/tren_penyebab_stres_usaha_bloc.dart';
import '../bloc/tren_tingkat_stres_usaha/tren_tingkat_stres_usaha_bloc.dart';
import '../widget/distribusi_penyebab_stres_usaha_widget.dart';
import '../widget/distribusi_tingkat_stres_usaha_widget.dart';
import '../widget/tren_penyebab_stres_usaha_widget.dart';
import '../widget/tren_tingkat_stres_usaha_widget.dart';

class DashboardPemilikUsahaPage extends StatelessWidget {
  const DashboardPemilikUsahaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final usahaId =
        (context.read<AuthBloc>().state as Authenticated).user.usahaId;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => DistribusiPenyebabStresUsahaBloc(
                context.read<DataVisualisasiRepository>(),
              )..add(
                DistribusiPenyebabStresUsahaRequested(
                  usahaId,
                  DateTime.now().year,
                  DateTime.now().month,
                ),
              ),
        ),
        BlocProvider(
          create:
              (context) => DistribusiTingkatStresUsahaBloc(
                context.read<DataVisualisasiRepository>(),
              )..add(
                DistribusiTingkatStresUsahaRequested(
                  usahaId,
                  DateTime.now().year,
                  DateTime.now().month,
                ),
              ),
        ),
        BlocProvider(
          create:
              (context) => TrenTingkatStresUsahaBloc(
                context.read<DataVisualisasiRepository>(),
              )..add(
                TrenTingkatStresUsahaRequested(usahaId, DateTime.now().year),
              ),
        ),
        BlocProvider(
          create:
              (context) => TrenPenyebabStresUsahaBloc(
                context.read<DataVisualisasiRepository>(),
              )..add(
                TrenPenyebabStresUsahaRequested(usahaId, DateTime.now().year),
              ),
        ),
      ],
      child: DashboardPemilikUsahaView(),
    );
  }
}

class DashboardPemilikUsahaView extends StatefulWidget {
  const DashboardPemilikUsahaView({super.key});

  @override
  State<DashboardPemilikUsahaView> createState() =>
      _DashboardPemilikUsahaViewState();
}

class _DashboardPemilikUsahaViewState extends State<DashboardPemilikUsahaView> {
  int selectedTahunTrenTingkatStres = DateTime.now().year;
  int selectedTahunTrenPenyebabStres = DateTime.now().year;
  int selectedTahunDistribusiTingkatStres = DateTime.now().year;
  int selectedTahunDistribusiPenyebabStres = DateTime.now().year;
  int selectedMonthDistribusiTingkatStres = DateTime.now().month;
  int selectedMonthDistribusiPenyebabStres = DateTime.now().month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Dashboard'),

        forceMaterialTransparency: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration.zero);
          if (!context.mounted) return;
          context.read<TrenTingkatStresUsahaBloc>().add(
            TrenTingkatStresUsahaRequested(
              (context.read<AuthBloc>().state as Authenticated).user.usahaId,
              selectedTahunTrenTingkatStres,
            ),
          );
          context.read<TrenPenyebabStresUsahaBloc>().add(
            TrenPenyebabStresUsahaRequested(
              (context.read<AuthBloc>().state as Authenticated).user.usahaId,
              selectedTahunTrenPenyebabStres,
            ),
          );
          context.read<DistribusiTingkatStresUsahaBloc>().add(
            DistribusiTingkatStresUsahaRequested(
              (context.read<AuthBloc>().state as Authenticated).user.usahaId,
              selectedTahunDistribusiTingkatStres,
              selectedMonthDistribusiTingkatStres,
            ),
          );
          context.read<DistribusiPenyebabStresUsahaBloc>().add(
            DistribusiPenyebabStresUsahaRequested(
              (context.read<AuthBloc>().state as Authenticated).user.usahaId,
              selectedTahunDistribusiPenyebabStres,
              selectedMonthDistribusiPenyebabStres,
            ),
          );
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TrenTingkatStresUsahaWidget(
                  selectedTahun: selectedTahunTrenTingkatStres,
                  onYearChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedTahunTrenTingkatStres = int.parse(value);
                      });

                      final usahaId =
                          (context.read<AuthBloc>().state as Authenticated)
                              .user
                              .usahaId;
                      context.read<TrenTingkatStresUsahaBloc>().add(
                        TrenTingkatStresUsahaRequested(
                          usahaId,
                          selectedTahunTrenTingkatStres,
                        ),
                      );
                    }
                  },
                ),

                TrenPenyebabStresUsahaWidget(
                  selectedTahun: selectedTahunTrenPenyebabStres,
                  onChangedTahun: (value) {
                    if (value != null) {
                      setState(() {
                        selectedTahunTrenPenyebabStres = int.parse(value);
                      });

                      final usahaId =
                          (context.read<AuthBloc>().state as Authenticated)
                              .user
                              .usahaId;
                      context.read<TrenPenyebabStresUsahaBloc>().add(
                        TrenPenyebabStresUsahaRequested(
                          usahaId,
                          selectedTahunTrenPenyebabStres,
                        ),
                      );
                    }
                  },
                ),

                DistribusiTingkatStresUsahaWidget(
                  selectedTahun: selectedTahunDistribusiTingkatStres,
                  selectedMonth: selectedMonthDistribusiTingkatStres,
                  onChangedTahun: (value) {
                    if (value != null) {
                      setState(() {
                        selectedTahunDistribusiTingkatStres = int.parse(value);
                      });

                      final usahaId =
                          (context.read<AuthBloc>().state as Authenticated)
                              .user
                              .usahaId;
                      context.read<DistribusiTingkatStresUsahaBloc>().add(
                        DistribusiTingkatStresUsahaRequested(
                          usahaId,
                          selectedTahunDistribusiTingkatStres,
                          selectedMonthDistribusiTingkatStres,
                        ),
                      );
                    }
                  },
                  onChangedMonth: (value) {
                    if (value != null) {
                      setState(() {
                        selectedMonthDistribusiTingkatStres = int.parse(value);
                      });

                      final usahaId =
                          (context.read<AuthBloc>().state as Authenticated)
                              .user
                              .usahaId;
                      context.read<DistribusiTingkatStresUsahaBloc>().add(
                        DistribusiTingkatStresUsahaRequested(
                          usahaId,
                          selectedTahunDistribusiTingkatStres,
                          selectedMonthDistribusiTingkatStres,
                        ),
                      );
                    }
                  },
                ),
                DistribusiPenyebabStresUsahaWidget(
                  selectedTahun: selectedTahunDistribusiPenyebabStres,
                  selectedMonth: selectedMonthDistribusiPenyebabStres,
                  onChangedYear: (value) {
                    if (value != null) {
                      setState(() {
                        selectedTahunDistribusiPenyebabStres = int.parse(value);
                      });

                      final usahaId =
                          (context.read<AuthBloc>().state as Authenticated)
                              .user
                              .usahaId;
                      context.read<DistribusiPenyebabStresUsahaBloc>().add(
                        DistribusiPenyebabStresUsahaRequested(
                          usahaId,
                          selectedTahunDistribusiPenyebabStres,
                          selectedMonthDistribusiPenyebabStres,
                        ),
                      );
                    }
                  },
                  onChangedMonth: (value) {
                    if (value != null) {
                      setState(() {
                        selectedMonthDistribusiPenyebabStres = int.parse(value);
                      });

                      final usahaId =
                          (context.read<AuthBloc>().state as Authenticated)
                              .user
                              .usahaId;
                      context.read<DistribusiPenyebabStresUsahaBloc>().add(
                        DistribusiPenyebabStresUsahaRequested(
                          usahaId,
                          selectedTahunDistribusiPenyebabStres,
                          selectedMonthDistribusiPenyebabStres,
                        ),
                      );
                    }
                  },
                ),

                Gap(16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
