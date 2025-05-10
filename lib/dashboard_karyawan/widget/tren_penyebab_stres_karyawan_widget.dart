import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../common/dialog/dialog.dart';
import '../../common/widget/widget.dart';
import '../bloc/tren_penyebab_stres_karyawan/tren_penyebab_stres_karyawan_bloc.dart';

class TrenPenyebabStresKaryawanWidget extends StatelessWidget {
  const TrenPenyebabStresKaryawanWidget({
    super.key,
    required this.selectedTahun,
    required this.onYearChanged,
  });

  final int selectedTahun;
  final void Function(String?)? onYearChanged;

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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tren Penyebab Stres', style: textTheme.titleMedium),
              Tooltip(
                triggerMode: TooltipTriggerMode.tap,
                richMessage: TextSpan(
                  text: 'Ketegori Nilai Stres:',
                  children: [
                    TextSpan(text: '\n\tSkor < 9 : Stres Ringan'),
                    TextSpan(text: '\n\tSkor 10-24 : Stres Sedang'),
                    TextSpan(text: '\n\tSkor > 24 : Stres Berat'),
                  ],
                ),
                child: Icon(LucideIcons.info),
              ),
            ],
          ),
          DropdownDatePicker(
            inputDecoration: InputDecoration(enabled: false),
            boxDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),

              border: Border.all(color: Colors.grey.shade200),
            ),
            isDropdownHideUnderline: true,
            showDay: false,
            selectedYear: selectedTahun,
            showMonth: false,
            locale: 'id_ID',
            startYear: selectedTahun - 3,
            endYear: selectedTahun,
            onChangedYear: onYearChanged,
          ),

          AspectRatio(
            aspectRatio: 16 / 9,
            child: BlocConsumer<
              TrenPenyebabStresKaryawanBloc,
              TrenPenyebabStresKaryawanState
            >(
              listener: (context, state) {
                if (state.status == TrenPenyebabStresKaryawanStatus.failure) {
                  ShowToast.showEror(state.errorMessage ?? 'Terjadi Kesalahan');
                }
              },
              builder: (context, state) {
                if (state.status == TrenPenyebabStresKaryawanStatus.loading) {
                  return const Loader();
                }

                final data = state.data;
                return LineChart(
                  LineChartData(
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (touchedSpot) => Colors.white,
                      ),
                    ),

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
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey,
                          strokeWidth: 1,
                          dashArray: [4, 4],
                        );
                      },
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          strokeWidth: 1,
                          color: Colors.grey,
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
                            final textTheme = TextTheme.of(
                              context,
                            ).titleSmall?.copyWith(fontSize: 12);
                            Widget text;
                            switch (value.toInt()) {
                              case 1:
                                text = Text('Jan', style: textTheme);
                                break;
                              case 2:
                                text = Text('Feb', style: textTheme);
                                break;
                              case 3:
                                text = Text('Mar', style: textTheme);
                                break;
                              case 4:
                                text = Text('Apr', style: textTheme);
                                break;
                              case 5:
                                text = Text('Mei', style: textTheme);
                                break;
                              case 6:
                                text = Text('Jun', style: textTheme);
                                break;
                              case 7:
                                text = Text('Jul', style: textTheme);
                                break;
                              case 8:
                                text = Text('Agu', style: textTheme);
                                break;
                              case 9:
                                text = Text('Sep', style: textTheme);
                                break;
                              case 10:
                                text = Text('Okt', style: textTheme);
                                break;
                              case 11:
                                text = Text('Nov', style: textTheme);
                                break;
                              case 12:
                                text = Text('Des', style: textTheme);
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
                          'Skor',
                          style: textTheme.labelSmall,
                        ),
                        sideTitles: SideTitles(
                          showTitles: true,
                          minIncluded: false,
                          maxIncluded: false,
                          getTitlesWidget:
                              (value, meta) => SideTitleWidget(
                                meta: meta,
                                child: Text(
                                  value.toStringAsFixed(0),
                                  textAlign: TextAlign.center,
                                  style: TextTheme.of(
                                    context,
                                  ).titleSmall?.copyWith(fontSize: 12),
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
                    lineBarsData: [
                      LineChartBarData(
                        color: kategoriColor[0],
                        isCurved: true,
                        preventCurveOverShooting: true,
                        spots:
                            data
                                .map(
                                  (e) => FlSpot(
                                    e.bulan.toDouble(),
                                    e.skorKetaksaanPeran,
                                  ),
                                )
                                .toList(),
                      ),
                      LineChartBarData(
                        color: kategoriColor[1],
                        isCurved: true,
                        preventCurveOverShooting: true,

                        spots:
                            data
                                .map(
                                  (e) => FlSpot(
                                    e.bulan.toDouble(),
                                    e.skorKonfilePeran,
                                  ),
                                )
                                .toList(),
                      ),
                      LineChartBarData(
                        color: kategoriColor[2],
                        isCurved: true,
                        preventCurveOverShooting: true,

                        spots:
                            data
                                .map(
                                  (e) => FlSpot(
                                    e.bulan.toDouble(),
                                    e.skorBebanBerlebih,
                                  ),
                                )
                                .toList(),
                      ),
                      LineChartBarData(
                        color: kategoriColor[3],
                        isCurved: true,
                        preventCurveOverShooting: true,

                        spots:
                            data
                                .map(
                                  (e) => FlSpot(
                                    e.bulan.toDouble(),
                                    e.skorPengembanganKarir,
                                  ),
                                )
                                .toList(),
                      ),
                      LineChartBarData(
                        color: kategoriColor[4],
                        isCurved: true,
                        preventCurveOverShooting: true,

                        spots:
                            data
                                .map(
                                  (e) => FlSpot(
                                    e.bulan.toDouble(),
                                    e.skorTanggungJawabOrangLain,
                                  ),
                                )
                                .toList(),
                      ),
                    ],
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
                message: 'Skor Ketaksaan Peran',
                triggerMode: TooltipTriggerMode.tap,
                child: Column(
                  spacing: 4,
                  children: [
                    CircleAvatar(backgroundColor: kategoriColor[0], radius: 5),
                    Text('Skor TP', style: textTheme.labelSmall),
                  ],
                ),
              ),
              Tooltip(
                message: 'Skor Konflik Peran',
                triggerMode: TooltipTriggerMode.tap,

                child: Column(
                  spacing: 4,

                  children: [
                    CircleAvatar(backgroundColor: kategoriColor[1], radius: 5),
                    Text('Skor KP', style: textTheme.labelSmall),
                  ],
                ),
              ),
              Tooltip(
                message: 'Skor Beban Berlebih',
                triggerMode: TooltipTriggerMode.tap,
                child: Column(
                  spacing: 4,

                  children: [
                    CircleAvatar(backgroundColor: kategoriColor[2], radius: 5),
                    Text('Skor BB', style: textTheme.labelSmall),
                  ],
                ),
              ),
              Tooltip(
                message: 'Skor Pengembangan Karir',
                triggerMode: TooltipTriggerMode.tap,
                child: Column(
                  spacing: 4,

                  children: [
                    CircleAvatar(backgroundColor: kategoriColor[3], radius: 5),
                    Text('Skor PK', style: textTheme.labelSmall),
                  ],
                ),
              ),
              Tooltip(
                message: 'Skor Tanggung Jawab Orang Lain',
                triggerMode: TooltipTriggerMode.tap,
                child: Column(
                  spacing: 4,

                  children: [
                    CircleAvatar(backgroundColor: kategoriColor[4], radius: 5),
                    Text('Skor TJO', style: textTheme.labelSmall),
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
