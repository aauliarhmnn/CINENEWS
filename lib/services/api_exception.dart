import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  factory ApiException.fromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return ApiException(
          'Koneksi lambat. Server tidak merespons tepat waktu.',
        );

      case DioExceptionType.connectionError:
        return ApiException(
          'Tidak ada koneksi internet. Periksa jaringan Anda.',
        );

      case DioExceptionType.badCertificate:
        return ApiException(
          'Sertifikat keamanan server tidak valid.',
        );

      case DioExceptionType.cancel:
        return ApiException('Permintaan dibatalkan.');

      case DioExceptionType.badResponse:
        return _dariResponse(e.response);

      case DioExceptionType.unknown:
        return ApiException(
          'Terjadi kesalahan yang tidak diketahui.',
        );
    }
  }

  static ApiException _dariResponse(
    Response<dynamic>? response,
  ) {
    final code = response?.statusCode;

    switch (code) {
      case 400:
        return ApiException(
          'Permintaan tidak valid.',
          statusCode: code,
        );

      case 401:
        return ApiException(
          'API key salah atau tidak terdaftar.',
          statusCode: code,
        );

      case 403:
        return ApiException(
          'Kuota harian habis atau email belum diverifikasi.',
          statusCode: code,
        );

      case 404:
        return ApiException(
          'Alamat endpoint tidak ditemukan.',
          statusCode: code,
        );

      case 429:
        return ApiException(
          'Terlalu cepat. Coba lagi nanti.',
          statusCode: code,
        );

      default:
        if (code != null && code >= 500) {
          return ApiException(
            'Server GNews sedang bermasalah.',
            statusCode: code,
          );
        }

        return ApiException(
          'Gagal mengambil berita.',
          statusCode: code,
        );
    }
  }

  @override
  String toString() {
    return message;
  }
}