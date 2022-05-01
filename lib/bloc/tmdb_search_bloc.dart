import 'package:cinephilia/model/tmdb.dart';
import 'package:cinephilia/persistance/api_provider.dart';
import 'package:rxdart/rxdart.dart';

class TmdbSearchBloc {
  String searchText = '';
  ApiProvider appApiProvider = ApiProvider();

  Future<Tmdb?> fetchTmdbSearch() =>
      appApiProvider.fetchTmdbTvSearch(searchText);

  final _tmdbSearchBlocFetcher = BehaviorSubject<Tmdb>();

  Stream<Tmdb> get tmdbSearch => _tmdbSearchBlocFetcher.stream;

  fetch() async {
    try {
      Tmdb? tmdbSearch = await fetchTmdbSearch();
      _tmdbSearchBlocFetcher.sink.add(tmdbSearch!);
    } catch (e) {
      _tmdbSearchBlocFetcher.sink.addError(e);
    }
  }

  dispose() {
    _tmdbSearchBlocFetcher.close();
  }
}

final tmdbSearchBloc = TmdbSearchBloc();
