// ignore: file_names
// ignore_for_file: file_names

import 'package:cinephilia/model/yts_model.dart';
import 'package:cinephilia/persistance/api_provider.dart';
import 'package:rxdart/rxdart.dart';

class GenresBloc {
  int pageNumber = 1;
  String genre = '';
  ApiProvider appApiProvider = ApiProvider();

  Future<Yts?> fetchGenres() => appApiProvider.fetchGenres(pageNumber, genre);

  final _genresBlocFetcher = PublishSubject<Yts>();

  Stream<Yts> get genres => _genresBlocFetcher.stream;

  fetch() async {
    // try {
    Yts? yts = await fetchGenres();
    _genresBlocFetcher.sink.add(yts!);
    // } catch (e) {
    //   // ignore: avoid_print
    //   _genresBlocFetcher.sink.addError(e);
    //   print('hhhhhhhhhhhhhhhhhh $e');
    // }
  }

  dispose() {
    _genresBlocFetcher.close();
  }
}

final genresBloc = GenresBloc();
