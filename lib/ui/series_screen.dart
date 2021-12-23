import 'package:cinephilia/bloc/tmdb_onTheAir_bloc.dart';
import 'package:cinephilia/bloc/tmdb_popular_bloc.dart';
import 'package:cinephilia/bloc/tmdb_rated_bloc.dart';
import 'package:cinephilia/utils/ads_handler.dart';
import 'package:cinephilia/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class SeriesScreen extends StatefulWidget {
  @override
  _SeriesScreenState createState() => _SeriesScreenState();
}

class _SeriesScreenState extends State<SeriesScreen> {
  late List itemList;

  @override
  didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    itemList = [
      helper.title('Trending', 7, context, tmdbOnTheAirBloc.tmdbOnTheAir),
      helper.buildMovies(tmdbOnTheAirBloc.tmdbOnTheAir, context, false),
      helper.title('Top Rated', 8, context, tmdbRatedBloc.tmdbRated),
      helper.buildMovies(tmdbRatedBloc.tmdbRated, context, false),
      helper.title('Most Popular', 9, context, tmdbPopularBloc.tmdbPopular),
      helper.buildMovies(tmdbPopularBloc.tmdbPopular, context, false),
    ];
    adsHandler.CreateBannerAd(itemList);
  }

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
        onRefresh: () {
          tmdbRatedBloc.fetch();
          tmdbPopularBloc.fetch();
          tmdbOnTheAirBloc.fetch();
          return Future.delayed(Duration(seconds: 2));
        },
        child: ListView.builder(
          itemBuilder: (context, index) {
            if (itemList[index] is Widget) {
              return itemList[index] as Widget;
            } else {
              return Container(
                height: 50,
                child: AdWidget(
                  ad: itemList[index] as BannerAd,
                ),
              );
            }
          },
          itemCount: itemList.length,
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        ),
      ),
    );
  }
}
