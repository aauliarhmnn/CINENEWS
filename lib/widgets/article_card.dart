import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/article_model.dart';
import '../utils/app_colors.dart';
import 'news_image.dart';

class ArticleCard extends StatelessWidget {
  final ArticleModel article;
  final String category;
  final VoidCallback? onTap;

  const ArticleCard({
    super.key,
    required this.article,
    this.category = 'Film',
    this.onTap,
  });

  String get formattedDate {
    final date = DateTime.tryParse(article.publishedAt);

    if (date == null) {
      return 'Tanggal tidak tersedia';
    }

    return DateFormat(
      'dd MMM yyyy',
      'id_ID',
    ).format(date.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = article.urlToImage;

    return Card(
      color: AppColors.surface,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar berita
            if (imageUrl != null && imageUrl.isNotEmpty)
              NewsImage(
                url: imageUrl,
                height: 190,
              )
            else
              Container(
                height: 190,
                width: double.infinity,
                color: AppColors.background,
                child: const Icon(
                  Icons.movie_outlined,
                  color: AppColors.textSecondary,
                  size: 50,
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kategori dan tanggal
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          category.toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Text(
                        formattedDate,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Judul berita
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Sumber berita dan ikon detail
                  Row(
                    children: [
                      const Icon(
                        Icons.newspaper_outlined,
                        color: AppColors.textSecondary,
                        size: 15,
                      ),

                      const SizedBox(width: 6),

                      Expanded(
                        child: Text(
                          article.author ?? 'Sumber tidak diketahui',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ),

                      const Icon(
                        Icons.arrow_outward,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}