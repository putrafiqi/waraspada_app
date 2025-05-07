import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:waraspada_app/common/dialog/dialog.dart';

import '../../common/widget/widget.dart';
import '../../data/data.dart';
import '../bloc/tren_tingkat_stres_usaha/tren_tingkat_stres_usaha_bloc.dart';

class TrenTingkatStresUsahaWidget extends StatelessWidget {
  const TrenTingkatStresUsahaWidget({
    super.key,
    required this.selectedTahun,
    required this.onYearChanged,
  });

  final int selectedTahun;
  final void Function(String?)? onYearChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          _buildHeader(context),
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
              TrenTingkatStresUsahaBloc,
              TrenTingkatStresUsahaState
            >(
              listener: (context, state) {
                if (state.status == TrenTingkatStresUsahaStatus.error) {
                  ShowToast.showEror(state.errorMessage ?? 'Terjadi kesalahan');
                }
              },
              builder: (context, state) {
                if (state.status == TrenTingkatStresUsahaStatus.loading) {
                  return const Loader();
                }

                return _buildLineChart(context, state.data, state.maxDataY);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Tren Tingkat Stres', style: textTheme.titleMedium),

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
    );
  }

  Widget _buildLineChart(
    BuildContext context,
    List<TingkatStres> data,
    double maxDataY,
  ) {
    final textTheme = TextTheme.of(context);
    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => Colors.red.shade50,
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
                Widget text;
                switch (value.toInt()) {
                  case 1:
                    text = Text('Jan', style: textTheme.labelSmall);
                    break;
                  case 2:
                    text = Text('Feb', style: textTheme.labelSmall);
                    break;
                  case 3:
                    text = Text('Mar', style: textTheme.labelSmall);
                    break;
                  case 4:
                    text = Text('Apr', style: textTheme.labelSmall);
                    break;
                  case 5:
                    text = Text('Mei', style: textTheme.labelSmall);
                    break;
                  case 6:
                    text = Text('Jun', style: textTheme.labelSmall);
                    break;
                  case 7:
                    text = Text('Jul', style: textTheme.labelSmall);
                    break;
                  case 8:
                    text = Text('Agu', style: textTheme.labelSmall);
                    break;
                  case 9:
                    text = Text('Sep', style: textTheme.labelSmall);
                    break;
                  case 10:
                    text = Text('Okt', style: textTheme.labelSmall);
                    break;
                  case 11:
                    text = Text('Nov', style: textTheme.labelSmall);
                    break;
                  case 12:
                    text = Text('Des', style: textTheme.labelSmall);
                    break;
                  default:
                    text = const Text('');
                }
                return SideTitleWidget(space: 0, meta: meta, child: text);
              },
            ),
          ),
          leftTitles: AxisTitles(
            axisNameSize: 24,
            axisNameWidget: Text('Skor', style: textTheme.labelSmall),
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
                      style: textTheme.labelSmall,
                    ),
                  ),
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        lineBarsData: [
          LineChartBarData(
            color: Colors.red.shade400,
            isCurved: true,
            preventCurveOverShooting: true,
            barWidth: 1.5,
            spots:
                data
                    .map((e) => FlSpot(e.bulan.toDouble(), e.rataRataStres))
                    .toList(),
          ),
        ],
      ),
    );
  }
}
