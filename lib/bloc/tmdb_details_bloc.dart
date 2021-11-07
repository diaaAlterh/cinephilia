// ignore: file_names
// ignore_for_file: file_names

import 'package:cinephilia/model/details_model.dart';
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
      // ignore: avoid_print
      _detailsBlocFetcher.sink.addError(e);
      print('hhhhhhhhhhhhhhhhhh $e');
    }
  }

  dispose() {
    _detailsBlocFetcher.close();
  }
}

final tmdbDetailsBloc = TmdbDetailsBloc();
