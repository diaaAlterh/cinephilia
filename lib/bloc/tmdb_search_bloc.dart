// ignore: file_names
// ignore_for_file: file_names

import 'package:cinephilia/model/tmdb.dart';
import 'package:cinephilia/model/yts_model.dart';
import 'package:cinephilia/persistance/api_provider.dart';
import 'package:rxdart/rxdart.dart';

class TmdbSearchBloc {
  String searchText = '';
  ApiProvider appApiProvider = ApiProvider();

  Future<Tmdb?> fetchTmdbSearch() => appApiProvider.fetchTmdbTvSearch(searchText);

  final _tmdbSearchBlocFetcher = BehaviorSubject<Tmdb>();

  Stream<Tmdb> get tmdbSearch => _tmdbSearchBlocFetcher.stream;

  fetch() async {
    // try {
      Tmdb? tmdbSearch = await fetchTmdbSearch();
      _tmdbSearchBlocFetcher.sink.add(tmdbSearch!);
      print('success ');

    // } catch (e) {
    //   _tmdbSearchBlocFetcher.sink.addError(e);
    //   // ignore: avoid_print
    //   print('error $e');
    // }
  }

  dispose() {
    _tmdbSearchBlocFetcher.close();
  }
}

final tmdbSearchBloc = TmdbSearchBloc();
