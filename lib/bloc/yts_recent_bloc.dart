import 'package:cinephilia/model/yts_model.dart';
import 'package:cinephilia/persistance/api_provider.dart';
import 'package:rxdart/rxdart.dart';

class YtsRecentBloc {
  int pageNumber = 1;
  ApiProvider appApiProvider = ApiProvider();

  Future<Yts?> fetchRecentYts() => appApiProvider.fetchRecentYts(pageNumber);

  final _ytsRecentBlocFetcher = BehaviorSubject<Yts>();

  Stream<Yts> get ytsRecent => _ytsRecentBlocFetcher.stream;

  fetch() async {
    try {
      Yts? ytsRecent = await fetchRecentYts();
      _ytsRecentBlocFetcher.sink.add(ytsRecent!);
    } catch (e) {
      _ytsRecentBlocFetcher.sink.addError(e);
    }
  }

  dispose() {
    _ytsRecentBlocFetcher.close();
  }
}

final ytsRecentBloc = YtsRecentBloc();
