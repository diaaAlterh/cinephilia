import 'package:cinephilia/bloc/geners_bloc.dart';
import 'package:cinephilia/bloc/tmdb_onTheAir_bloc.dart';
import 'package:cinephilia/bloc/tmdb_popular_bloc.dart';
import 'package:cinephilia/bloc/tmdb_rated_bloc.dart';
import 'package:cinephilia/bloc/tmdb_search_bloc.dart';
import 'package:cinephilia/bloc/yts_bloc.dart';
import 'package:cinephilia/bloc/yts_download_bloc.dart';
import 'package:cinephilia/bloc/yts_popular_bloc.dart';
import 'package:cinephilia/bloc/yts_rated_bloc.dart';
import 'package:cinephilia/bloc/yts_recent_bloc.dart';
import 'package:cinephilia/bloc/yts_search_bloc.dart';
import 'package:cinephilia/ui/series_details.dart';
import 'package:cinephilia/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'details_screen.dart';

class SeeMore extends StatefulWidget {
  final int bloc;
  final Stream stream;
  final String genre;

  const SeeMore(this.bloc, this.stream, {this.genre = ''});

  @override
  _SeeMoreState createState() => _SeeMoreState();
}

class _SeeMoreState extends State<SeeMore> {
  ScrollController scrollController = ScrollController();
  final TextEditingController _searchQueryController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        back(true);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: (widget.bloc != 0 && widget.bloc != 6)
              ? Text(
                  (widget.bloc == 0 || widget.bloc == 6)
                      ? ''
                      : (widget.bloc == -1)
                          ? '${widget.genre} Movies List'
                          : (widget.bloc == 1)
                              ? 'Most Popular Movies List'
                              : (widget.bloc == 2)
                                  ? 'Top Rated Movies List'
                                  : (widget.bloc == 3)
                                      ? 'Most Downloaded Movies List'
                                      : (widget.bloc == 4)
                                          ? '${DateTime.now().year} Movies List'
                                          : (widget.bloc == 5)
                                              ? 'Recently Added Movies List'
                                              : (widget.bloc == 7)
                                                  ? 'Trending TV Shows List'
                                                  : (widget.bloc == 8)
                                                      ? 'Top Rated TV Shows List'
                                                      : (widget.bloc == 9)
                                                          ? 'Most Popular TV Shows List'
                                                          : '',
                  style: TextStyle(fontSize: 18),
                )
              : TextField(
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.search,
                  controller: _searchQueryController,
                  focusNode: focusNode,
                  autofocus: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    hintText: (widget.bloc == 0)
                        ? "Search for movies..."
                        : "Search for TV shows...",
                  ),
                  onSubmitted: (query) {
                    if (widget.bloc == 0)
                      ytsSearchBloc.searchText = _searchQueryController.text;
                    if (widget.bloc == 6)
                      tmdbSearchBloc.searchText = _searchQueryController.text;
                    if (widget.bloc == 0) ytsSearchBloc.fetch();
                    if (widget.bloc == 6) tmdbSearchBloc.fetch();
                    scrollController.animateTo(0,
                        duration: Duration(seconds: 1), curve: Curves.linear);
                  },
                ),
          actions: [
            if ((widget.bloc == 0 || widget.bloc == 6))
              IconButton(
                onPressed: () {
                  if (widget.bloc == 0)
                    ytsSearchBloc.searchText = _searchQueryController.text;
                  if (widget.bloc == 6)
                    tmdbSearchBloc.searchText = _searchQueryController.text;
                  focusNode.unfocus();
                  if (widget.bloc == 0) ytsSearchBloc.fetch();
                  if (widget.bloc == 6) tmdbSearchBloc.fetch();
                  scrollController.animateTo(0,
                      duration: Duration(seconds: 1), curve: Curves.linear);
                },
                icon: Icon(
                  Icons.search,
                ),
              ),
            if ((widget.bloc != 0 && widget.bloc != 6))
              IconButton(
                  tooltip: 'previous page',
                  onPressed: () {
                    back(false);
                    scrollController.animateTo(0,
                        duration: Duration(seconds: 2), curve: Curves.linear);
                  },
                  icon: Icon(Icons.arrow_back_ios_outlined)),
            if ((widget.bloc != 0 && widget.bloc != 6))
              Center(
                child: Text(
                  (widget.bloc == 1)
                      ? ytsPopularBloc.pageNumber.toString()
                      : (widget.bloc == 2)
                          ? ytsRatedBloc.pageNumber.toString()
                          : (widget.bloc == 3)
                              ? ytsDownloadBloc.pageNumber.toString()
                              : (widget.bloc == 4)
                                  ? ytsBloc.pageNumber.toString()
                                  : (widget.bloc == 5)
                                      ? ytsRecentBloc.pageNumber.toString()
                                      : (widget.bloc == 7)
                                          ? tmdbOnTheAirBloc.pageNumber
                                              .toString()
                                          : (widget.bloc == 8)
                                              ? tmdbRatedBloc.pageNumber
                                                  .toString()
                                              : (widget.bloc == 9)
                                                  ? tmdbPopularBloc.pageNumber
                                                      .toString(): (widget.bloc == -1)
                                                  ? genresBloc.pageNumber
                                                      .toString()
                                                  : '',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            if ((widget.bloc != 0 && widget.bloc != 6))
              IconButton(
                  tooltip: 'forward',
                  onPressed: () {
                    loadItems(b: widget.bloc==-1?true:false);
                    scrollController.animateTo(0,
                        duration: Duration(seconds: 1), curve: Curves.linear);
                  },
                  icon: Icon(Icons.arrow_forward_ios_outlined)),
          ],
        ),
        body: Column(
          children: [
            buildGrid((widget.bloc < 6) ? true : false),
          ],
        ),
      ),
    );
  }

  back(bool b) {
    if (widget.bloc == 1) {
      if (ytsPopularBloc.pageNumber != 1) {
        if (b == true) {
          ytsPopularBloc.pageNumber = 1;
        } else {
          ytsPopularBloc.pageNumber--;
        }
        print(ytsPopularBloc.pageNumber);
        ytsPopularBloc.fetch();
      }
    }
    if (widget.bloc == 2) {
      if (ytsRatedBloc.pageNumber != 1) {
        if (b == true) {
          ytsRatedBloc.pageNumber = 1;
        } else {
          ytsRatedBloc.pageNumber--;
        }
        print(ytsRatedBloc.pageNumber);
        ytsRatedBloc.fetch();
      }
    }
    if (widget.bloc == 3) {
      if (ytsDownloadBloc.pageNumber != 1) {
        if (b == true) {
          ytsDownloadBloc.pageNumber = 1;
        } else {
          ytsDownloadBloc.pageNumber--;
        }
        print(ytsDownloadBloc.pageNumber);
        ytsDownloadBloc.fetch();
      }
    }
    if (widget.bloc == 4) {
      if (ytsBloc.pageNumber != 1) {
        if (b == true) {
          ytsBloc.pageNumber = 1;
        } else {
          ytsBloc.pageNumber--;
        }
        print(ytsBloc.pageNumber);
        ytsBloc.fetch();
      }
    }
    if (widget.bloc == 5) {
      if (ytsRecentBloc.pageNumber != 1) {
        if (b == true) {
          ytsRecentBloc.pageNumber = 1;
        } else {
          ytsRecentBloc.pageNumber--;
        }
        print(ytsRecentBloc.pageNumber);
        ytsRecentBloc.fetch();
      }
    }
    if (widget.bloc == 7) {
      if (tmdbOnTheAirBloc.pageNumber != 1) {
        if (b == true) {
          tmdbOnTheAirBloc.pageNumber = 1;
        } else {
          tmdbOnTheAirBloc.pageNumber--;
        }
        print(tmdbOnTheAirBloc.pageNumber);
        tmdbOnTheAirBloc.fetch();
      }
    }
    if (widget.bloc == 8) {
      if (tmdbRatedBloc.pageNumber != 1) {
        if (b == true) {
          tmdbRatedBloc.pageNumber = 1;
        } else {
          tmdbRatedBloc.pageNumber--;
        }
        print(tmdbRatedBloc.pageNumber);
        tmdbRatedBloc.fetch();
      }
    }
    if (widget.bloc == 9) {
      if (tmdbPopularBloc.pageNumber != 1) {
        if (b == true) {
          tmdbPopularBloc.pageNumber = 1;
        } else {
          tmdbPopularBloc.pageNumber--;
        }
        print(tmdbPopularBloc.pageNumber);
        tmdbPopularBloc.fetch();
      }
    }if (widget.bloc == -1) {
      if (genresBloc.pageNumber != 1) {
        if (b == true) {
          genresBloc.pageNumber = 1;
        } else {
          genresBloc.pageNumber--;
        }
        print(genresBloc.pageNumber);
        genresBloc.fetch();
      }
    }
    setState(() {});
  }

  loadItems({bool b=false}) {
    if (widget.bloc == 1) {
      ytsPopularBloc.pageNumber++;
      print(ytsPopularBloc.pageNumber);
      ytsPopularBloc.fetch();
    }
    if (widget.bloc == 2) {
      ytsRatedBloc.pageNumber++;
      print(ytsRatedBloc.pageNumber);
      ytsRatedBloc.fetch();
    }
    if (widget.bloc == 3) {
      ytsDownloadBloc.pageNumber++;
      print(ytsDownloadBloc.pageNumber);
      ytsDownloadBloc.fetch();
    }
    if (widget.bloc == 4) {
      ytsBloc.pageNumber++;
      print(ytsBloc.pageNumber);
      ytsBloc.fetch();
    }
    if (widget.bloc == 5) {
      ytsRecentBloc.pageNumber++;
      print(ytsRecentBloc.pageNumber);
      ytsRecentBloc.fetch();
    }
    if (widget.bloc == 7) {
      tmdbOnTheAirBloc.pageNumber++;
      print(tmdbOnTheAirBloc.pageNumber);
      tmdbOnTheAirBloc.fetch();
    }
    if (widget.bloc == 8) {
      tmdbRatedBloc.pageNumber++;
      print(tmdbRatedBloc.pageNumber);
      tmdbRatedBloc.fetch();
    }
    if (widget.bloc == 9) {
      tmdbPopularBloc.pageNumber++;
      print(tmdbPopularBloc.pageNumber);
      tmdbPopularBloc.fetch();
    }
    if (widget.bloc == -1) {
      genresBloc.genre = widget.genre;
      if(b==true){genresBloc.pageNumber++;}
      print(genresBloc.pageNumber);
      genresBloc.fetch();
    }
    setState(() {});
  }

  Widget Shimmery(double width) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).cardColor,
      highlightColor: Colors.white.withOpacity(0.6),
      child: Container(
        width: width,
        color: Colors.white,
      ),
    );
  }

  Widget buildGrid(bool isyts) {
    return Expanded(
        child: Container(
      // margin: EdgeInsets.only(left: 20, top: 20),
      child: StreamBuilder(
          stream: widget.stream,
          builder: (context, AsyncSnapshot snapshot) {
            // if(snapshot.data?.data?.movies.length==0){
            //   return Center(child: Text('make sure you type a correct movie name'));
            // }
            if (snapshot.hasData) {
              return Scrollbar(
                child: GridView.builder(
                    controller: scrollController,
                    physics: BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 3 / 4,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 20),
                    itemCount: isyts
                        ? snapshot.data!.data.movies.length
                        : snapshot.data!.results.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return Container(
                        margin: EdgeInsets.only(left: 15, top: 20, right: 5),
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (isyts) {
                                  helper.goTo(
                                      context,
                                      DetailsScreen(snapshot
                                          .data!.data.movies[index].id
                                          .toString()));
                                } else {
                                  helper.goTo(
                                      context,
                                      SeriesDetails(snapshot
                                          .data!.results[index].id
                                          .toString()));
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 0, right: 10),
                                width: 170,
                                child: ClipRRect(
                                  child: Image.network(
                                      isyts
                                          ? snapshot.data?.data?.movies[index]
                                                  ?.largeCoverImage ??
                                              ''
                                          : 'https://www.themoviedb.org/t/p/w600_and_h900_bestv2/${snapshot.data!.results[index].posterPath}',
                                      fit: BoxFit.fill, errorBuilder:
                                          (context, child, loadingProgress) {
                                    print('error in pic');

                                    if (loadingProgress == null)
                                      return SizedBox();
                                    print('error in pic');

                                    return Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.movie,
                                            size: 80,
                                          ),
                                          Text('damaged content')
                                        ],
                                      ),
                                    );
                                  }, loadingBuilder:
                                          (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;

                                    return Shimmery(170);
                                  }),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: 120,
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    isyts
                                        ? snapshot.data!.data.movies[index].year
                                            .toString()
                                        : snapshot
                                            .data!.results[index].firstAirDate
                                            .toString(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white.withOpacity(0.8)),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10, bottom: 10),
                                  // height: 18,
                                  width: 120,
                                  child: Text(
                                    isyts
                                        ? snapshot
                                            .data!.data.movies[index].title
                                        : snapshot.data!.results[index].name,
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 170,
                              alignment: Alignment.topRight,
                              child: Container(
                                width: 30,
                                height: 30,
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
                                margin: EdgeInsets.only(top: 10, right: 18),
                                child: Center(
                                    child: Text(
                                  isyts
                                      ? snapshot.data!.data.movies[index].rating
                                          .toString()
                                      : snapshot
                                          .data!.results[index].voteAverage
                                          .toString(),
                                  style: TextStyle(color: Colors.white),
                                )),
                              ),
                            )
                          ],
                        ),
                      );
                    }),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('no internet'),
              );
            }

            return SizedBox.shrink();
          }),
    ));
  }
}
