import 'package:cinephilia/model/tmdb_details.dart';
import 'package:cinephilia/persistance/api_provider.dart';
import 'package:rxdart/rxdart.dart';

class TmdbDetailsBloc {
  String id = '';
  ApiProvider appApiProvider = ApiProvider();

  Future<TmdbDetails?> fetchTmdbDetails() => appApiProvider.fetchTmdbDetails(id);

  final _detailsBlocFetcher = PublishSubject<TmdbDetails>();

  Stream<TmdbDetails> get tmdbDetails => _detailsBlocFetcher.stream;

  fetch() async {
    try {
      TmdbDetails? tmdbDetails = await fetchTmdbDetails();
      _detailsBlocFetcher.sink.add(tmdbDetails!);
    } catch (e) {
      _detailsBlocFetcher.sink.addError(e);
    }
  }

  dispose() {
    _detailsBlocFetcher.close();
  }
}

final tmdbDetailsBloc = TmdbDetailsBloc();
