import 'package:cinephilia/ui/details_screen.dart';
import 'package:cinephilia/ui/see_more.dart';
import 'package:cinephilia/ui/series_details.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class Helper {
  DateTime currentBackPressTime = DateTime(0);

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'press BACK again to exit');
      return Future.value(false);
    }
    return Future.value(true);
  }

  goTo(BuildContext context, Widget widget) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => widget));
  }

  goBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  Widget title(String title, int bloc, BuildContext context) {
    return ListTile(
      title: Text(
        '$title',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
      trailing: TextButton(
        onPressed: () {
          helper.goTo(context, SeeMore(bloc));
        },
        child: Text(
          'See more',
        ),
      ),
    );
  }

  Widget buildMovies(Stream stream, context, bool isYts) {
    return Container(
      margin: EdgeInsets.only(left: 6, top: 15, bottom: 15),
      width: MediaQuery.of(context).size.width,
      height: 210,
      child: StreamBuilder(
          stream: stream,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  itemCount: isYts
                      ? snapshot.data!.data.movies.length
                      : snapshot.data!.results.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        GestureDetector(
                          onTap: () {
                            helper.goTo(
                                context,
                                isYts
                                    ? DetailsScreen(snapshot
                                        .data!.data.movies[index].id
                                        .toString())
                                    : SeriesDetails(snapshot
                                        .data!.results[index].id
                                        .toString()));
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            width: 140,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                    isYts
                                        ? snapshot.data!.data.movies[index]
                                            .largeCoverImage
                                        : 'https://www.themoviedb.org/t/p/w600_and_h900_bestv2/${snapshot.data!.results[index].posterPath}',
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;

                                  return Shimmer.fromColors(
                                    baseColor: Theme.of(context).cardColor,
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
                                isYts
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
                              margin: EdgeInsets.only(left: 20, bottom: 10),
                              // height: 18,
                              width: 120,
                              child: Text(
                                isYts
                                    ? snapshot.data!.data.movies[index].title
                                    : snapshot.data!.results[index].name,
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
                                colors: [
                                  Colors.blueAccent,
                                  Colors.lightBlueAccent
                                ]),
                          ),
                          margin: EdgeInsets.only(bottom: 170, left: 110),
                          child: Center(
                              child: Text(
                            isYts
                                ? snapshot.data!.data.movies[index].rating
                                    .toString()
                                : snapshot.data!.results[index].voteAverage
                                    .toString(),
                            style: TextStyle(color: Colors.white),
                          )),
                        )
                      ],
                    );
                  });
            }
            if (snapshot.hasError) {
              return Center(child: Text('no internet'));
            }
            return const Center(child: Text(''));
          }),
    );
  }

  launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
}

Helper helper = Helper();
