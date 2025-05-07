import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/dialog/dialog.dart';
import '../../common/widget/widget.dart';
import '../bloc/distribusi_penyebab_stres_usaha/distribusi_penyebab_stres_usaha_bloc.dart';

class DistribusiPenyebabStresUsahaWidget extends StatelessWidget {
  const DistribusiPenyebabStresUsahaWidget({
    super.key,
    required this.selectedTahun,
    required this.selectedMonth,
    required this.onChangedYear,
    required this.onChangedMonth,
  });

  final int selectedTahun;
  final int selectedMonth;

  final void Function(String?)? onChangedYear;
  final void Function(String?)? onChangedMonth;

  final List<Color> kategoriColor = const [
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.blue,
    Colors.purple,
  ];
  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 24,
        children: [
          Text('Distribusi Penyebab Stres', style: textTheme.titleMedium),
          DropdownDatePicker(
            inputDecoration: InputDecoration(enabled: false),
            boxDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),

              border: Border.all(color: Colors.grey.shade200),
            ),
            isDropdownHideUnderline: true,
            showDay: false,
            endYear: selectedTahun,
            startYear: selectedTahun - 3,
            selectedYear: selectedTahun,
            selectedMonth: selectedMonth,

            onChangedYear: onChangedYear,
            locale: 'id_ID',
            onChangedMonth: onChangedMonth,
          ),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: BlocConsumer<
              DistribusiPenyebabStresUsahaBloc,
              DistribusiPenyebabStresUsahaState
            >(
              listener: (context, state) {
                if (state.status ==
                    DistribusiPenyebabStresUsahaStatus.failure) {
                  ShowToast.showEror(state.errorMessage ?? 'Terjadi kesalahan');
                }
              },
              builder: (context, state) {
                if (state.status ==
                    DistribusiPenyebabStresUsahaStatus.loading) {
                  return const Loader();
                }
                final data = state.distribusiPenyebabStres;
                return BarChart(
                  BarChartData(
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (touchedSpot) => Colors.white,
                      ),
                    ),
                    barGroups:
                        data
                            .map(
                              (e) => BarChartGroupData(
                                x: data.indexOf(e),
                                barRods:
                                    e.penyebab
                                        .map(
                                          (p) => BarChartRodData(
                                            toY:
                                                (p['jumlah'] as num).toDouble(),
                                            color:
                                                kategoriColor[e.penyebab
                                                    .indexOf(p)],
                                            width: 12,
                                          ),
                                        )
                                        .toList(),
                              ),
                            )
                            .toList(),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        left: BorderSide(color: Colors.grey),
                        bottom: BorderSide(color: Colors.grey),
                      ),
                    ),
                    gridData: FlGridData(
                      drawHorizontalLine: true,
                      show: true,
                      drawVerticalLine: true,
                      verticalInterval: 1,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.green.shade300,
                          strokeWidth: 1,
                          dashArray: [4, 4],
                        );
                      },
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          strokeWidth: 3,
                          color: Colors.green.shade300,
                          dashArray: [4, 4],
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          reservedSize: 24,
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            Widget text;
                            switch (value.toInt()) {
                              case 2:
                                text = Text(
                                  'Tinggi',
                                  style: textTheme.labelSmall,
                                );
                                break;
                              case 1:
                                text = Text(
                                  'Sedang',
                                  style: textTheme.labelSmall,
                                );
                                break;
                              case 0:
                                text = Text(
                                  'Ringan',
                                  style: textTheme.labelSmall,
                                );
                                break;

                              default:
                                text = const Text('');
                            }
                            return SideTitleWidget(
                              space: 0,
                              meta: meta,
                              child: text,
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        axisNameSize: 24,
                        axisNameWidget: Text(
                          'Jumlah Karyawan',
                          style: textTheme.labelSmall,
                        ),
                        sideTitles: SideTitles(
                          showTitles: true,
                          minIncluded: false,
                          maxIncluded: false,
                          getTitlesWidget:
                              (value, meta) => SideTitleWidget(
                                space: 4,
                                meta: meta,
                                child: Text(
                                  value.toStringAsFixed(0),
                                  textAlign: TextAlign.center,
                                  style: textTheme.labelSmall,
                                ),
                              ),
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            spacing: 16,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Tooltip(
                message: 'Ketaksaan Peran',
                triggerMode: TooltipTriggerMode.tap,
                child: Column(
                  spacing: 4,
                  children: [
                    CircleAvatar(backgroundColor: kategoriColor[0], radius: 5),
                    Text('TP', style: textTheme.labelSmall),
                  ],
                ),
              ),
              Tooltip(
                message: 'Konflik Peran',
                triggerMode: TooltipTriggerMode.tap,

                child: Column(
                  spacing: 4,

                  children: [
                    CircleAvatar(backgroundColor: kategoriColor[1], radius: 5),
                    Text('KP', style: textTheme.labelSmall),
                  ],
                ),
              ),
              Tooltip(
                message: 'Beban Berlebih',
                triggerMode: TooltipTriggerMode.tap,
                child: Column(
                  spacing: 4,

                  children: [
                    CircleAvatar(backgroundColor: kategoriColor[2], radius: 5),
                    Text('BB', style: textTheme.labelSmall),
                  ],
                ),
              ),
              Tooltip(
                message: 'Pengembangan Karir',
                triggerMode: TooltipTriggerMode.tap,
                child: Column(
                  spacing: 4,

                  children: [
                    CircleAvatar(backgroundColor: kategoriColor[3], radius: 5),
                    Text('PK', style: textTheme.labelSmall),
                  ],
                ),
              ),
              Tooltip(
                message: 'Tanggung Jawab Orang Lain',
                triggerMode: TooltipTriggerMode.tap,
                child: Column(
                  spacing: 4,
                  children: [
                    CircleAvatar(backgroundColor: kategoriColor[4], radius: 5),
                    Text('TJO', style: textTheme.labelSmall),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
