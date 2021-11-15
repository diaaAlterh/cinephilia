// ignore: file_names
// ignore_for_file: file_names

import 'package:cinephilia/model/tmdb.dart';
import 'package:cinephilia/persistance/api_provider.dart';
import 'package:rxdart/rxdart.dart';

class TmdbOnTheAirBloc {
  int pageNumber = 1;
  ApiProvider appApiProvider = ApiProvider();

  Future<Tmdb?> fetchTmdbOnTheAir() => appApiProvider.fetchTmdbOnTheAir(pageNumber);

  final _tmdbOnTheAirBlocFetcher = BehaviorSubject<Tmdb>();

  Stream<Tmdb> get tmdbOnTheAir => _tmdbOnTheAirBlocFetcher.stream;

  fetch() async {
    try {
      Tmdb? tmdbOnTheAir = await fetchTmdbOnTheAir();
      _tmdbOnTheAirBlocFetcher.sink.add(tmdbOnTheAir!);
    } catch (e) {
      // ignore: avoid_print
      _tmdbOnTheAirBlocFetcher.sink.addError(e);
      print('hhhhhhhhhhhhhhhhhh $e');
    }
  }

  dispose() {
    _tmdbOnTheAirBlocFetcher.close();
  }
}

final tmdbOnTheAirBloc = TmdbOnTheAirBloc();
