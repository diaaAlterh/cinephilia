import 'package:cinephilia/ui/contact.dart';
import 'package:cinephilia/ui/help.dart';
import 'package:cinephilia/ui/movies_screen.dart';
import 'package:cinephilia/ui/onboarding_screen.dart';
import 'package:cinephilia/ui/see_more.dart';
import 'package:cinephilia/ui/series_screen.dart';
import 'package:cinephilia/utils/ThemeManager.dart';
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
                '/': (context) => Scaffold(
                      appBar: AppBar(
                        centerTitle: true,
                        title: Text(
                          b==1?'MOVIES':'TV SHOWS',
                        ),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SeeMore(b==1?0:6)));
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
                            Image.asset(
                              'images/logo.png',
                              color: Colors.orange,
                            ),
                            ListTile(
                              title: Text('Movies'),
                              leading: Icon(
                                Icons.movie,
                                color: Colors.orange,
                              ),
                              onTap: () {
                                b = 1;
                                Navigator.pop(context);
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
                                Navigator.of(context).pop();
                              },
                            ),
                            ListTile(
                              title: Text('Help'),
                              leading: Icon(
                                Icons.help,
                                color: Colors.orange,
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Help()));
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
                                Navigator.of(context).pop();
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
                                Navigator.of(context).pop();
                              },
                            ),
                            ListTile(
                              title: Text('Contact Developer'),
                              leading: Icon(
                                Icons.flutter_dash_rounded,
                                color: Colors.orange,
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Contact()));
                              },
                            ),
                          ],
                        ),
                      ),
                      body: b == 2 ? SeriesScreen() : MoviesScreen(),
                    ),
                "first": (context) => OnboardingScreen(),
              },
            ));
  }
}
