/// User-facing fallback messages used when the server gives none.
abstract final class AppMessages {
  static const String timeout =
      'Koneksi terlalu lama. Periksa jaringan dan coba lagi.';
  static const String noConnection =
      'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
  static const String generic = 'Terjadi kesalahan. Silakan coba lagi.';
  static const String sessionExpired = 'Sesi berakhir. Silakan masuk kembali.';
  static const String forbidden =
      'Anda tidak memiliki akses ke halaman ini.';
}
