import 'package:cinephilia/bloc/yts_bloc.dart';
import 'package:cinephilia/bloc/yts_download_bloc.dart';
import 'package:cinephilia/bloc/yts_popular_bloc.dart';
import 'package:cinephilia/bloc/yts_rated_bloc.dart';
import 'package:cinephilia/bloc/yts_recent_bloc.dart';
import 'package:cinephilia/utils/helper.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          helper.title('Most Popular', 1, context),
          helper.buildMovies(ytsPopularBloc.ytsPopular, context, true),
          helper.title('Top Rated', 2, context),
          helper.buildMovies(ytsRatedBloc.ytsRated, context, true),
          helper.title('Most Downloaded', 3, context),
          helper.buildMovies(ytsDownloadBloc.ytsDownload, context, true),
          helper.title('Recently Added', 5, context),
          helper.buildMovies(ytsRecentBloc.ytsRecent, context, true),
          helper.title('New Movies (${DateTime.now().year})', 4, context),
          helper.buildMovies(ytsBloc.yts, context, true),
        ],
      ),
    );
  }
}
