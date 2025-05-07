import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/model.dart';

final List<Soal> _listSoalSurvei = [
  // TP - Tujuan dan Peran
  Soal(
    teks: "Tujuan tugas-tugas dan pekerjaan saya tidak jelas",
    kategori: "TP",
    jawaban: null,
  ),
  Soal(
    teks:
        "Saya tidak jelas kepada siapa harus melapor dan / atau siapa yang melapor kepada saya",
    kategori: "TP",
    jawaban: null,
  ),
  Soal(
    teks:
        "Saya tidak mempunyai wewenang untuk melaksanakan tanggung jawab pekerjaan saya",
    kategori: "TP",
    jawaban: null,
  ),
  Soal(
    teks: "Saya tidak mengerti sepenuhnya apa yang diharapkan dari saya",
    kategori: "TP",
    jawaban: null,
  ),
  Soal(
    teks:
        "Saya tidak mengerti bagian yang diperankan pekerjaan saya dalam memenuhi tujuan organisasi keseluruhan",
    kategori: "TP",
    jawaban: null,
  ),

  // BB - Beban Berlebihan
  Soal(
    teks: "Tugas-tugas tampaknya makin hari menjadi makin kompleks",
    kategori: "BB",
    jawaban: null,
  ),
  Soal(
    teks:
        "Saya harus membawa pulang pekerjaan ke rumah setiap sore hari atau akhir pekan agar dapat mengejar waktu",
    kategori: "BB",
    jawaban: null,
  ),
  Soal(
    teks: "Tuntutan-tuntutan mengenai mutu pekerjaan terhadap saya keterlaluan",
    kategori: "BB",
    jawaban: null,
  ),
  Soal(
    teks:
        "Saya menghabiskan waktu terlalu banyak untuk pertemuan-pertemuan yang tidak penting yang menyita waktu saya",
    kategori: "BB",
    jawaban: null,
  ),
  Soal(
    teks:
        "Tugas-tugas yang diberikan kepada saya terlalu sulit dan / atau terlalu kompleks",
    kategori: "BB",
    jawaban: null,
  ),
  Soal(
    teks:
        "Saya bertanggung jawab atas semua proyek pekerjaan dalam waktu bersamaan yang hampir tidak dapat dikendalikan",
    kategori: "BB",
    jawaban: null,
  ),
  Soal(
    teks:
        "Saya benar-benar mempunyai pekerjaan yang lebih banyak daripada yang biasanya dapat dikerjakan dalam sehari",
    kategori: "BB",
    jawaban: null,
  ),
  Soal(
    teks:
        "Organisasi mengharapkan saya melebihi keterampilan dan / atau kemampuan yang saya miliki",
    kategori: "BB",
    jawaban: null,
  ),
  Soal(
    teks:
        "Saya merasa bahwa saya betul-betul tidak punya waktu untuk istirahat berkala",
    kategori: "BB",
    jawaban: null,
  ),
  Soal(
    teks:
        "Saya kurang berlatih dan / atau kurang pengalaman untuk melaksanakan tugas-tugas saya secara memadai",
    kategori: "BB",
    jawaban: null,
  ),

  // KP - Konflik Peran
  Soal(
    teks: "Saya mengerjakan tugas-tugas atau proyek-proyek yang tidak perlu",
    kategori: "KP",
    jawaban: null,
  ),
  Soal(
    teks: "Saya terjepit di tengah-tengah antara atasan dan bawahan saya",
    kategori: "KP",
    jawaban: null,
  ),
  Soal(
    teks: "Jalur perintah yang formal tidak dipatuhi",
    kategori: "KP",
    jawaban: null,
  ),
  Soal(
    teks:
        "Saya melakukan pekerjaan yang diterima oleh satu orang tapi tidak diterima oleh orang lain",
    kategori: "KP",
    jawaban: null,
  ),
  Soal(
    teks:
        "Saya menerima permintaan-permintaan yang saling bertentangan dari satu orang atau lebih",
    kategori: "KP",
    jawaban: null,
  ),

  // PK - Pengembangan Karir
  Soal(
    teks:
        "Saya tidak mempunyai kesempatan yang memadai untuk maju dalam organisasi ini",
    kategori: "PK",
    jawaban: null,
  ),
  Soal(
    teks:
        "Saya merugikan kemajuan karir saya dengan menetap pada organisasi ini",
    kategori: "PK",
    jawaban: null,
  ),
  Soal(
    teks:
        "Saya hanya mempunyai sedikit kesempatan untuk berkembang dan belajar pengetahuan dan keterampilan baru dalam pekerjaan saya",
    kategori: "PK",
    jawaban: null,
  ),
  Soal(
    teks: "Saya merasa karir saya tidak berkembang",
    kategori: "PK",
    jawaban: null,
  ),
  Soal(
    teks:
        "Kalau saya ingin naik pangkat, saya harus mencari pekerjaan pada satuan kerja lain",
    kategori: "PK",
    jawaban: null,
  ),

  // TJO - Tanggung Jawab terhadap Orang
  Soal(
    teks: "Saya bertanggung jawab untuk pengembangan karyawan lain",
    kategori: "TJO",
    jawaban: null,
  ),
  Soal(
    teks:
        "Tanggung jawab saya dalam organisasi ini lebih mengenai orang daripada barang",
    kategori: "TJO",
    jawaban: null,
  ),
  Soal(
    teks:
        "Saya bertindak atau membuat keputusan-keputusan yang mempengaruhi keselamatan dan kesejahteraan orang lain",
    kategori: "TJO",
    jawaban: null,
  ),
  Soal(
    teks:
        "Saya bertanggung jawab untuk membimbing dan / atau membantu bawahan saya menyelesaikan problemnya",
    kategori: "TJO",
    jawaban: null,
  ),
  Soal(
    teks: "Saya bertanggung jawab atas hari depan (karir) orang lain",
    kategori: "TJO",
    jawaban: null,
  ),
];

abstract class SurveiKaryawanApi {
  Future<bool> submitSurveiKaryawan(String karyawanId, HasilSurvei hasilSurvei);

  Future<bool> checkKaryawanSudahSurvei(String karyawanId);

  Future<List<Soal>> ambilListSoalSurvei();
}

class SurveiKaryawanApiImpl implements SurveiKaryawanApi {
  final SupabaseClient supabaseClient;

  SurveiKaryawanApiImpl(this.supabaseClient);
  @override
  Future<bool> checkKaryawanSudahSurvei(String karyawanId) async {
    final response = await supabaseClient.rpc(
      'check_karyawan_survey_this_month',
      params: {'p_karyawan_id': karyawanId},
    );

    return response as bool;
  }

  @override
  Future<bool> submitSurveiKaryawan(
    String karyawanId,
    HasilSurvei hasilSurvei,
  ) async {
    final response =
        await supabaseClient.from('survei_stres').insert({
          'karyawan_id': karyawanId,
          ...hasilSurvei.toMap(),
        }).select();

    if (response.isEmpty) {
      return false;
    }

    return true;
  }

  @override
  Future<List<Soal>> ambilListSoalSurvei() async {
    return List<Soal>.from(_listSoalSurvei);
  }
}
