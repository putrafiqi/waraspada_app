import 'package:equatable/equatable.dart';

class Soal extends Equatable {
  final String teks;
  final String kategori;
  final int? jawaban;

  const Soal({required this.teks, required this.kategori, this.jawaban});

  Soal copyWith({String? teks, String? kategori, int? jawaban}) {
    return Soal(
      teks: teks ?? this.teks,
      kategori: kategori ?? this.kategori,
      jawaban: jawaban,
    );
  }

  @override
  List<Object?> get props => [teks, kategori, jawaban];
}
