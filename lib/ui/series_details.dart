import 'package:cinephilia/bloc/convert_id_bloc.dart';
import 'package:cinephilia/bloc/tmdb_details_bloc.dart';
import 'package:cinephilia/model/tmdb_details.dart';
import 'package:cinephilia/ui/seasonEpisodes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class SeriesDetails extends StatefulWidget {
  final String id;

  const SeriesDetails(this.id);

  @override
  _SeriesDetailsState createState() => _SeriesDetailsState();
}

class _SeriesDetailsState extends State<SeriesDetails> {
  ScrollController scrollController = ScrollController();
  String id = '';

  @override
  void initState() {
    tmdbDetailsBloc.id = widget.id;
    tmdbDetailsBloc.fetch();
    convertIdBloc.id = widget.id;
    convertIdBloc.fetch();
    convertIdBloc.convertId.listen(
      (event) {
        id = event.imdbId;
      },
      onError: (error) {
        print(error);
      },
      cancelOnError: true,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: tmdbDetailsBloc.tmdbDetails,
          builder: (context, AsyncSnapshot<TmdbDetails> snapshot) {
            if (snapshot.hasData) {
              return _buildDetails(snapshot.requireData);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }

  Widget _buildDetails(TmdbDetails data) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      scrollController.animateTo(
          scrollController.positions.first.maxScrollExtent,
          curve: Curves.linear,
          duration: Duration(seconds: 1));
    });

    return Scrollbar(
      showTrackOnHover: true,
      controller: scrollController,
      child: NestedScrollView(
          controller: scrollController,
          physics: BouncingScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.height / 1.03,
                stretch: true,
                pinned: true,
                actionsIconTheme: IconThemeData(opacity: 0.0),
                flexibleSpace: FlexibleSpaceBar(
                  title: Container(
                    child: Text(data.name),
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
                    child: Image.network(
                      'https://www.themoviedb.org/t/p/w600_and_h900_bestv2/${data.posterPath}',
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
                  margin: EdgeInsets.only(top: 90, bottom: 20),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      RatingBar.builder(
                        initialRating: data.voteAverage / 2,
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
                          data.voteAverage.toString(),
                          style: TextStyle(fontSize: 30),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  height: 20,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data.genres.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return Center(
                            child: Text('${data.genres[index].name}, '));
                      }),
                ),
                if(data.spokenLanguages.toString()!='[]')Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: Text(
                      'Spoken languages : ${data.spokenLanguages.first.englishName}\nProduction company : ${data.productionCompanies.first.name}\nstatus : ${data.status}\nTagline : ${data.tagline}\nfirst Air : ${data.firstAirDate}'),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Text(
                    data.overview,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  height: 210,
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: data.seasons.length,
                      itemBuilder: (context, index) {
                        if (data.seasons[index].posterPath != '' &&
                            data.seasons[index].name != 'Specials') {
                          return Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  ///details
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => SeasonEpisode(
                                          data.id.toString(),
                                          data.seasons[index].seasonNumber,
                                          id)));
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  width: 140,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                          'https://www.themoviedb.org/t/p/w600_and_h900_bestv2/${data.seasons[index].posterPath}',
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
                                      data.seasons[index].airDate.toString(),
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white.withOpacity(0.8)),
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 20, bottom: 10),
                                    // height: 18,
                                    width: 120,
                                    child: Text(
                                      data.seasons[index].name,
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
                                  data.seasons[index].episodeCount.toString(),
                                  style: TextStyle(color: Colors.white),
                                )),
                              )
                            ],
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      }),
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
                        _launchURL('https://www.imdb.com/title/$id/');
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        child: Image.asset('images/imdb.png'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }

  void _launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
}
