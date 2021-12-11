// ignore_for_file: use_key_in_widget_constructors

import 'package:cinephilia/bloc/details_bloc.dart';
import 'package:cinephilia/model/details_model.dart';
import 'package:cinephilia/utils/download.dart';
import 'package:cinephilia/utils/helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DetailsScreen extends StatefulWidget {
  final String id;

  const DetailsScreen(this.id);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late Download download;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    detailsBloc.id = widget.id;
    detailsBloc.fetch();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android: android, iOS: iOS);
    download = Download(flutterLocalNotificationsPlugin);

    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: download.onSelectNotification);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: detailsBloc.details,
          builder: (context, AsyncSnapshot<Details> snapshot) {
            if (snapshot.hasData) {
              return _buildYts(snapshot.requireData);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return const Center(child: SpinKitWave(
              color: Colors.blue,
              size: 50.0,
            ));
          }),
    );
  }

  Widget _buildYts(Details data) {
    // ignore: avoid_unnecessary_containers
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      scrollController.animateTo(
          scrollController.positions.first.maxScrollExtent,
          curve: Curves.linear,
          duration: Duration(seconds: 1));
    });
    return Scrollbar(
      child: CustomScrollView(
          controller: scrollController,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height /2,
              collapsedHeight: 57,
              stretch: true,
              pinned: true,
              actionsIconTheme: IconThemeData(opacity: 0.0),
              flexibleSpace: FlexibleSpaceBar(
                title: Container(
                  child: Text(
                    data.data.movie.titleLong,
                  ),
                ),
                centerTitle: true,
                stretchModes: [
                  // StretchMode.blurBackground,
                  StretchMode.zoomBackground,
                  StretchMode.fadeTitle
                ],
                background: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Image.network(
                    data.data.movie.largeCoverImage,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    height: MediaQuery.of(context).size.height / 1.11,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              RatingBar.builder(
                                initialRating: data.data.movie.rating / 2,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemSize: 25,
                                itemCount: 5,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: .0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 5,
                                ),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                },
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 60,
                                alignment: Alignment.topCenter,
                                color: Colors.transparent,
                                child: Text(
                                  data.data.movie.rating.toString(),
                                  style: TextStyle(fontSize: 30),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          height: 20,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: data.data.movie.genres.length,
                              itemBuilder: (BuildContext ctx, index) {
                                return Container(
                                    alignment: Alignment.center,
                                    height: 30,
                                    width: 75,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.blue,
                                    ),
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text(
                                        '${data.data.movie.genres[index]}',style: TextStyle(color: Colors.white),));
                              }),
                        ),
                        Container(
                          // height: 160,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: Text(
                            data.data.movie.descriptionIntro,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            print('button tabbed');
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('quality'),
                                    content: Container(
                                      height: 300.0,
                                      // Change as per your requirement
                                      width: 300.0,
                                      // Change as per your requirement
                                      child: ListView.builder(
                                        physics: BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount:
                                            data.data.movie.torrents.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Column(
                                            children: [
                                              ListTile(
                                                title: Text(data.data.movie
                                                    .torrents[index].quality),
                                                trailing: Text(data.data.movie
                                                    .torrents[index].type),
                                                subtitle: Text(data.data.movie
                                                    .torrents[index].size),
                                                onTap: () {
                                                  if (kIsWeb) {
                                                    helper.launchURL(data
                                                        .data
                                                        .movie
                                                        .torrents[index]
                                                        .url);
                                                  } else {
                                                    download
                                                        .download(
                                                            "Cinephilia ${data.data.movie.titleLong} ${data.data.movie.torrents[index].quality} ${data.data.movie.torrents[index].type}.torrent",
                                                            data
                                                                .data
                                                                .movie
                                                                .torrents[index]
                                                                .url)
                                                        .then((value) {
                                                      Navigator.pop(context);
                                                    });
                                                  }
                                                },
                                              ),
                                              Divider()
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2.2,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.blueAccent,
                                    Colors.lightBlueAccent
                                  ]),
                            ),
                            child: Center(
                                child: Text(
                              'Download',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            )),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Choose Server'),
                                    content: Container(
                                      height: 310.0,
                                      // Change as per your requirement
                                      width: 300.0,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            ListTile(
                                              onTap: () {
                                                helper.launchURL(
                                                    'https://database.gdriveplayer.us/player.php?imdb=${data.data.movie.imdbCode}');
                                              },
                                              title: Text('Server 1'),
                                              subtitle: Text('video database'),
                                            ),
                                            Divider(),
                                            ListTile(
                                              onTap: () {
                                                helper.launchURL(
                                                    'https://googlvideo.com/imdb.php?imdb=${data.data.movie.imdbCode}&server=vcs');
                                              },
                                              title: Text('Server 2'),
                                              subtitle: Text('google video'),
                                            ),
                                            Divider(),
                                            ListTile(
                                              onTap: () {
                                                helper.launchURL(
                                                    'https://googlvideo.com/imdb.php?imdb=${data.data.movie.imdbCode}&server=serverf4');
                                              },
                                              title: Text('Server 3'),
                                              subtitle: Text('123 movie'),
                                            ),
                                            Divider(),
                                            ListTile(
                                              onTap: () {
                                                helper.launchURL(
                                                    'https://v2.vidsrc.me/embed/${data.data.movie.imdbCode}');
                                              },
                                              title: Text('Server 4'),
                                              subtitle: Text('video src'),
                                            ),
                                            Divider(),
                                            Text(
                                                'notice: some of the server maybe not working properly'),
                                          ],
                                        ),
                                      ), // Change as per your requirement
                                    ),
                                  );
                                });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2.2,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.blueAccent,
                                    Colors.lightBlueAccent
                                  ]),
                            ),
                            child: Center(
                                child: Text(
                              'Watch online',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            )),
                          ),
                        ),
                        openRelatedApp(
                            'https://www.imdb.com/title/${data.data.movie.imdbCode}/',
                            'images/imdb.png',
                            'For further information open'),
                        openRelatedApp(
                            'https://m.youtube.com/watch?v=${data.data.movie.ytTrailerCode}',
                            'images/youtube.png',
                            'To watch the trailer open'),
                      ],
                    ),
                  );
                },
                childCount: 1,
              ),
            ),
          ]),
    );
  }

  Widget openRelatedApp(String url, String path, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          text,
          style: TextStyle(fontSize: 17),
        ),
        GestureDetector(
          onTap: () {
            helper.launchURL(url);
          },
          child: Container(
            height: 50,
            width: 100,
            child: Image.asset(path),
          ),
        ),
      ],
    );
  }
}
