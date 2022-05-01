import 'package:cinephilia/model/yts_model.dart';
import 'package:cinephilia/persistance/api_provider.dart';
import 'package:rxdart/rxdart.dart';

class YtsBloc {
  int pageNumber = 1;
  ApiProvider appApiProvider = ApiProvider();

  Future<Yts?> fetchYts() => appApiProvider.fetchYts(pageNumber);

  final _ytsBlocFetcher = BehaviorSubject<Yts>();

  Stream<Yts> get yts => _ytsBlocFetcher.stream;

  fetch() async {
    try {
      Yts? yts = await fetchYts();
      _ytsBlocFetcher.sink.add(yts!);
    } catch (e) {
      _ytsBlocFetcher.sink.addError(e);
    }
  }

  dispose() {
    _ytsBlocFetcher.close();
  }
}

final ytsBloc = YtsBloc();
