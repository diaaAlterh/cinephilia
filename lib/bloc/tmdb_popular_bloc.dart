import 'package:cinephilia/model/tmdb.dart';
import 'package:cinephilia/persistance/api_provider.dart';
import 'package:rxdart/rxdart.dart';

class TmdbPopularBloc {
  int pageNumber = 1;
  ApiProvider appApiProvider = ApiProvider();

  Future<Tmdb?> fetchTmdbPopular() => appApiProvider.fetchTmdbPopular(pageNumber);

  final _tmdbPopularBlocFetcher = BehaviorSubject<Tmdb>();

  Stream<Tmdb> get tmdbPopular => _tmdbPopularBlocFetcher.stream;

  fetch() async {
    try {
      Tmdb? tmdbPopular = await fetchTmdbPopular();
      _tmdbPopularBlocFetcher.sink.add(tmdbPopular!);
    } catch (e) {
      _tmdbPopularBlocFetcher.sink.addError(e);
    }
  }

  dispose() {
    _tmdbPopularBlocFetcher.close();
  }
}

final tmdbPopularBloc = TmdbPopularBloc();
