import 'package:cinephilia/ui/movies_screen.dart';
import 'package:cinephilia/ui/onboarding_screen.dart';
import 'package:cinephilia/ui/series_screen.dart';
import 'package:cinephilia/utils/ThemeManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? initScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = await prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);
  print('initScreen ${initScreen}');
  runApp(ChangeNotifierProvider<ThemeNotifier>(
    create: (_) => new ThemeNotifier(),
    child: MyApp(),
  ));}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, theme, _) => MaterialApp(
              title: 'Cinephilia',
          theme: theme.getTheme(),
          debugShowCheckedModeBanner: false,
              themeMode: ThemeMode.system,
              initialRoute:
                  initScreen == 0 || initScreen == null ? "first" : "/",
              routes: {
                '/': (context) => MoviesScreen(),
                "first": (context) => OnboardingScreen(),
              },
            ));
  }
}
