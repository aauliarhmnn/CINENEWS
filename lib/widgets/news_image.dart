import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../utils/app_colors.dart';

class NewsImage extends StatelessWidget {
  final String url;
  final double height;

  const NewsImage({
    super.key,
    required this.url,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    // Tampilan ketika gambar sedang loading
    final placeholder = Container(
      height: height,
      width: double.infinity,
      color: AppColors.surface,
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      ),
    );

    // Tampilan ketika gambar gagal dimuat
    final errorWidget = Container(
      height: height,
      width: double.infinity,
      color: AppColors.surface,
      child: const Center(
        child: Icon(
          Icons.broken_image_outlined,
          color: AppColors.textSecondary,
          size: 50,
        ),
      ),
    );

    // Untuk Flutter Web (Chrome)
    if (kIsWeb) {
      return Image.network(
        url,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
        loadingBuilder: (context, child, progress) {
          if (progress == null) {
            return child;
          }
          return placeholder;
        },
        errorBuilder: (context, error, stackTrace) {
          return errorWidget;
        },
      );
    }

    // Untuk Android dan iOS
    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (context, url) => placeholder,
      errorWidget: (context, url, error) => errorWidget,
    );
  }
}