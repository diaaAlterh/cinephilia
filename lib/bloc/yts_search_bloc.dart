import 'package:cinephilia/model/yts_model.dart';
import 'package:cinephilia/persistance/api_provider.dart';
import 'package:rxdart/rxdart.dart';

class YtsSearchBloc {
  String searchText = '';
  ApiProvider appApiProvider = ApiProvider();

  Future<Yts?> fetchYtsSearch() => appApiProvider.fetchYtsSearch(searchText);

  final _ytsSearchBlocFetcher = BehaviorSubject<Yts>();

  Stream<Yts> get ytsSearch => _ytsSearchBlocFetcher.stream;

  fetch() async {
    try {
      Yts? ytsSearch = await fetchYtsSearch();
      _ytsSearchBlocFetcher.sink.add(ytsSearch!);
    } catch (e) {
      _ytsSearchBlocFetcher.sink.addError(e);
    }
  }

  dispose() {
    _ytsSearchBlocFetcher.close();
  }
}

final ytsSearchBloc = YtsSearchBloc();
