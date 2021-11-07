// ignore: file_names
// ignore_for_file: file_names

import 'package:cinephilia/model/tmdb.dart';
import 'package:cinephilia/persistance/api_provider.dart';
import 'package:rxdart/rxdart.dart';

class TmdbRatedBloc {
  int pageNumber = 1;
  ApiProvider appApiProvider = ApiProvider();

  Future<Tmdb?> fetchTmdbRated() => appApiProvider.fetchTmdbRated(pageNumber);

  final _tmdbRatedBlocFetcher = BehaviorSubject<Tmdb>();

  Stream<Tmdb> get tmdbRated => _tmdbRatedBlocFetcher.stream;

  fetch() async {
    // try {
      Tmdb? tmdbRated = await fetchTmdbRated();
      _tmdbRatedBlocFetcher.sink.add(tmdbRated!);
    // } catch (e) {
    //   // ignore: avoid_print
    //   _tmdbRatedBlocFetcher.sink.addError(e);
    //   print('hhhhhhhhhhhhhhhhhh $e');
    // }
  }

  dispose() {
    _tmdbRatedBlocFetcher.close();
  }
}

final tmdbRatedBloc = TmdbRatedBloc();
