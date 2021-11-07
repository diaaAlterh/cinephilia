// To parse this JSON data, do
//
//     final season = seasonFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

SeasonModel seasonFromJson(String str) => SeasonModel.fromJson(json.decode(str));

String seasonToJson(SeasonModel data) => json.encode(data.toJson());

class SeasonModel {
  SeasonModel({
    required this.id,
    required this.airDate,
    required this.episodes,
    required this.name,
    required this.overview,
    required this.seasonId,
    required this.posterPath,
    required this.seasonNumber,
  });

  String id;
  String airDate;
  List<Episode> episodes;
  String name;
  String overview;
  int seasonId;
  String posterPath;
  int seasonNumber;

  factory SeasonModel.fromJson(Map<String, dynamic> json) => SeasonModel(
    id: json["_id"] == null ? '' : json["_id"],
    airDate: json["air_date"] == null ? '' : json["air_date"],
    episodes: json["episodes"] == null ? [] : List<Episode>.from(json["episodes"].map((x) => Episode.fromJson(x))),
    name: json["name"] == null ? '' : json["name"],
    overview: json["overview"] == null ? '' : json["overview"],
    seasonId: json["id"] == null ? '' : json["id"],
    posterPath: json["poster_path"] == null ? '' : json["poster_path"],
    seasonNumber: json["season_number"] == null ? 0 : json["season_number"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id == null ? null : id,
    "air_date": airDate == null ? '' : airDate,
    "episodes": episodes == null ? [] : List<dynamic>.from(episodes.map((x) => x.toJson())),
    "name": name == null ? '' : name,
    "overview": overview == null ? '' : overview,
    "id": seasonId == null ? '' : seasonId,
    "poster_path": posterPath == null ? '' : posterPath,
    "season_number": seasonNumber == null ? 0 : seasonNumber,
  };
}

class Episode {
  Episode({
    required this.airDate,
    required this.episodeNumber,
    required this.crew,
    required this.guestStars,
    required this.id,
    required this.name,
    required this.overview,
    required this.productionCode,
    required this.seasonNumber,
    required this.stillPath,
    required this.voteAverage,
    required this.voteCount,
  });

  String airDate;
  int episodeNumber;
  List<Crew> crew;
  List<GuestStar> guestStars;
  int id;
  String name;
  String overview;
  String productionCode;
  int seasonNumber;
  String stillPath;
  double voteAverage;
  int voteCount;

  factory Episode.fromJson(Map<String, dynamic> json) => Episode(
    airDate: json["air_date"] == null ? '' : json["air_date"],
    episodeNumber: json["episode_number"] == null ? 0 : json["episode_number"],
    crew: json["crew"] == null ? [] : List<Crew>.from(json["crew"].map((x) => Crew.fromJson(x))),
    guestStars: json["guest_stars"] == null ? [] : List<GuestStar>.from(json["guest_stars"].map((x) => GuestStar.fromJson(x))),
    id: json["id"] == null ? '' : json["id"],
    name: json["name"] == null ? '' : json["name"],
    overview: json["overview"] == null ? '' : json["overview"],
    productionCode: json["production_code"] == null ? '' : json["production_code"],
    seasonNumber: json["season_number"] == null ? 0 : json["season_number"],
    stillPath: json["still_path"] == null ? '' : json["still_path"],
    voteAverage: json["vote_average"] == null ? 0 : json["vote_average"].toDouble(),
    voteCount: json["vote_count"] == null ? 0 : json["vote_count"],
  );

  Map<String, dynamic> toJson() => {
    "air_date": airDate == null ? '' : airDate,
    "episode_number": episodeNumber == null ? 0 : episodeNumber,
    "crew": crew == null ? [] : List<dynamic>.from(crew.map((x) => x.toJson())),
    "guest_stars": guestStars == null ? [] : List<dynamic>.from(guestStars.map((x) => x.toJson())),
    "id": id == null ? '' : id,
    "name": name == null ? '' : name,
    "overview": overview == null ? '' : overview,
    "production_code": productionCode == null ? '' : productionCode,
    "season_number": seasonNumber == null ? 0 : seasonNumber,
    "still_path": stillPath == null ? '' : stillPath,
    "vote_average": voteAverage == null ? 0 : voteAverage,
    "vote_count": voteCount == null ? 0 : voteCount,
  };
}

class Crew {
  Crew({
    required this.department,
    required this.job,
    required this.creditId,
    required this.adult,
    required this.gender,
    required this.id,
    required this.knownForDepartment,
    required this.name,
    required this.originalName,
    required this.popularity,
    required this.profilePath,
  });

  String department;
  String job;
  String creditId;
  bool adult;
  int gender;
  int id;
  String knownForDepartment;
  String name;
  String originalName;
  double popularity;
  String profilePath;

  factory Crew.fromJson(Map<String, dynamic> json) => Crew(
    department: json["department"] == null ? '' : json["department"],
    job: json["job"] == null ? '' : json["job"],
    creditId: json["credit_id"] == null ? '' : json["credit_id"],
    adult: json["adult"] == null ? '' : json["adult"],
    gender: json["gender"] == null ? '' : json["gender"],
    id: json["id"] == null ? '' : json["id"],
    knownForDepartment: json["known_for_department"] == null ? '' : json["known_for_department"],
    name: json["name"] == null ? '' : json["name"],
    originalName: json["original_name"] == null ? '' : json["original_name"],
    popularity: json["popularity"] == null ? '' : json["popularity"].toDouble(),
    profilePath: json["profile_path"] == null ? '' : json["profile_path"],
  );

  Map<String, dynamic> toJson() => {
    "department": department == null ? null : department,
    "job": job == null ? null : job,
    "credit_id": creditId == null ? null : creditId,
    "adult": adult == null ? null : adult,
    "gender": gender == null ? null : gender,
    "id": id == null ? null : id,
    "known_for_department": knownForDepartment == null ? null : knownForDepartment,
    "name": name == null ? null : name,
    "original_name": originalName == null ? null : originalName,
    "popularity": popularity == null ? null : popularity,
    "profile_path": profilePath == null ? null : profilePath,
  };
}

class GuestStar {
  GuestStar({
    required this.character,
    required this.creditId,
    required this.order,
    required this.adult,
    required this.gender,
    required this.id,
    required this.knownForDepartment,
    required this.name,
    required this.originalName,
    required this.popularity,
    required this.profilePath,
  });

  String character;
  String creditId;
  int order;
  bool adult;
  int gender;
  int id;
  String knownForDepartment;
  String name;
  String originalName;
  double popularity;
  String profilePath;

  factory GuestStar.fromJson(Map<String, dynamic> json) => GuestStar(
    character: json["character"] == null ? '' : json["character"],
    creditId: json["credit_id"] == null ? '' : json["credit_id"],
    order: json["order"] == null ? '' : json["order"],
    adult: json["adult"] == null ? '' : json["adult"],
    gender: json["gender"] == null ? '' : json["gender"],
    id: json["id"] == null ? '' : json["id"],
    knownForDepartment: json["known_for_department"] == null ? '' : json["known_for_department"],
    name: json["name"] == null ? '' : json["name"],
    originalName: json["original_name"] == null ? '' : json["original_name"],
    popularity: json["popularity"] == null ? '' : json["popularity"].toDouble(),
    profilePath: json["profile_path"] == null ? '' : json["profile_path"],
  );

  Map<String, dynamic> toJson() => {
    "character": character == null ? null : character,
    "credit_id": creditId == null ? null : creditId,
    "order": order == null ? null : order,
    "adult": adult == null ? null : adult,
    "gender": gender == null ? null : gender,
    "id": id == null ? null : id,
    "known_for_department": knownForDepartment == null ? null : knownForDepartment,
    "name": name == null ? null : name,
    "original_name": originalName == null ? null : originalName,
    "popularity": popularity == null ? null : popularity,
    "profile_path": profilePath == null ? null : profilePath,
  };
}
