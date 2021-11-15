import 'package:cinephilia/bloc/tmdb_onTheAir_bloc.dart';
import 'package:cinephilia/bloc/tmdb_popular_bloc.dart';
import 'package:cinephilia/bloc/tmdb_rated_bloc.dart';
import 'package:cinephilia/utils/helper.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: (){
          tmdbRatedBloc.fetch();
          tmdbPopularBloc.fetch();
          tmdbOnTheAirBloc.fetch();
          return Future.delayed(Duration(seconds: 2));
        },
        child: ListView(
          physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: [
            helper.title('Trending', 7, context),
            helper.buildMovies(tmdbOnTheAirBloc.tmdbOnTheAir,context,false),
            helper.title('Top Rated', 8, context),
            helper.buildMovies(tmdbRatedBloc.tmdbRated,context,false),
            helper.title('Most Popular', 9, context),
            helper.buildMovies(tmdbPopularBloc.tmdbPopular,context,false),
          ],
        ),
      ),
    );
  }
}
