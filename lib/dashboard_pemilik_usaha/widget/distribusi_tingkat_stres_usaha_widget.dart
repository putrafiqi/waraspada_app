import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/dialog/dialog.dart';
import '../../common/widget/widget.dart';
import '../bloc/distribusi_tingkat_stres_usaha/distribusi_tingkat_stres_usaha_bloc.dart';

class DistribusiTingkatStresUsahaWidget extends StatelessWidget {
  const DistribusiTingkatStresUsahaWidget({
    super.key,
    required this.selectedTahun,
    required this.selectedMonth,
    required this.onChangedTahun,
    required this.onChangedMonth,
  });

  final int selectedTahun;
  final int selectedMonth;
  final void Function(String?)? onChangedTahun;
  final void Function(String?)? onChangedMonth;

  final List<Color> kategoriColor = const [
    Colors.green,
    Colors.yellow,
    Colors.red,
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
          Text('Distribusi Tingkat Stres', style: textTheme.titleMedium),
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
            locale: 'id_ID',
            onChangedMonth: onChangedMonth,
            onChangedYear: onChangedTahun,
          ),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: BlocConsumer<
              DistribusiTingkatStresUsahaBloc,
              DistribusiTingkatStresUsahaState
            >(
              listener: (context, state) {
                if (state.status == DistribusiTingkatStresUsahaStatus.failure) {
                  ShowToast.showEror(state.errorMessage ?? 'Terjadi kesalahan');
                }
              },
              builder: (context, state) {
                if (state.status == DistribusiTingkatStresUsahaStatus.loading) {
                  return const Loader();
                }

                final data = state.distribusiTingkatStres;
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
                                barRods: [
                                  BarChartRodData(
                                    toY: e.jumlah.toDouble(),
                                    color: kategoriColor[data.indexOf(e)],
                                    width: 12,
                                  ),
                                ],
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
                          interval: 1,
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
                          interval: 10,
                          showTitles: true,
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
        ],
      ),
    );
  }
}
