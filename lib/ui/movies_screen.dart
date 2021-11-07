import 'package:cinephilia/bloc/yts_bloc.dart';
import 'package:cinephilia/bloc/yts_download_bloc.dart';
import 'package:cinephilia/bloc/yts_popular_bloc.dart';
import 'package:cinephilia/bloc/yts_rated_bloc.dart';
import 'package:cinephilia/bloc/yts_recent_bloc.dart';
import 'package:cinephilia/model/yts_model.dart';
import 'package:cinephilia/ui/see_more.dart';
import 'package:cinephilia/ui/series_screen.dart';
import 'package:cinephilia/utils/ThemeManager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:share_plus/share_plus.dart';
import 'contact.dart';
import 'details_screen.dart';
import 'help.dart';

class MoviesScreen extends StatefulWidget {
  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  @override
  void initState() {
    super.initState();
    ytsBloc.fetch();
    ytsRatedBloc.fetch();
    ytsPopularBloc.fetch();
    ytsRecentBloc.fetch();
    ytsDownloadBloc.fetch();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, theme, _) => Scaffold(
              key: _scaffoldKey,
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
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text('TV Shows'),
                      leading: Icon(
                        Icons.tv,
                        color: Colors.orange,
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => SeriesScreen()));
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
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Help()));
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
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Contact()));
                      },
                    ),
                  ],
                ),
              ),
              body: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  ListTile(
                    leading: IconButton(
                      onPressed: () {
                        _scaffoldKey.currentState!.openDrawer();
                        print('hello world');
                      },
                      icon: Icon(
                        Icons.menu,
                        color: Colors.orange,
                        size: 30,
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Image.asset(
                            'images/logo.png',
                            height: 24,
                            color: Colors.orange,
                          ),
                          margin: EdgeInsets.only(bottom: 5, right: 2),
                        ),
                        Text(
                          'OVIES',
                          style: TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SeeMore(0)));
                      },
                      icon: Icon(
                        Icons.search,
                        color: Colors.orange,
                        size: 30,
                      ),
                    ),
                  ),
                  title('Most Popular', 1),
                  buildMovies(ytsPopularBloc.ytsPopular),
                  title('Top Rated', 2),
                  buildMovies(ytsRatedBloc.ytsRated),
                  title('Most downloaded', 3),
                  buildMovies(ytsDownloadBloc.ytsDownload),
                  title('Recently added', 5),
                  buildMovies(ytsRecentBloc.ytsRecent),
                  title('New', 4),
                  buildMovies(ytsBloc.yts),

                ],
              ),
            ));
  }

  Widget buildMovies(Stream<Yts> stream) {

    return Container(
      margin: EdgeInsets.only(left: 6, top: 15, bottom: 15),
      width: MediaQuery.of(context).size.width,
      height: 210,
      child: StreamBuilder(
          stream: stream,
          builder: (context, AsyncSnapshot<Yts> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data!.data.movies.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DetailsScreen(snapshot
                                    .data!.data.movies[index].id
                                    .toString())));
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            width: 140,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                    snapshot.data!.data.movies[index]
                                        .largeCoverImage,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;

                                  return Shimmer.fromColors(
                                    baseColor: Theme.of(context).cardColor,
                                    highlightColor:
                                        Colors.white.withOpacity(0.6),
                                    child: Container(
                                      color: Colors.white,
                                    ),
                                  );
                                })),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 120,
                              margin: EdgeInsets.only(left: 20),
                              child: Text(
                                snapshot.data!.data.movies[index].year
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.8)),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20, bottom: 10),
                              // height: 18,
                              width: 120,
                              child: Text(
                                snapshot.data!.data.movies[index].title,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Colors.orange, Colors.red]),
                          ),
                          margin: EdgeInsets.only(bottom: 170, left: 110),
                          child: Center(
                              child: Text(
                            snapshot.data!.data.movies[index].rating.toString(),
                            style: TextStyle(color: Colors.white),
                          )),
                        )
                      ],
                    );
                  });
            }
            if (snapshot.hasError) {
              return Text('no internet');
            }
            return const Center(child: Text(''));
          }),
    );
  }

  Widget title(String title, int bloc) {
    return ListTile(
      title: Text(
        '$title',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
      trailing: TextButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => SeeMore(bloc)));
        },
        child: Text('See more'),
      ),
    );
  }
}
