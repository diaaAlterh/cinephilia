import 'package:cinephilia/ui/help.dart';
import 'package:cinephilia/ui/movies_screen.dart';
import 'package:cinephilia/ui/onboarding_screen.dart';
import 'package:cinephilia/ui/see_more.dart';
import 'package:cinephilia/ui/series_screen.dart';
import 'package:cinephilia/utils/ThemeManager.dart';
import 'package:cinephilia/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
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
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int b = 1;

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
                '/': (context) => WillPopScope(
                      onWillPop: helper.onWillPop,
                      child: Scaffold(
                        appBar: AppBar(
                          centerTitle: true,
                          title: Text(
                            b == 1 ? 'MOVIES' : 'TV SHOWS',
                          ),
                          actions: [
                            IconButton(
                              onPressed: () {
                                helper.goTo(context, SeeMore(b == 1 ? 0 : 6));
                              },
                              tooltip: 'Search',
                              icon: Icon(
                                Icons.search,
                              ),
                            )
                          ],
                        ),
                        drawer: Drawer(
                          child: ListView(
                            children: [
                              ListTile(
                                title: Text('Movies'),
                                leading: Icon(
                                  Icons.movie,
                                  color: Colors.orange,
                                ),
                                onTap: () {
                                  b = 1;
                                  helper.goBack(context);
                                  setState(() {});
                                },
                              ),
                              ListTile(
                                title: Text('TV Shows'),
                                leading: Icon(
                                  Icons.tv,
                                  color: Colors.orange,
                                ),
                                onTap: () {
                                  b = 2;
                                  setState(() {});
                                  helper.goBack(context);
                                },
                              ),
                              ListTile(
                                title: Text('Help'),
                                leading: Icon(
                                  Icons.help,
                                  color: Colors.orange,
                                ),
                                onTap: () {
                                  helper.goBack(context);
                                  helper.goTo(context, Help());
                                },
                              ),
                              ListTile(
                                title: Text('Dark / Light mode'),
                                leading: Icon(
                                  Icons.wb_sunny,
                                  color: Colors.orange,
                                ),
                                onTap: () {
                                  if (theme.getTheme() == theme.darkTheme) {
                                    theme.setLightMode();
                                  } else {
                                    theme.setDarkMode();
                                  }
                                  helper.goBack(context);
                                },
                              ),
                              ListTile(
                                title: Text('Share the app'),
                                leading: Icon(
                                  Icons.share,
                                  color: Colors.orange,
                                ),
                                onTap: () {
                                  Share.share(
                                      'https://drive.google.com/drive/folders/11IJzLJitQTYqrK-DFPzaPuWDb86OEAOJ?usp=sharing',
                                      subject: 'Share Cinephilia');
                                  helper.goBack(context);
                                },
                              ),
                            ],
                          ),
                        ),
                        body: b == 2 ? SeriesScreen() : MoviesScreen(),
                      ),
                    ),
                "first": (context) => OnboardingScreen(),
              },
            ));
  }
}
