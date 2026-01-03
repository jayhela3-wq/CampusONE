import 'package:flutter/material.dart';

// Change this import if your splash page path/name is different
import 'features/splash/splash_page.dart';

void main() {
  runApp(const CampusONEApp());
}

class CampusONEApp extends StatelessWidget {
  const CampusONEApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CampusONE',

      // =========================
      // 🎨 GLOBAL THEME (PHASE 1)
      // =========================
      theme: ThemeData(
        useMaterial3: true,

        // 🔵 Core color scheme (blue & white)
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A73E8), // Google Blue
          background: const Color(0xFFF8FAFF),
        ),

        // 🧱 App background
        scaffoldBackgroundColor: const Color(0xFFF8FAFF),

        // 🧭 AppBar styling
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A73E8),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),

        // 🔘 Elevated buttons (login, actions, send)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A73E8),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // 📝 Text styling
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF202124),
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF202124),
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Color(0xFF5F6368),
          ),
        ),

        // 🧩 Card theme (FIXED for your Flutter version)
        cardTheme: const CardThemeData(
          elevation: 2,
          color: Colors.white,
          margin: EdgeInsets.all(8),
        ),

        // 🔽 Bottom navigation styling
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF1A73E8),
          unselectedItemColor: Color(0xFF9AA0A6),
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
          type: BottomNavigationBarType.fixed,
        ),
      ),

      // 🔰 App start page
      home: const SplashPage(),
    );
  }
}
