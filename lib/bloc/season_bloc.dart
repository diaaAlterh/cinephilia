// ignore: file_names
// ignore_for_file: file_names
import 'package:cinephilia/model/season_model.dart';
import 'package:cinephilia/persistance/api_provider.dart';
import 'package:rxdart/rxdart.dart';

class SeasonBloc {
  String id = '';
  int s=0;
  ApiProvider appApiProvider = ApiProvider();

  Future<SeasonModel?> fetchSeason() => appApiProvider.fetchSeason(id,s);

  final _seasonBlocFetcher = PublishSubject<SeasonModel>();

  Stream<SeasonModel> get season => _seasonBlocFetcher.stream;

  fetch() async {
    try {
      SeasonModel? seasonModel = await fetchSeason();
      print('_seasonBlocFetcher: start');
      _seasonBlocFetcher.sink.add(seasonModel!);
      print('_seasonBlocFetcher: done');
    } catch (e) {
      // ignore: avoid_print
      _seasonBlocFetcher.sink.addError(e);
      print('_seasonBlocFetcher: error');

      print('hhhhhhhhhhhhhhhhhh $e');
    }
  }

  dispose() {
    _seasonBlocFetcher.close();
  }
}

final seasonBloc = SeasonBloc();
