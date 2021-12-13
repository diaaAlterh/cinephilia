import 'package:cinephilia/bloc/yts_bloc.dart';
import 'package:cinephilia/bloc/yts_download_bloc.dart';
import 'package:cinephilia/bloc/yts_popular_bloc.dart';
import 'package:cinephilia/bloc/yts_rated_bloc.dart';
import 'package:cinephilia/bloc/yts_recent_bloc.dart';
import 'package:cinephilia/ui/ad_state.dart';
import 'package:cinephilia/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class MoviesScreen extends StatefulWidget {
  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {




  late List itemList=[
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
  ];

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    await adState.initialization.then((value) {
      for(int i=itemList.length-2;i>=1;i-=2){
        itemList.insert(i,  BannerAd(
            size: AdSize.banner,
            adUnitId: adState.bannerAdUnit,
            listener: adState.adListener,
            request: AdRequest())
          ..load().whenComplete(() {
            setState(() {

            });
          }));

      }});
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
          itemBuilder: (context ,index){
            if(itemList[index] is Widget){
              return itemList[index] as Widget;
            }else{
              return Container(
                height: 50,
                child: AdWidget(ad: itemList[index] as BannerAd,),
              );
            }

          },
          itemCount: itemList.length,
          physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),

        ),
      ),
    );
  }
}
