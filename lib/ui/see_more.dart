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
import 'package:cinephilia/model/tmdb.dart';
import 'package:cinephilia/model/yts_model.dart';
import 'package:cinephilia/ui/series_details.dart';
import 'package:cinephilia/ui/series_screen.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'details_screen.dart';

class SeeMore extends StatefulWidget {
  final int bloc;

  const SeeMore(this.bloc);

  @override
  _SeeMoreState createState() => _SeeMoreState();
}

class _SeeMoreState extends State<SeeMore> {
  bool show = false;
  ScrollController scrollController = ScrollController();
  final TextEditingController _searchQueryController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    print(widget.bloc);
    scrollController.addListener(scrollListener);

    // TODO: implement initState
    super.initState();

    loadItems();
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        back(true);
        return true;
      },
      child: Scaffold(
        body: Column(
          children: [
            if (widget.bloc != 0 && widget.bloc != 6)
              ListTile(
                title: Container(
                  height: 50,
                  width: 90,
                  margin: EdgeInsets.only(left: 0, top: 30),
                  child: GestureDetector(
                    onTap: () {
                      back(true);
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                        ),
                        Text(
                          'Back',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        )
                      ],
                    ),
                  ),
                ),
                subtitle: Text(
                  (widget.bloc == 0 || widget.bloc == 6)
                      ? ''
                      : (widget.bloc == 1)
                          ? 'Most Popular List'
                          : (widget.bloc == 2)
                              ? 'Top Rated List'
                              : (widget.bloc == 3)
                                  ? 'Most Downloaded List'
                                  : (widget.bloc == 4)
                                      ? 'New List'
                                      : (widget.bloc == 5)
                                          ? 'Recently Added List'
                                          : (widget.bloc == 7)
                                              ? 'Trending TV Shows List'
                                              : (widget.bloc == 8)
                                                  ? 'Top Rated TV Shows List'
                                                  : (widget.bloc == 9)
                                                      ? 'Most Popular TV Shows List'
                                                      : '',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            if (widget.bloc == 0 || widget.bloc == 6)
              Container(
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 10),
                child: TextField(
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.search,
                  controller: _searchQueryController,
                  focusNode: focusNode,
                  autofocus: true,
                  style: TextStyle(color: Theme.of(context).textSelectionColor),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        if (widget.bloc == 0)
                          ytsSearchBloc.searchText =
                              _searchQueryController.text;
                        if (widget.bloc == 6)
                          tmdbSearchBloc.searchText =
                              _searchQueryController.text;
                        focusNode.unfocus();
                        if (widget.bloc == 0) ytsSearchBloc.fetch();
                        if (widget.bloc == 6) tmdbSearchBloc.fetch();
                        scrollController.animateTo(0,
                            duration: Duration(seconds: 1),
                            curve: Curves.linear);
                      },
                      icon: Icon(
                        Icons.search,
                      ),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        borderSide: BorderSide(color: Colors.teal)),
                    labelText: (widget.bloc == 0)
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
              ),
            if (widget.bloc < 6)
              Expanded(
                  child: Container(
                margin: EdgeInsets.only(left: 20, right: 0),
                child: StreamBuilder(
                    stream: (widget.bloc == 0)
                        ? ytsSearchBloc.ytsSearch
                        : (widget.bloc == 1)
                            ? ytsPopularBloc.ytsPopular
                            : (widget.bloc == 2)
                                ? ytsRatedBloc.ytsRated
                                : (widget.bloc == 3)
                                    ? ytsDownloadBloc.ytsDownload
                                    : (widget.bloc == 4)
                                        ? ytsBloc.yts
                                        : ytsRecentBloc.ytsRecent,
                    builder: (context, AsyncSnapshot<Yts> snapshot) {
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
                              itemCount: snapshot.data!.data.movies.length,
                              itemBuilder: (BuildContext ctx, index) {
                                return Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailsScreen(snapshot.data!
                                                        .data.movies[index].id
                                                        .toString())));
                                      },
                                      child: ClipRRect(
                                        child: Image.network(
                                            snapshot.data?.data?.movies[index]
                                                    ?.largeCoverImage ??
                                                '',
                                            fit: BoxFit.fill, loadingBuilder:
                                                (context, child,
                                                    loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;

                                          return Shimmery();
                                        }),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          width: 120,
                                          margin: EdgeInsets.only(left: 10),
                                          child: Text(
                                            snapshot
                                                .data!.data.movies[index].year
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white
                                                    .withOpacity(0.8)),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 10, bottom: 10),
                                          // height: 18,
                                          width: 120,
                                          child: Text(
                                            snapshot
                                                .data!.data.movies[index].title,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
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
                                            colors: [
                                              Colors.orange,
                                              Colors.red
                                            ]),
                                      ),
                                      margin:
                                          EdgeInsets.only(top: 10, left: 120),
                                      child: Center(
                                          child: Text(
                                        snapshot.data!.data.movies[index].rating
                                            .toString(),
                                        style: TextStyle(color: Colors.white),
                                      )),
                                    )
                                  ],
                                );
                              }),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text('no internet'),
                        );
                      }

                      return Center(
                        child: Text(''),
                      );
                    }),
              )),
            if (widget.bloc >= 6)
              Expanded(
                  child: Container(
                margin: EdgeInsets.only(left: 20, right: 0),
                child: StreamBuilder(
                    stream: (widget.bloc == 6)
                        ? tmdbSearchBloc.tmdbSearch
                        : (widget.bloc == 7)
                            ? tmdbOnTheAirBloc.tmdbOnTheAir
                            : (widget.bloc == 8)
                                ? tmdbRatedBloc.tmdbRated
                                : (widget.bloc == 9)
                                    ? tmdbPopularBloc.tmdbPopular
                                    : null,
                    builder: (context, AsyncSnapshot<Tmdb> snapshot) {
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
                              itemCount: snapshot.data!.results.length,
                              itemBuilder: (BuildContext ctx, index) {
                                return Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(builder: (context) => SeriesDetails(snapshot.data!.results[index].id.toString())));
                                        print("https://api.themoviedb.org/3/tv/${snapshot.data!.results[index].id}?api_key=529bf848d14b9fc7da265edcae678a08&language=en-US");
                                        print("https://api.themoviedb.org/3/tv/${snapshot.data!.results[index].id}/episode_groups?api_key=529bf848d14b9fc7da265edcae678a08&language=en-US");
                                      },
                                      child: ClipRRect(
                                        child: Image.network(
                                            'https://www.themoviedb.org/t/p/w600_and_h900_bestv2/${snapshot.data!.results[index].posterPath}',
                                            fit: BoxFit.fill, errorBuilder:
                                                (context, child,
                                                    loadingProgress) {
                                          print('error in pic');

                                          if (loadingProgress == null)
                                            return SizedBox();
                                          print('error in pic');

                                          return Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.movie,
                                                  size: 80,
                                                ),
                                                Text('damaged content')
                                              ],
                                            ),
                                          );
                                        }, loadingBuilder: (context, child,
                                                loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Shimmery();
                                        }),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          width: 120,
                                          margin: EdgeInsets.only(left: 10),
                                          child: Text(
                                            snapshot.data!.results[index]
                                                .firstAirDate
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white
                                                    .withOpacity(0.8)),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 10, bottom: 10),
                                          // height: 18,
                                          width: 120,
                                          child: Text(
                                            snapshot.data!.results[index].name,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
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
                                            colors: [
                                              Colors.orange,
                                              Colors.red
                                            ]),
                                      ),
                                      margin:
                                          EdgeInsets.only(top: 10, left: 120),
                                      child: Center(
                                          child: Text(
                                        snapshot
                                            .data!.results[index].voteAverage
                                            .toString(),
                                        style: TextStyle(color: Colors.white),
                                      )),
                                    )
                                  ],
                                );

                              }),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('no internet'),
                        );
                      }
                      return Center(
                        child: Text(''),
                      );
                    }),
              )),
            if (show && widget.bloc != 0 && widget.bloc != 6)
              Container(
                height: 35,
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () {
                          back(false);
                          scrollController.animateTo(0,
                              duration: Duration(seconds: 2),
                              curve: Curves.linear);
                        },
                        icon: Icon(Icons.arrow_back_ios_outlined)),
                    Text((widget.bloc == 1)
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
                                                        .toString()
                                                    : ''),
                    IconButton(
                        onPressed: () {
                          loadItems();
                          scrollController.animateTo(0,
                              duration: Duration(seconds: 1),
                              curve: Curves.linear);
                        },
                        icon: Icon(Icons.arrow_forward_ios_outlined)),
                  ],
                ),
              )
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
    }
  }

  loadItems() {
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
  }

  scrollListener() async {
    if (scrollController.position.maxScrollExtent == scrollController.offset) {
      show = true;
      print(show);
      setState(() {});
    }
    if (0 == scrollController.offset) {
      show = false;
      print(show);
      setState(() {});
    }
  }

  Widget Shimmery() {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).cardColor,
      highlightColor: Colors.white.withOpacity(0.6),
      child: Container(
        // height: 100,
        width: 170,

        color: Colors.white,
      ),
    );
  }
}
