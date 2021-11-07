// ignore: file_names
// ignore_for_file: file_names

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
      print(ytsSearch.data);
      print('success ');

    } catch (e) {
      _ytsSearchBlocFetcher.sink.addError(e);
      // ignore: avoid_print
      print('error $e');
    }
  }

  dispose() {
    _ytsSearchBlocFetcher.close();
  }
}

final ytsSearchBloc = YtsSearchBloc();
