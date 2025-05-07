import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../data/data.dart';


class HasilSurveiPage extends StatelessWidget {
  final HasilSurvei hasilSurvei;
  const HasilSurveiPage({super.key, required this.hasilSurvei});

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              spacing: 16,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Hasil Survei Stres Kerja',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade900,
                  ),
                  textAlign: TextAlign.center,
                ),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Skor Tingkat Stres',
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.green.shade900,
                              ),
                            ),
                            Tooltip(
                              triggerMode: TooltipTriggerMode.tap,

                              richMessage: TextSpan(
                                text: 'Ketegori Nilai Stres:',
                                children: [
                                  TextSpan(text: '\n\tSkor < 9 : Stres Ringan'),
                                  TextSpan(
                                    text: '\n\tSkor 10-24 : Stres Sedang',
                                  ),
                                  TextSpan(text: '\n\tSkor > 24 : Stres Berat'),
                                ],
                              ),
                              child: Icon(LucideIcons.info),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          hasilSurvei.skorTingkatStres.toStringAsFixed(2),
                          style: textTheme.displayLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.green.shade900,
                            fontSize: 48,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Kembali ke Dashboard'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
