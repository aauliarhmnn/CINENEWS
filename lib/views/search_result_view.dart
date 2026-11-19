import 'package:flutter/material.dart';

import '../models/article_model.dart';
import '../services/news_api_service.dart';
import '../utils/app_colors.dart';
import '../widgets/article_card.dart';
import '../widgets/news_state_view.dart';
import 'article_detail_view.dart';

class SearchResultView extends StatefulWidget {
  final String keyword;

  const SearchResultView({super.key, required this.keyword});

  @override
  State<SearchResultView> createState() => _SearchResultViewState();
}

class _SearchResultViewState extends State<SearchResultView> {
  final NewsApiService _service = NewsApiService();

  late Future<List<ArticleModel>> _futureResults;

  @override
  void initState() {
    super.initState();

    // Request API dibuat saat halaman pertama kali dibuka
    _futureResults = _service.searchNews(widget.keyword);
  }

  // Mengulang pencarian ketika terjadi error
  void _retrySearch() {
    setState(() {
      _futureResults = _service.searchNews(widget.keyword);
    });
  }

  // Memperbarui hasil pencarian dengan pull-to-refresh
  Future<void> _refreshSearch() async {
    final future = _service.searchNews(widget.keyword);

    setState(() {
      _futureResults = future;
    });

    try {
      await future;
    } catch (_) {
      // Error ditampilkan oleh FutureBuilder
    }
  }

  // Membuka halaman detail artikel
  void _openDetail(ArticleModel article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticleDetailView(article: article),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          'Hasil Pencarian',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER PENCARIAN RESPONSIF
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Ikon pencarian
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.search,
                            color: AppColors.primary,
                            size: 28,
                          ),
                        ),

                        const SizedBox(width: 14),

                        // Informasi kata kunci pencarian
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'MENAMPILKAN HASIL UNTUK',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 11,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                '"${widget.keyword}"',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 5),

                              const Text(
                                'Temukan berita film dan hiburan favoritmu.',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Garis aksen merah
                    Container(
                      width: 56,
                      height: 3,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // FUTUREBUILDER DENGAN EMPAT STATE
          Expanded(
            child: FutureBuilder<List<ArticleModel>>(
              future: _futureResults,
              builder: (context, snapshot) {
                // STATE 1: LOADING
                if (snapshot.connectionState != ConnectionState.done) {
                  return const NewsStateView(
                    icon: Icons.hourglass_empty,
                    title: 'Memuat Pencarian',
                    message: 'Sedang mencari berita yang kamu inginkan...',
                  );
                }

                // STATE 2: ERROR
                if (snapshot.hasError) {
                  return NewsStateView(
                    icon: Icons.wifi_off,
                    title: 'Pencarian Gagal',
                    message: snapshot.error.toString(),
                    onRetry: _retrySearch,
                  );
                }

                final articles = snapshot.data ?? [];

                // STATE 3: EMPTY
                if (articles.isEmpty) {
                  return NewsStateView(
                    icon: Icons.search_off,
                    title: 'Berita Tidak Ditemukan',
                    message:
                        'Tidak ada berita untuk kata kunci '
                        '"${widget.keyword}". '
                        'Coba gunakan kata kunci yang berbeda.',
                    onRetry: _retrySearch,
                  );
                }

                // STATE 4: DATA
                return Column(
                  children: [
                    // INFORMASI JUMLAH BERITA RESPONSIF
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.article_outlined,
                                color: AppColors.primary,
                                size: 20,
                              ),

                              const SizedBox(width: 8),

                              const Expanded(
                                child: Text(
                                  'Berita ditemukan',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

                              // Badge jumlah artikel
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${articles.length} Artikel',
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // DAFTAR HASIL PENCARIAN RESPONSIF
                    Expanded(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 800),
                          child: RefreshIndicator(
                            color: AppColors.primary,
                            onRefresh: _refreshSearch,
                            child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: articles.length,
                              itemBuilder: (context, index) {
                                final article = articles[index];

                                return ArticleCard(
                                  article: article,
                                  category: 'Pencarian',
                                  onTap: () => _openDetail(article),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
