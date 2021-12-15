import 'dart:convert';
import 'package:cinephilia/model/convert_id_model.dart';
import 'package:cinephilia/model/details_model.dart';
import 'package:cinephilia/model/season_model.dart';
import 'package:cinephilia/model/tmdb.dart';
import 'package:cinephilia/model/tmdb_details.dart';
import 'package:cinephilia/model/yts_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' show Client, Response;

class ApiProvider {
  Client client = Client();

  ///this method for all Apis
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

  ///APIs are here ///every Api have a bloc /// Diaa Alterh +963991967155 / alterhdiaa@gmail.com

  ///get yts movies by year
  Future<Yts?> fetchYts(int pageNumber) async {
    try {
      Response response = await _dataLoader(
          url:
              'https://yts.mx/api/v2/list_movies.json?page=$pageNumber&sort_by=year&limit=50');
      return Yts.fromJson(json.decode(response.body));
    } catch (e) {
      print('Error: $e');
      // return null;
    }
  }

  ///get yts movies by year
  Future<Yts?> fetchGenres(int pageNumber,String genre) async {
    try {
      Response response = await _dataLoader(
          url:
              'https://yts.mx/api/v2/list_movies.json?genre=$genre&limit=50&sort_by=like_count&page=$pageNumber');
      return Yts.fromJson(json.decode(response.body));
    } catch (e) {
      print('Error: $e');
      // return null;
    }
  }

  ///get popular yts movies
  Future<Yts?> fetchPopularYts(int pageNumber) async {
    try {
      Response response = await _dataLoader(
          url:
              'https://yts.mx/api/v2/list_movies.json?page=$pageNumber&sort_by=like_count&limit=50');
      return Yts.fromJson(json.decode(response.body));
    } catch (e) {
      print('Error: $e');
      // return null;
    }
  }

  ///get most downloaded yts movies
  Future<Yts?> fetchDownloadYts(int pageNumber) async {
    try {
      Response response = await _dataLoader(
          url:
              'https://yts.mx/api/v2/list_movies.json?page=$pageNumber&sort_by=download_count&limit=50');
      return Yts.fromJson(json.decode(response.body));
    } catch (e) {
      print('Error: $e');
      // return null;
    }
  }

  ///get most downloaded yts movies
  Future<Yts?> fetchRecentYts(int pageNumber) async {
    try {
      Response response = await _dataLoader(
          url:
              'https://yts.mx/api/v2/list_movies.json?page=$pageNumber&sort_by=date_added&limit=50');
      return Yts.fromJson(json.decode(response.body));
    } catch (e) {
      print('Error: $e');
      // return null;
    }
  }

  ///get top rated yts movies
  Future<Yts?> fetchYtsRated(int pageNumber) async {
    try {
      Response response = await _dataLoader(
          url:
              'https://yts.mx/api/v2/list_movies.json?page=$pageNumber&sort_by=rating&limit=50');
      return Yts.fromJson(json.decode(response.body));
    } catch (e) {
      print('Error: $e');
      // return null;
    }
  }

  ///get top rated yts movies
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

  ///get most popular tmdb tv shows
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

  ///get on the air tmdb tv shows
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

  /// search movies yts
  Future<Yts?> fetchYtsSearch(String searchText) async {
    try {
      Response response = await _dataLoader(
          url:
              'https://yts.mx/api/v2/list_movies.json?query_term=$searchText&limit=50&sort_by=download_count');
      return Yts.fromJson(json.decode(response.body));
    } catch (e) {
      print('Error: $e');
    }
  }

  /// search tv shows tmdb
  Future<Tmdb?> fetchTmdbTvSearch(String searchText) async {
    try {
      Response response = await _dataLoader(
          url:
              'https://api.themoviedb.org/3/search/tv?api_key=529bf848d14b9fc7da265edcae678a08&language=en-US&page=1&query=$searchText&include_adult=true');
      return Tmdb.fromJson(json.decode(response.body));
    } catch (e) {
      print('Error: $e');
    }
  }

  ///get tv show  single season details tmdb
  Future<SeasonModel?> fetchSeason(String id, int s) async {
    try {
      Response response = await _dataLoader(
          url:
              'https://api.themoviedb.org/3/tv/$id/season/$s?api_key=529bf848d14b9fc7da265edcae678a08&language=en-US');

      return SeasonModel.fromJson(json.decode(response.body));
    } catch (e) {
      print('Error: $e');
    }
  }

  ///get movie details from yts
  Future<Details?> fetchYtsDetails(String id) async {
    try {
      Response response = await _dataLoader(
          url:
              'https://yts.mx/api/v2/movie_details.json?movie_id=$id&with_images=true&with_cast=true');
      return Details.fromJson(json.decode(response.body));
    } catch (e) {
      print('Error: $e');
    }
  }

  ///get tv show details from tmdb
  Future<TmdbDetails?> fetchTmdbDetails(String id) async {
    try {
      Response response = await _dataLoader(
          url:
              'https://api.themoviedb.org/3/tv/$id?api_key=529bf848d14b9fc7da265edcae678a08&language=en-US');
      return TmdbDetails.fromJson(json.decode(response.body));
    } catch (e) {
      print('Error: $e');
    }
  }

  ///get imdb id from tmdb id
  Future<ConvertId?> fetchConvertId(String id) async {
    try {
      Response response = await _dataLoader(
          url:
              'https://api.themoviedb.org/3/tv/$id/external_ids?api_key=529bf848d14b9fc7da265edcae678a08&language=en-US');
      return ConvertId.fromJson(json.decode(response.body));
    } catch (e) {
      print('Error: $e');
    }
  }
}
