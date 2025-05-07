import 'package:flutter/material.dart';

class SoalBox extends StatelessWidget {
  const SoalBox({
    super.key,
    this.jawaban,
    required this.onChanged,
    required this.soal,
  });

  final int? jawaban;
  final void Function(int?) onChanged;
  final String soal;

  static const List<_Jawaban> _listJawaban = [
    _Jawaban(label: 'Tidak Pernah', value: 1),
    _Jawaban(label: 'Jarang Sekali', value: 2),
    _Jawaban(label: 'Jarang', value: 3),
    _Jawaban(label: 'Kadang-kadang', value: 4),
    _Jawaban(label: 'Sering', value: 5),
    _Jawaban(label: 'Sering kali', value: 6),
    _Jawaban(label: 'Selalu', value: 7),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(soal, style: textTheme.titleSmall),
          ),
          ...List.generate(
            _listJawaban.length,
            (index) => _buildRadioOption(context, _listJawaban[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(BuildContext context, _Jawaban jawabItem) {
    final bool isSelected = jawaban == jawabItem.value;

    return RadioListTile<int>(
      dense: true,
      title: Text(
        jawabItem.label,
        style:
            isSelected
                ? TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                )
                : null,
      ),
      selected: isSelected,
      value: jawabItem.value,
      groupValue: jawaban,
      onChanged: onChanged,
    );
  }
}

class _Jawaban {
  final String label;
  final int value;

  const _Jawaban({required this.label, required this.value});
}
