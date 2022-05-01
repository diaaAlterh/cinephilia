import 'package:cinephilia/model/yts_model.dart';
import 'package:cinephilia/persistance/api_provider.dart';
import 'package:rxdart/rxdart.dart';

class YtsDownloadBloc {
  int pageNumber = 1;
  ApiProvider appApiProvider = ApiProvider();

  Future<Yts?> fetchDownloadYts() => appApiProvider.fetchDownloadYts(pageNumber);

  final _ytsDownloadBlocFetcher = BehaviorSubject<Yts>();

  Stream<Yts> get ytsDownload => _ytsDownloadBlocFetcher.stream;

  fetch() async {
    try {
      Yts? ytsDownload = await fetchDownloadYts();
      _ytsDownloadBlocFetcher.sink.add(ytsDownload!);
    } catch (e) {
      _ytsDownloadBlocFetcher.sink.addError(e);
    }
  }

  dispose() {
    _ytsDownloadBlocFetcher.close();
  }
}

final ytsDownloadBloc = YtsDownloadBloc();
