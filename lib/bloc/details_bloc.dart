import 'package:cinephilia/model/details_model.dart';
import 'package:cinephilia/persistance/api_provider.dart';
import 'package:rxdart/rxdart.dart';

class DetailsBloc {
  String id = '';
  ApiProvider appApiProvider = ApiProvider();

  Future<Details?> fetchDetails() => appApiProvider.fetchYtsDetails(id);

  final _detailsBlocFetcher = PublishSubject<Details>();

  Stream<Details> get details => _detailsBlocFetcher.stream;

  fetch() async {
    try {
      Details? details = await fetchDetails();
      _detailsBlocFetcher.sink.add(details!);
    } catch (e) {
      // ignore: avoid_print
      _detailsBlocFetcher.sink.addError(e);
    }
  }

  dispose() {
    _detailsBlocFetcher.close();
  }
}

final detailsBloc = DetailsBloc();
