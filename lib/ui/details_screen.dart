// ignore_for_file: use_key_in_widget_constructors

import 'package:cinephilia/bloc/details_bloc.dart';
import 'package:cinephilia/model/details_model.dart';
import 'package:cinephilia/utils/download.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';


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
            return const Center(child: CircularProgressIndicator());
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
      child: NestedScrollView(
          controller: scrollController,
          physics: BouncingScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(

                expandedHeight: MediaQuery.of(context).size.height/1.03,
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
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                    StretchMode.fadeTitle
                  ],
                  background: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.red,
                    child:Image.network(
                      data.data.movie.largeCoverImage,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ];
          },
          body: SingleChildScrollView(
            controller: scrollController,
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 100, bottom: 20),
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
                        itemPadding: EdgeInsets.symmetric(horizontal: .0),
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
                  margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Text(
                    data.data.movie.genres.toString(),
                  ),
                ),
                Container(
                  height: 160,
                  margin: EdgeInsets.only(left: 20, right: 20, bottom: 30),
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
                              height: 300.0, // Change as per your requirement
                              width: 300.0, // Change as per your requirement
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: data.data.movie.torrents.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        title: Text(data
                                            .data.movie.torrents[index].quality),
                                        trailing: Text(
                                            data.data.movie.torrents[index].type),
                                        subtitle: Text(
                                            data.data.movie.torrents[index].size),
                                        onTap: () {
                                          download
                                              .download(
                                                  "Cinephilia ${data.data.movie.titleLong} ${data.data.movie.torrents[index].quality} ${data.data.movie.torrents[index].type}.torrent",
                                                  data.data.movie.torrents[index]
                                                      .url)
                                              .then((value) {
                                            Navigator.pop(context);
                                          });
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
                    margin: EdgeInsets.only(bottom: 20),
                    width: MediaQuery.of(context).size.width / 2.2,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Colors.orange, Colors.red]),
                    ),
                    child: Center(
                        child: Text(
                      'Download',
                      style: TextStyle(fontSize: 20, color: Colors.white),
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
                                        _launchURL('https://database.gdriveplayer.us/player.php?imdb=${data.data.movie.imdbCode}');
                                      },
                                      title: Text('Server 1'),
                                      subtitle: Text('video database'),

                                    ),
                                    Divider(),
                                    ListTile(
                                      onTap: () {
                                        _launchURL('https://googlvideo.com/imdb.php?imdb=${data.data.movie.imdbCode}&server=vcs');
                                      },
                                      title: Text('Server 2'),
                                      subtitle: Text('google video'),

                                    ),
                                    Divider(), ListTile(
                                      onTap: () {
                                        _launchURL('https://googlvideo.com/imdb.php?imdb=${data.data.movie.imdbCode}&server=serverf4');
                                      },
                                      title: Text('Server 3'),
                                      subtitle: Text('123 movie'),

                                    ),
                                    Divider(),
                                    ListTile(
                                      onTap: () {
                                        _launchURL('https://v2.vidsrc.me/embed/${data.data.movie.imdbCode}');
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
                    margin: EdgeInsets.only(bottom: 20),
                    width: MediaQuery.of(context).size.width / 2.2,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Colors.orange, Colors.red]),
                    ),
                    child: Center(
                        child: Text(
                          'Watch online',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        )),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'For further information open',
                      style: TextStyle(fontSize: 17),
                    ),
                    GestureDetector(
                      onTap: () {
                        _launchURL('https://www.imdb.com/title/${data.data.movie.imdbCode}/');

                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        child: Image.asset('images/imdb.png'),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'To watch the trailer open',
                      style: TextStyle(fontSize: 17),
                    ),
                    GestureDetector(
                      onTap: () {
                        _launchURL('https://m.youtube.com/watch?v=${data.data.movie.ytTrailerCode}');

                      },
                      child: Container(
                        height: 80,
                        width: 80,
                        child: Image.asset('images/youtube.png'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  void _launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
}
