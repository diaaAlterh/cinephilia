import 'package:cinephilia/bloc/tmdb_search_bloc.dart';
import 'package:cinephilia/bloc/yts_search_bloc.dart';
import 'package:cinephilia/ui/ad_state.dart';
import 'package:cinephilia/ui/geners_screen.dart';
import 'package:cinephilia/ui/help.dart';
import 'package:cinephilia/ui/movies_screen.dart';
import 'package:cinephilia/ui/see_more.dart';
import 'package:cinephilia/ui/series_screen.dart';
import 'package:cinephilia/utils/ThemeManager.dart';
import 'package:cinephilia/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> main() async {
  List<String> testDeviceIds = ['44BFC0F943FD08F178B31E6FB48644C5'];

  WidgetsFlutterBinding.ensureInitialized();
  final initFuture = MobileAds.instance.initialize();
  final adState = AdState(initFuture);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  RequestConfiguration configuration =
  RequestConfiguration(testDeviceIds: testDeviceIds);
  MobileAds.instance.updateRequestConfiguration(configuration);

  runApp(ChangeNotifierProvider<ThemeNotifier>(
    create: (_) => new ThemeNotifier(),
    child: Provider.value(
      value: adState,
      builder: (context, child) => MyApp(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int b = 1;
  DrawerSelection _drawerSelection = DrawerSelection.movies;
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, theme, _) => MaterialApp(
              title: 'Cinephilia',
              theme: theme.getTheme(),
              debugShowCheckedModeBanner: false,
              themeMode: ThemeMode.system,
              initialRoute: "/",
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
                                helper.goTo(context, SeeMore(b == 1 ? 0 : 6,b==1?ytsSearchBloc.ytsSearch:tmdbSearchBloc.tmdbSearch));
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
                              Container(
                                child: Image.asset(
                                  'images/icon.png',
                                  height: 70,
                                  width: 70,
                                ),
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(left: 20, top: 20),
                              ),
                              ListTile(
                                title: Text(
                                  'Cinephilia',
                                  style: TextStyle(fontSize: 20),
                                ),
                                subtitle: Text(
                                  'Movies & TV Shows Stream',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              ListTile(
                                selected:
                                    _drawerSelection == DrawerSelection.movies,
                                title: Text('Movies'),
                                leading: Icon(
                                  Icons.movie,
                                  color: Colors.blue,
                                ),
                                onTap: () {
                                  b = 1;
                                  _drawerSelection = DrawerSelection.movies;
                                  helper.goBack(context);
                                  setState(() {});
                                },
                              ),
                              ListTile(
                                title: Text('TV Shows'),
                                selected:
                                    _drawerSelection == DrawerSelection.tvShows,
                                leading: Icon(
                                  Icons.tv,
                                  color: Colors.blue,
                                ),
                                onTap: () {
                                  b = 2;
                                  setState(() {});
                                  _drawerSelection = DrawerSelection.tvShows;
                                  helper.goBack(context);
                                },
                              ),
                              ListTile(
                                title: Text('Movies Genres'),
                                leading: Icon(
                                  Icons.list,
                                  color: Colors.blue,
                                ),
                                onTap: () {
                                  helper.goBack(context);

                                  helper.goTo(context, GenersScreen());
                                },
                              ),
                              ListTile(
                                title: Text('Dark / Light mode'),
                                leading: Icon(
                                  Icons.wb_sunny,
                                  color: Colors.blue,
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
                                  color: Colors.blue,
                                ),
                                onTap: () {
                                  Share.share(
                                      'https://drive.google.com/drive/folders/11IJzLJitQTYqrK-DFPzaPuWDb86OEAOJ?usp=sharing',
                                      subject: 'Share Cinephilia');
                                  helper.goBack(context);
                                },
                              ),
                              ListTile(
                                title: Text('Privacy Policy'),
                                leading: Icon(
                                  Icons.help,
                                  color: Colors.blue,
                                ),
                                onTap: () {
                                  helper.goBack(context);

                                  helper.goTo(context, Help());
                                },
                              ),
                            ],
                          ),
                        ),
                        // bottomSheet:  Container(
                        //         height: 50,
                        //         child: AdWidget(
                        //           ad: banner,
                        //         ),
                        //       ),
                        body: b == 2 ? SeriesScreen() : MoviesScreen(),
                      ),
                    ),
              },
            ));
  }
}

enum DrawerSelection { movies, tvShows }
