import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/article_model.dart';
import '../utils/app_colors.dart';
import '../widgets/news_image.dart';

class ArticleDetailView extends StatelessWidget {
  final ArticleModel article;

  const ArticleDetailView({
    super.key,
    required this.article,
  });

  Future<void> _openOriginalArticle(
  BuildContext context,
) async {
  final url = article.url;

  if (url == null || url.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Link artikel tidak tersedia.'),
      ),
    );
    return;
  }

  final uri = Uri.tryParse(url);

  if (uri == null ||
      (uri.scheme != 'http' && uri.scheme != 'https') ||
      uri.host.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Link artikel tidak valid.'),
      ),
    );
    return;
  }

  try {
    final berhasil = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!berhasil) {
      throw Exception('Gagal membuka URL');
    }
  } catch (e) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Gagal membuka artikel. Silakan coba lagi.',
        ),
      ),
    );
  }
}

  String get formattedDate {
    final date = DateTime.tryParse(article.publishedAt);

    if (date == null) {
      return 'Tanggal tidak tersedia';
    }

    return DateFormat(
      'dd MMMM yyyy',
      'id_ID',
    ).format(date.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = article.urlToImage;
    final description = article.description;
    final content = article.content;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          'Detail Berita',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
      child: ConstrainedBox(
      constraints: const BoxConstraints(
      maxWidth: 850,
    ),
    child: SingleChildScrollView(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar utama artikel
            if (imageUrl != null && imageUrl.isNotEmpty)
              NewsImage(
                url: imageUrl,
                height: 260,
              )
            else
              Container(
                height: 260,
                width: double.infinity,
                color: AppColors.surface,
                child: const Icon(
                  Icons.movie_outlined,
                  size: 70,
                  color: AppColors.textSecondary,
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // Label
                  const Text(
                    'CINENEWS • ENTERTAINMENT',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Judul artikel
                  Text(
                    article.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Sumber berita
                  Row(
                    children: [
                      const Icon(
                        Icons.newspaper_outlined,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          article.author ??
                              'Sumber tidak diketahui',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Tanggal publikasi
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  const Divider(
                    color: AppColors.border,
                  ),

                  const SizedBox(height: 16),

                  // Deskripsi berita
                  if (description != null &&
                      description.isNotEmpty) ...[
                    Text(
                      description,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Cuplikan konten berita
                  if (content != null &&
                      content.isNotEmpty) ...[
                    Text(
                      content,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 15,
                        height: 1.7,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Informasi artikel asli
                  const Text(
                    'Ingin membaca berita selengkapnya?',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Buka artikel asli untuk membaca '
                    'informasi lengkap dari penerbit.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Tombol artikel asli
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                      _openOriginalArticle(context);
                      },
                      icon: const Icon(
                        Icons.open_in_new,
                      ),
                      label: const Text(
                        'Baca Artikel Asli',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor:
                            AppColors.textPrimary,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
                    ],
        ),
      ),
    ),
  ),
);
  }
}