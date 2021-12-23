import 'package:cinephilia/bloc/yts_bloc.dart';
import 'package:cinephilia/bloc/yts_download_bloc.dart';
import 'package:cinephilia/bloc/yts_popular_bloc.dart';
import 'package:cinephilia/bloc/yts_rated_bloc.dart';
import 'package:cinephilia/bloc/yts_recent_bloc.dart';
import 'package:cinephilia/utils/ads_handler.dart';
import 'package:cinephilia/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MoviesScreen extends StatefulWidget {
  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  late List itemList;

  @override
  didChangeDependencies()  {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    itemList = [
      helper.title('Most Popular', 1, context, ytsPopularBloc.ytsPopular),
      helper.buildMovies(ytsPopularBloc.ytsPopular, context, true),
      helper.title('Top Rated', 2, context, ytsRatedBloc.ytsRated),
      helper.buildMovies(ytsRatedBloc.ytsRated, context, true),
      helper.title('Most Downloaded', 3, context, ytsDownloadBloc.ytsDownload),
      helper.buildMovies(ytsDownloadBloc.ytsDownload, context, true),
      helper.title('Recently Added', 5, context, ytsRecentBloc.ytsRecent),
      helper.buildMovies(ytsRecentBloc.ytsRecent, context, true),
      helper.title(
          'New Movies (${DateTime.now().year})', 4, context, ytsBloc.yts),
      helper.buildMovies(ytsBloc.yts, context, true),
    ];
    adsHandler.CreateBannerAd(itemList);
  }

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
      body: RefreshIndicator(
        onRefresh: () {
          ytsBloc.fetch();
          ytsRatedBloc.fetch();
          ytsPopularBloc.fetch();
          ytsRecentBloc.fetch();
          ytsDownloadBloc.fetch();
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
