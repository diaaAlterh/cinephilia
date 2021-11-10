import 'package:cinephilia/bloc/tmdb_onTheAir_bloc.dart';
import 'package:cinephilia/bloc/tmdb_popular_bloc.dart';
import 'package:cinephilia/bloc/tmdb_rated_bloc.dart';
import 'package:cinephilia/model/tmdb.dart';
import 'package:cinephilia/ui/see_more.dart';
import 'package:cinephilia/ui/series_details.dart';
import 'package:cinephilia/utils/ThemeManager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class SeriesScreen extends StatefulWidget {
  @override
  _SeriesScreenState createState() => _SeriesScreenState();
}

class _SeriesScreenState extends State<SeriesScreen> {
  @override
  void initState() {
    super.initState();
    tmdbRatedBloc.fetch();
    tmdbPopularBloc.fetch();
    tmdbOnTheAirBloc.fetch();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, theme, _) => Scaffold(
              key: _scaffoldKey,
              body: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  title('Trending', 7),
                  buildMovies(tmdbOnTheAirBloc.tmdbOnTheAir),
                  title('Top Rated', 8),
                  buildMovies(tmdbRatedBloc.tmdbRated),
                  title('Most Popular', 9),
                  buildMovies(tmdbPopularBloc.tmdbPopular),
                ],
              ),
            ));
  }

  Widget buildMovies(Stream<Tmdb> stream) {
    return Container(
      margin: EdgeInsets.only(left: 6, top: 15, bottom: 15),
      width: MediaQuery.of(context).size.width,
      height: 210,
      child: StreamBuilder(
          stream: stream,
          builder: (context, AsyncSnapshot<Tmdb> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data!.results.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => SeriesDetails(snapshot.data!.results[index].id.toString())));
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  width: 140,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                          'https://www.themoviedb.org/t/p/w600_and_h900_bestv2/${snapshot.data!.results[index].posterPath}',
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
                                snapshot.data!.results[index].firstAirDate
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
                                snapshot.data!.results[index].name,
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
                            snapshot.data!.results[index].voteAverage
                                .toString(),
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
