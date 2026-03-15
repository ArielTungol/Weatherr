import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/settings_provider.dart';
import 'widgets/home_screen.dart';
import 'widgets/settings_screen.dart';

void main() {
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        brightness: settings.darkMode ? Brightness.dark : Brightness.light,
        primaryColor: CupertinoColors.systemBlue,
      ),
      home: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings),
              label: "Settings",
            ),
          ],
        ),
        tabBuilder: (context, index) {
          switch (index) {
            case 0:
              return const HomeScreen();
            case 1:
              return const SettingsScreen();
            default:
              return const HomeScreen();
          }
        },
      ),
    );
  }
}