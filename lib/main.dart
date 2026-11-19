import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'utils/app_colors.dart';
import 'views/home_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Mengaktifkan format tanggal Indonesia
  await initializeDateFormatting('id_ID');

  runApp(const CineNewsApp());
}

class CineNewsApp extends StatelessWidget {
  const CineNewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CINENEWS',
      debugShowCheckedModeBanner: false,

      // Tema utama aplikasi
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          surface: AppColors.surface,
          error: AppColors.error,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          centerTitle: false,
        ),
      ),

      // Halaman pertama aplikasi
      home: const HomeView(),
    );
  }
}