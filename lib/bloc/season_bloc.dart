import 'package:cinephilia/model/season_model.dart';
import 'package:cinephilia/persistance/api_provider.dart';
import 'package:rxdart/rxdart.dart';

class SeasonBloc {
  String id = '';
  int s = 0;
  ApiProvider appApiProvider = ApiProvider();

  Future<SeasonModel?> fetchSeason() => appApiProvider.fetchSeason(id, s);

  final _seasonBlocFetcher = PublishSubject<SeasonModel>();

  Stream<SeasonModel> get season => _seasonBlocFetcher.stream;

  fetch() async {
    try {
      SeasonModel? seasonModel = await fetchSeason();
      _seasonBlocFetcher.sink.add(seasonModel!);
    } catch (e) {
      _seasonBlocFetcher.sink.addError(e);
    }
  }

  dispose() {
    _seasonBlocFetcher.close();
  }
}

final seasonBloc = SeasonBloc();
