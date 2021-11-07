import 'dart:convert';
import 'package:cinephilia/model/details_model.dart';
import 'package:cinephilia/model/season_model.dart';
import 'package:cinephilia/model/tmdb.dart';
import 'package:cinephilia/model/tmdb_details.dart';
import 'package:cinephilia/model/yts_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' show Client, Response;

class ApiProvider {
  Client client = Client();

  Future<Response> _dataLoader({@required url}) async {
    Uri uri = Uri.parse(
      url,
    );
    print('is api working? $url');
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      return response;
    }
    throw Exception('Failed to load data: ${response.statusCode} , $response');
  }

  Future<Yts?> fetchYts(int pageNumber) async {
    try {
      Response response = await _dataLoader(
          url:
              'https://yts.mx/api/v2/list_movies.json?page=$pageNumber&sort_by=year');
      return Yts.fromJson(json.decode(response.body));
    } catch (e) {
      print('Error: $e');
      // return null;
    }
  }

  Future<Yts?> fetchPopularYts(int pageNumber) async {
    try {
      Response response = await _dataLoader(
          url:
              'https://yts.mx/api/v2/list_movies.json?page=$pageNumber&sort_by=like_count');
      return Yts.fromJson(json.decode(response.body));
    } catch (e) {
      print('Error: $e');
      // return null;
    }
  }

  Future<Yts?> fetchDownloadYts(int pageNumber) async {
    try {
      Response response = await _dataLoader(
          url:
              'https://yts.mx/api/v2/list_movies.json?page=$pageNumber&sort_by=download_count');
      return Yts.fromJson(json.decode(response.body));
    } catch (e) {
      print('Error: $e');
      // return null;
    }
  }

  Future<Yts?> fetchRecentYts(int pageNumber) async {
    try {
      Response response = await _dataLoader(
          url:
              'https://yts.mx/api/v2/list_movies.json?page=$pageNumber&sort_by=date_added');
      return Yts.fromJson(json.decode(response.body));
    } catch (e) {
      print('Error: $e');
      // return null;
    }
  }

  Future<Yts?> fetchYtsRated(int pageNumber) async {
    try {
      Response response = await _dataLoader(
          url:
              'https://yts.mx/api/v2/list_movies.json?page=$pageNumber&sort_by=rating');
      return Yts.fromJson(json.decode(response.body));
    } catch (e) {
      print('Error: $e');
      // return null;
    }
  }

  Future<Tmdb?> fetchTmdbRated(int pageNumber) async {
    try {
      Response response = await _dataLoader(
          url:
              'https://api.themoviedb.org/3/tv/top_rated?api_key=529bf848d14b9fc7da265edcae678a08&language=en-US&page=$pageNumber');
      return Tmdb.fromJson(json.decode(response.body));
    } catch (e) {
      print('Error: $e');
      // return null;
    }
  }

  Future<Tmdb?> fetchTmdbPopular(int pageNumber) async {
    try {
      Response response = await _dataLoader(
          url:
              'https://api.themoviedb.org/3/tv/popular?api_key=529bf848d14b9fc7da265edcae678a08&language=en-US&page=$pageNumber');
      return Tmdb.fromJson(json.decode(response.body));
    } catch (e) {
      print('Error: $e');
      // return null;
    }
  }

  Future<Tmdb?> fetchTmdbOnTheAir(int pageNumber) async {
    try {
      Response response = await _dataLoader(
          url:
              'https://api.themoviedb.org/3/trending/tv/week?api_key=529bf848d14b9fc7da265edcae678a08&page=$pageNumber');
      return Tmdb.fromJson(json.decode(response.body));
    } catch (e) {
      print('Error: $e');
      // return null;
    }
  }

  Future<Yts?> fetchYtsSearch(String searchText) async {
    // try {
    Response response = await _dataLoader(
        url:
            'https://yts.mx/api/v2/list_movies.json?query_term=$searchText&limit=50&sort_by=download_count');
    return Yts.fromJson(json.decode(response.body));
    // } catch (e) {
    //   print('Error: $e');
    //   // return null;
    // }
  }

  Future<Tmdb?> fetchTmdbTvSearch(String searchText) async {
    // try {
    Response response = await _dataLoader(
        url:
            'https://api.themoviedb.org/3/search/tv?api_key=529bf848d14b9fc7da265edcae678a08&language=en-US&page=1&query=$searchText&include_adult=true');
    return Tmdb.fromJson(json.decode(response.body));
    // } catch (e) {
    //   print('Error: $e');
    //   // return null;
    // }
  }

  Future<SeasonModel?> fetchSeason(String id, int s) async {
    print('api prpvider.');
    // try {
    Response response = await _dataLoader(
        url:
            'https://api.themoviedb.org/3/tv/$id/season/$s?api_key=529bf848d14b9fc7da265edcae678a08&language=en-US');

    return SeasonModel.fromJson(json.decode(response.body));
    // } catch (e) {
    //   print('Error: $e');
    //   // return null;
    // }
  }

  Future<Details?> fetchYtsDetails(String id) async {
    // try {
    Response response = await _dataLoader(
        url:
            'https://yts.mx/api/v2/movie_details.json?movie_id=$id&with_images=true&with_cast=true');
    return Details.fromJson(json.decode(response.body));
    // } catch (e) {
    //   print('Error: $e');
    //   // return null;
    // }
  }

  Future<TmdbDetails?> fetchTmdbDetails(String id) async {
    // try {
    Response response = await _dataLoader(
        url:
            'https://api.themoviedb.org/3/tv/$id?api_key=529bf848d14b9fc7da265edcae678a08&language=en-US');
    return TmdbDetails.fromJson(json.decode(response.body));
    // } catch (e) {
    //   print('Error: $e');
    //   // return null;
    // }
  }
}
