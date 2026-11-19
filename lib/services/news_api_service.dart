import 'package:dio/dio.dart';

import '../config/env.dart';
import '../models/article_model.dart';
import '../models/news_response_model.dart';
import 'api_exception.dart';

class NewsApiService {
  final Dio _dio;

  NewsApiService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: Env.baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 15),
            queryParameters: {
              'apikey': Env.apiKey,
              'lang': 'id',
              'country': 'id',
              'max': 10,
            },
          ),
        );

  // Mengambil berita berdasarkan kategori CINENEWS
  Future<List<ArticleModel>> getNewsByCategory(
    String category,
  ) {
    final keywords = {
      'Semua': 'film OR cinema OR movie',
      'Film': 'film',
      'Serial TV': 'serial OR drama',
      'Anime': 'anime',
      'Hollywood': 'Hollywood',
    };

    final keyword = keywords[category] ?? 'film';

    return searchNews(keyword);
  }

  // Mencari berita berdasarkan kata kunci
  Future<List<ArticleModel>> searchNews(String keyword) {
    return _ambilArtikel(
      '/search',
      {
        'q': keyword,
        'sortby': 'publishedAt',
      },
    );
  }

  // Mengambil berita hiburan dari kategori resmi GNews
  Future<List<ArticleModel>> getTopHeadlines() {
    return _ambilArtikel(
      '/top-headlines',
      {'category': 'entertainment'},
    );
  }

  // Fungsi utama untuk request API
  Future<List<ArticleModel>> _ambilArtikel(
    String path,
    Map<String, dynamic> query,
  ) async {
    if (!Env.lengkap) {
      throw ApiException(
        'Konfigurasi API belum lengkap.',
      );
    }

    try {
      final response = await _dio.get(
        path,
        queryParameters: query,
      );

      final data = response.data;

      if (data is! Map<String, dynamic>) {
        throw ApiException(
          'Format data dari server tidak valid.',
        );
      }

      final newsResponse =
          NewsResponseModel.fromJson(data);

      return newsResponse.articles;

    } on DioException catch (e) {
      throw ApiException.fromDio(e);

    } on TypeError {
      throw ApiException(
        'Struktur data dari server tidak sesuai.',
      );
    }
  }
}