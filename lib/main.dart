import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database/database.dart';
import 'pages/input_page.dart';
import 'pages/search_page.dart';
import 'pages/settings_page.dart';
import 'utils/theme_provider.dart' as theme_utils;

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => theme_utils.ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<theme_utils.ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: '红娘客户查询系统',
          debugShowCheckedModeBanner: false,
          theme: _buildElegantTheme(Brightness.light),
          darkTheme: _buildElegantTheme(Brightness.dark),
          themeMode: _convertThemeMode(themeProvider.themeMode),
          home: const MyHomePage(),
        );
      },
    );
  }

  ThemeData _buildElegantTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    // China Red color palette
    const chinaRed = Color(0xFFD0021B);
    const coralRed = Color(0xFFF75C5C);
    const rougeRed = Color(0xFFC41E3A);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: chinaRed,
        brightness: brightness,
      ).copyWith(
        primary: chinaRed,
        secondary: coralRed,
        tertiary: rougeRed,
        surface: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        error: chinaRed,
      ),

      // Enhanced typography with refined visual hierarchy
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          height: 1.2,
          color: isDark ? Colors.white : const Color(0xFF1A1A1A),
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.25,
          height: 1.3,
          color: isDark ? Colors.white : const Color(0xFF1A1A1A),
        ),
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          height: 1.3,
          color: isDark ? Colors.white : const Color(0xFF1A1A1A),
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          height: 1.4,
          color: isDark ? Colors.white : const Color(0xFF1A1A1A),
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          height: 1.4,
          color: isDark ? Colors.white : const Color(0xFF1A1A1A),
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          height: 1.4,
          color: isDark ? Colors.white : const Color(0xFF1A1A1A),
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          height: 1.5,
          color: isDark ? Colors.white70 : const Color(0xFF424242),
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          height: 1.5,
          color: isDark ? Colors.white70 : const Color(0xFF424242),
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          height: 1.4,
          color: isDark ? Colors.white60 : const Color(0xFF666666),
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          height: 1.3,
          color: isDark ? Colors.white : const Color(0xFF1A1A1A),
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          height: 1.3,
          color: isDark ? Colors.white70 : const Color(0xFF424242),
        ),
      ),

      // Elevated button with gradient effect
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(2),
          shadowColor: WidgetStateProperty.all(Colors.black26),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return isDark ? Colors.grey.shade700 : Colors.grey.shade300;
            }
            return chinaRed;
          }),
          foregroundColor: WidgetStateProperty.all(Colors.white),
        ),
      ),

      // Outlined button with elegant borders
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(
                color: isDark ? chinaRed.withValues(alpha: 0.6) : chinaRed,
                width: 1.5,
              ),
            ),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
          foregroundColor: WidgetStateProperty.all(
            isDark ? chinaRed.withValues(alpha: 0.8) : chinaRed,
          ),
        ),
      ),

      // Enhanced card theme with modern styling and better spacing
      cardTheme: CardThemeData(
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),

      // Enhanced input decoration theme with better spacing
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark ? Colors.grey.shade600 : Colors.grey.shade300,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark ? Colors.grey.shade600 : Colors.grey.shade300,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: chinaRed,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        labelStyle: TextStyle(
          color: isDark ? Colors.white70 : const Color(0xFF424242),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: TextStyle(
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          fontSize: 14,
        ),
        helperStyle: TextStyle(
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          fontSize: 12,
        ),
        errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),

      // App bar theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        foregroundColor: isDark ? Colors.white : const Color(0xFF1A1A1A),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A1A1A),
        ),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
      ),

      // Bottom navigation bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        selectedItemColor: chinaRed,
        unselectedItemColor: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),

      // Enhanced list tile theme with better spacing
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        titleTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A1A1A),
        ),
        subtitleTextStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF424242),
          height: 1.4,
        ),
        leadingAndTrailingTextStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF666666),
        ),
      ),
    );
  }

  ThemeMode _convertThemeMode(theme_utils.ThemeMode mode) {
    switch (mode) {
      case theme_utils.ThemeMode.light:
        return ThemeMode.light;
      case theme_utils.ThemeMode.dark:
        return ThemeMode.dark;
      case theme_utils.ThemeMode.system:
        return ThemeMode.system;
    }
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final AppDatabase database;
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    database = AppDatabase();
    _pages = [
      InputPage(database: database),
      SearchPage(database: database),
      SettingsPage(database: database),
    ];
  }

  @override
  void dispose() {
    database.close();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: '添加',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '查询',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '设置',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
