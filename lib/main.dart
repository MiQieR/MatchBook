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
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          themeMode: _convertThemeMode(themeProvider.themeMode),
          home: const MyHomePage(),
        );
      },
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
