import 'dart:ui';
import 'package:cinephilia/bloc/season_bloc.dart';
import 'package:cinephilia/model/season_model.dart';
import 'package:cinephilia/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class SeasonEpisode extends StatefulWidget {
  final String id;
  final String imdbId;
  final int s;

  const SeasonEpisode(this.id, this.s, this.imdbId);

  @override
  _SeasonEpisodeState createState() => _SeasonEpisodeState();
}

class _SeasonEpisodeState extends State<SeasonEpisode> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    seasonBloc.id = widget.id;
    seasonBloc.s = widget.s;
    seasonBloc.fetch();
    print('init');
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    return Scaffold(
      body: StreamBuilder<SeasonModel>(
          stream: seasonBloc.season,
          builder: (context, AsyncSnapshot<SeasonModel> snapshot) {
            if (snapshot.hasData) {
              return Stack(
                children: [
                  Container(
                    child: Image.network(
                      'https://www.themoviedb.org/t/p/w600_and_h900_bestv2/${snapshot.data!.posterPath}',
                      fit: BoxFit.fill,
                      height: MediaQuery.of(context).size.height,
                    ),
                  ),
                  Container(
                    child: new BackdropFilter(
                      filter: new ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: new Container(
                        decoration: new BoxDecoration(
                            color: Colors.white.withOpacity(0.0)),
                      ),
                    ),
                  ),
                  Container(
                    child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data!.episodes.length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: Colors.orange.withOpacity(0.05),
                            child: ListTile(
                              onTap: () {
                                print('button tabbed');
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Choose Server'),
                                        content: Container(
                                          height: 300.0,
                                          // Change as per your requirement
                                          width: 300.0,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  onTap: () {
                                                    helper.launchURL(
                                                        'https://googlvideo.com/tmdb_api.php?se=${widget.s}&ep=${snapshot.data!.episodes[index].episodeNumber}&tmdb=${widget.id}&server_name=vcu');
                                                  },
                                                  title: Text('Server 1'),
                                                  subtitle: Text('google video'),
                                                ),
                                                Divider(),
                                                ListTile(
                                                  onTap: () {
                                                    helper.launchURL(
                                                        'https://database.gdriveplayer.us/player.php?type=series&tmdb=${widget.id}&season=${widget.s}&episode=${snapshot.data!.episodes[index].episodeNumber}');
                                                  },
                                                  title: Text('Server 2'),
                                                  subtitle:
                                                      Text('video database'),
                                                ),
                                                Divider(),
                                                ListTile(
                                                  onTap: () {
                                                    helper.launchURL(
                                                        'https://v2.vidsrc.me/embed/${widget.imdbId}/${widget.s}-${snapshot.data!.episodes[index].episodeNumber}/');
                                                  },
                                                  title: Text('Server 3'),
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
                              title: Text(
                                'Episode ${snapshot.data!.episodes[index].episodeNumber.toString()} (${snapshot.data!.episodes[index].name.toString()})',
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                snapshot.data!.episodes[index].overview,
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.6)),
                              ),
                              leading: Container(
                                height: 100,
                                width: 55,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(1000),
                                    child: Image.network(
                                        'https://www.themoviedb.org/t/p/w600_and_h900_bestv2/${snapshot.data?.episodes[index].stillPath}',
                                        loadingBuilder: (context, child,
                                            loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;

                                          return Shimmer.fromColors(
                                            baseColor:
                                            Theme.of(context).cardColor,
                                            highlightColor:
                                            Colors.white.withOpacity(0.6),
                                            child: Container(
                                              color: Colors.white,
                                            ),
                                          );
                                        },fit: BoxFit.fill,)
                                ),
                              ),
                              trailing: Column(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 40,
                                  ),
                                  Text(snapshot.data!.episodes[index].voteAverage.toString().substring(0,3),style: TextStyle(color: Colors.white),)
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
