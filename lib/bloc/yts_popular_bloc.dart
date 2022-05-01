import 'package:cinephilia/model/yts_model.dart';
import 'package:cinephilia/persistance/api_provider.dart';
import 'package:rxdart/rxdart.dart';

class YtsPopularBloc {
  int pageNumber = 1;
  ApiProvider appApiProvider = ApiProvider();

  Future<Yts?> fetchPopularYts() => appApiProvider.fetchPopularYts(pageNumber);

  final _ytsPopularBlocFetcher = BehaviorSubject<Yts>();

  Stream<Yts> get ytsPopular => _ytsPopularBlocFetcher.stream;

  fetch() async {
    try {
      Yts? ytsPopular = await fetchPopularYts();
      _ytsPopularBlocFetcher.sink.add(ytsPopular!);
    } catch (e) {
      _ytsPopularBlocFetcher.sink.addError(e);
    }
  }

  dispose() {
    _ytsPopularBlocFetcher.close();
  }
}

final ytsPopularBloc = YtsPopularBloc();
