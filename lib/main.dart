import 'package:cinephilia/bloc/tmdb_search_bloc.dart';
import 'package:cinephilia/bloc/yts_search_bloc.dart';
import 'package:cinephilia/ui/geners_screen.dart';
import 'package:cinephilia/ui/privacyPolicy.dart';
import 'package:cinephilia/ui/movies_screen.dart';
import 'package:cinephilia/ui/see_more.dart';
import 'package:cinephilia/ui/series_screen.dart';
import 'package:cinephilia/utils/ThemeManager.dart';
import 'package:cinephilia/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  MobileAds.instance.initialize();
  List<String> testDeviceIds = ['44BFC0F943FD08F178B31E6FB48644C5'];
  RequestConfiguration configuration =
      RequestConfiguration(testDeviceIds: testDeviceIds);
  MobileAds.instance.updateRequestConfiguration(configuration);

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
  final _drawerController = BehaviorSubject<DrawerSelection>();

  Stream<DrawerSelection> get drawerStream => _drawerController.stream;

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
                          title: StreamBuilder<DrawerSelection>(
                              initialData: DrawerSelection.movies,
                              stream: drawerStream,
                              builder: (context, snapshot) {
                                return Text(
                                  snapshot.data == DrawerSelection.movies
                                      ? 'MOVIES'
                                      : 'TV SHOWS',
                                );
                              }),
                          actions: [
                            IconButton(
                              onPressed: () {
                                helper.goTo(
                                    context,
                                    SeeMore(
                                        drawerStream == DrawerSelection.movies
                                            ? 0
                                            : 6,
                                        drawerStream == DrawerSelection.movies
                                            ? ytsSearchBloc.ytsSearch
                                            : tmdbSearchBloc.tmdbSearch));
                              },
                              tooltip: 'Search',
                              icon: Icon(
                                Icons.search,
                              ),
                            )
                          ],
                        ),
                        drawer: Drawer(
                          child: StreamBuilder<DrawerSelection>(
                              stream: drawerStream,
                              initialData: DrawerSelection.movies,
                              builder: (context, snapshot) {
                                return ListView(
                                  children: [
                                    Container(
                                      child: Image.asset(
                                        'images/icon.png',
                                        height: 70,
                                        width: 70,
                                      ),
                                      alignment: Alignment.centerLeft,
                                      margin:
                                          EdgeInsets.only(left: 20, top: 20),
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
                                      selected: snapshot.data ==
                                          DrawerSelection.movies,
                                      title: Text('Movies'),
                                      leading: Icon(
                                        Icons.movie,
                                        color: Colors.blue,
                                      ),
                                      onTap: () {
                                        _drawerController.sink
                                            .add(DrawerSelection.movies);
                                        helper.goBack(context);
                                      },
                                    ),
                                    ListTile(
                                      title: Text('TV Shows'),
                                      selected: snapshot.data ==
                                          DrawerSelection.tvShows,
                                      leading: Icon(
                                        Icons.tv,
                                        color: Colors.blue,
                                      ),
                                      onTap: () {
                                        _drawerController.sink
                                            .add(DrawerSelection.tvShows);
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
                                        if (theme.getTheme() ==
                                            theme.darkTheme) {
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

                                        helper.goTo(context, privacyPolicy());
                                      },
                                    ),
                                  ],
                                );
                              }),
                        ),
                        body: StreamBuilder<DrawerSelection>(
                            stream: drawerStream,
                            initialData: DrawerSelection.movies,
                            builder: (context, snapshot) {
                              if (snapshot.data == DrawerSelection.tvShows) {
                                return SeriesScreen();
                              } else {
                                return MoviesScreen();
                              }
                            }),
                      ),
                    ),
              },
            ));
  }
}

enum DrawerSelection { movies, tvShows }
