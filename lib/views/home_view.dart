import 'package:flutter/material.dart';

import '../models/article_model.dart';
import '../services/news_api_service.dart';
import '../utils/app_colors.dart';
import '../widgets/article_card.dart';
import '../widgets/hero_news_banner.dart';
import '../widgets/news_state_view.dart';
import 'article_detail_view.dart';
import 'search_result_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final NewsApiService _service = NewsApiService();

  final List<String> _categories = [
    'Semua',
    'Film',
    'Serial TV',
    'Anime',
    'Hollywood',
  ];

  String _selectedCategory = 'Semua';

  // Cache berita berdasarkan kategori
  final Map<String, Future<List<ArticleModel>>> _cache = {};

  late Future<List<ArticleModel>> _futureNews;

  @override
  void initState() {
    super.initState();
    _futureNews = _getNews(_selectedCategory);
  }

  // Mengambil berita berdasarkan kategori
  Future<List<ArticleModel>> _getNews(String category) {
    return _cache.putIfAbsent(
      category,
      () => _service.getNewsByCategory(category),
    );
  }

  // Mengganti kategori berita
  void _changeCategory(String category) {
    if (_selectedCategory == category) return;

    setState(() {
      _selectedCategory = category;
      _futureNews = _getNews(category);
    });
  }

  // Memperbarui berita
  Future<void> _refreshNews() async {
    final category = _selectedCategory;
    final future = _service.getNewsByCategory(category);

    setState(() {
      _cache[category] = future;
      _futureNews = future;
    });

    try {
      await future;
    } catch (_) {
      // Error ditampilkan oleh FutureBuilder
    }
  }

  // Mengulang request ketika terjadi error
  void _retryNews() {
    _refreshNews();
  }

  // Membuka halaman detail artikel
  void _openArticleDetail(ArticleModel article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticleDetailView(article: article),
      ),
    );
  }

  // Menampilkan dialog pencarian berita
  Future<void> _showSearchDialog() async {
    final keyword = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return const _SearchDialog();
      },
    );

    if (!mounted) return;

    if (keyword == null || keyword.isEmpty) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultView(keyword: keyword),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.movie_filter, color: AppColors.primary),
            SizedBox(width: 8),
            Text(
              'CINENEWS',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 23,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Cari Berita',
            onPressed: _showSearchDialog,
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: Column(
        children: [
          // Pilihan kategori berita
          _buildCategories(),

          // Daftar berita menggunakan FutureBuilder
          Expanded(
            child: FutureBuilder<List<ArticleModel>>(
              future: _futureNews,
              builder: (context, snapshot) {
                // STATE 1: LOADING
                if (snapshot.connectionState != ConnectionState.done) {
                  return const NewsStateView(
                    icon: Icons.hourglass_empty,
                    title: 'Memuat Berita',
                    message: 'Sedang mengambil berita terbaru...',
                  );
                }

                // STATE 2: ERROR
                if (snapshot.hasError) {
                  return NewsStateView(
                    icon: Icons.wifi_off,
                    title: 'Gagal Memuat Berita',
                    message: snapshot.error.toString(),
                    onRetry: _retryNews,
                  );
                }

                final articles = snapshot.data ?? [];

                // STATE 3: EMPTY
                if (articles.isEmpty) {
                  return const NewsStateView(
                    icon: Icons.search_off,
                    title: 'Berita Tidak Ditemukan',
                    message: 'Belum ada berita yang tersedia.',
                  );
                }

                // STATE 4: DATA
                return _buildNewsList(articles);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Menampilkan pilihan kategori
  Widget _buildCategories() {
    return SizedBox(
      height: 62,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 8);
        },
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return ChoiceChip(
            label: Text(category),
            selected: isSelected,
            onSelected: (_) => _changeCategory(category),
            selectedColor: AppColors.primary,
            backgroundColor: AppColors.surface,
            labelStyle: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            side: BorderSide.none,
            showCheckmark: false,
          );
        },
      ),
    );
  }

  // Menampilkan banner dan daftar berita
  Widget _buildNewsList(List<ArticleModel> articles) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _refreshNews,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          // Banner berita utama
          HeroNewsBanner(
            article: articles.first,
            onTap: () {
              _openArticleDetail(articles.first);
            },
          ),

          const Text(
            'BERITA TERBARU',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // Kartu berita lainnya
          for (final article in articles.skip(1))
            ArticleCard(
              article: article,
              category: _selectedCategory,
              onTap: () {
                _openArticleDetail(article);
              },
            ),
        ],
      ),
    );
  }
}

// Dialog pencarian berita
class _SearchDialog extends StatefulWidget {
  const _SearchDialog();

  @override
  State<_SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<_SearchDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Menjalankan pencarian
  void _submitSearch() {
    final keyword = _controller.text.trim();

    // Mencegah pencarian kosong
    if (keyword.isEmpty) {
      return;
    }

    Navigator.pop(context, keyword);
  }

  // Menghapus seluruh teks pencarian
  void _clearSearch() {
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      title: const Row(
        children: [
          Icon(Icons.search, color: AppColors.primary),
          SizedBox(width: 10),
          Text(
            'Cari Berita',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),

      // Kolom pencarian dengan tombol hapus
      content: ValueListenableBuilder<TextEditingValue>(
        valueListenable: _controller,
        builder: (context, value, child) {
          final hasText = value.text.isNotEmpty;

          return TextField(
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.search,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Contoh: Avengers, One Piece...',
              hintStyle: const TextStyle(color: AppColors.textSecondary),

              // Ikon film
              prefixIcon: const Icon(
                Icons.movie_outlined,
                color: AppColors.textSecondary,
              ),

              // Tombol X muncul jika ada teks
              suffixIcon: hasText
                  ? IconButton(
                      tooltip: 'Hapus Pencarian',
                      onPressed: _clearSearch,
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.textSecondary,
                      ),
                    )
                  : null,

              filled: true,
              fillColor: AppColors.background,

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
            ),
            onSubmitted: (_) => _submitSearch(),
          );
        },
      ),

      actions: [
        // Tombol batal
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Batal',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),

        // Tombol cari
        ElevatedButton(
          onPressed: _submitSearch,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textPrimary,
          ),
          child: const Text('Cari'),
        ),
      ],
    );
  }
}
