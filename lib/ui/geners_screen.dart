import 'package:cinephilia/bloc/geners_bloc.dart';
import 'package:cinephilia/ui/see_more.dart';
import 'package:cinephilia/utils/helper.dart';
import 'package:flutter/material.dart';

class GenersScreen extends StatefulWidget {
  @override
  _GenersScreenState createState() => _GenersScreenState();
}

class _GenersScreenState extends State<GenersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies Genres'),
      ),
      body: GridView.builder(
          padding: EdgeInsets.only(top: 20, left: 5, right: 5),
          itemCount: 12,
          physics: BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 4 / 2,
              crossAxisSpacing: 0,
              mainAxisSpacing: 25),
          itemBuilder: (BuildContext ctx, index) {
            return Container(
              height: 100,
              width: 100,
              // color: Colors.blue,
              child: Center(
                child: InkWell(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset('images/g${index + 1}.jpg')),
                  onTap: () {
                    helper.goTo(
                        context,
                        SeeMore(
                          -1,
                          genresBloc.genres,
                          genre: index == 0
                              ? 'Drama'
                              : index == 1
                                  ? 'Mystery'
                                  : index == 2
                                      ? 'Crime'
                                      : index == 3
                                          ? 'Action'
                                          : index == 4
                                              ? 'Romance'
                                              : index == 5
                                                  ? 'Thriller'
                                                  : index == 6
                                                      ? 'Comedy'
                                                      : index == 7
                                                          ? 'Sci-Fi'
                                                          : index == 8
                                                              ? 'Horror'
                                                              : index == 9
                                                                  ? 'Animation'
                                                                  : index == 10
                                                                      ? 'Adventure'
                                                                      : index ==
                                                                              11
                                                                          ? 'Fantasy'
                                                                          : '',
                        ));
                    print(index);
                  },
                ),
              ),
            );
          }),
    );
  }
}
