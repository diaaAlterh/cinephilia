// ignore: file_names
// ignore_for_file: file_names

import 'package:cinephilia/model/yts_model.dart';
import 'package:cinephilia/persistance/api_provider.dart';
import 'package:rxdart/rxdart.dart';

class YtsRatedBloc {
  int pageNumber = 1;
  ApiProvider appApiProvider = ApiProvider();

  Future<Yts?> fetchYtsRated() => appApiProvider.fetchYtsRated(pageNumber);

  final _ytsRatedBlocFetcher = BehaviorSubject<Yts>();

  Stream<Yts> get ytsRated => _ytsRatedBlocFetcher.stream;

  fetch() async {
    try {
      Yts? yts = await fetchYtsRated();
      _ytsRatedBlocFetcher.sink.add(yts!);
    } catch (e) {
      // ignore: avoid_print
      _ytsRatedBlocFetcher.sink.addError(e);
      print('hhhhhhhhhhhhhhhhhh $e');
    }
  }

  dispose() {
    _ytsRatedBlocFetcher.close();
  }
}

final ytsRatedBloc = YtsRatedBloc();
