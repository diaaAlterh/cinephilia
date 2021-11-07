// ignore: file_names
// ignore_for_file: file_names

import 'package:cinephilia/model/convert_id_model.dart';
import 'package:cinephilia/persistance/api_provider.dart';
import 'package:rxdart/rxdart.dart';

class ConvertIdBloc {
  String id='60574';
  ApiProvider appApiProvider = ApiProvider();

  Future<ConvertId?> fetchConvertId() => appApiProvider.fetchConvertId(id);

  final _convertIdBlocFetcher = PublishSubject<ConvertId>();

  Stream<ConvertId> get convertId => _convertIdBlocFetcher.stream;

  fetch() async {
    try {
      ConvertId? convertId = await fetchConvertId();
      _convertIdBlocFetcher.sink.add(convertId!);
    } catch (e) {
      // ignore: avoid_print
      _convertIdBlocFetcher.sink.addError(e);
      print('hhhhhhhhhhhhhhhhhh $e');
    }
  }

  dispose() {
    _convertIdBlocFetcher.close();
  }
}

final convertIdBloc = ConvertIdBloc();
