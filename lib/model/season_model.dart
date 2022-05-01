import 'dart:convert';

SeasonModel seasonFromJson(String str) =>
    SeasonModel.fromJson(json.decode(str));

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
        episodes: json["episodes"] == null
            ? []
            : List<Episode>.from(
                json["episodes"].map((x) => Episode.fromJson(x))),
        name: json["name"] == null ? '' : json["name"],
        overview: json["overview"] == null ? '' : json["overview"],
        seasonId: json["id"] == null ? '' : json["id"],
        posterPath: json["poster_path"] == null ? '' : json["poster_path"],
        seasonNumber: json["season_number"] == null ? 0 : json["season_number"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "air_date": airDate,
        "episodes": List<dynamic>.from(episodes.map((x) => x.toJson())),
        "name": name,
        "overview": overview,
        "id": seasonId,
        "poster_path": posterPath,
        "season_number": seasonNumber,
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
        episodeNumber:
            json["episode_number"] == null ? 0 : json["episode_number"],
        crew: json["crew"] == null
            ? []
            : List<Crew>.from(json["crew"].map((x) => Crew.fromJson(x))),
        guestStars: json["guest_stars"] == null
            ? []
            : List<GuestStar>.from(
                json["guest_stars"].map((x) => GuestStar.fromJson(x))),
        id: json["id"] == null ? '' : json["id"],
        name: json["name"] == null ? '' : json["name"],
        overview: json["overview"] == null ? '' : json["overview"],
        productionCode:
            json["production_code"] == null ? '' : json["production_code"],
        seasonNumber: json["season_number"] == null ? 0 : json["season_number"],
        stillPath: json["still_path"] == null ? '' : json["still_path"],
        voteAverage:
            json["vote_average"] == null ? 0 : json["vote_average"].toDouble(),
        voteCount: json["vote_count"] == null ? 0 : json["vote_count"],
      );

  Map<String, dynamic> toJson() => {
        "air_date": airDate,
        "episode_number": episodeNumber,
        "crew": List<dynamic>.from(crew.map((x) => x.toJson())),
        "guest_stars": List<dynamic>.from(guestStars.map((x) => x.toJson())),
        "id": id,
        "name": name,
        "overview": overview,
        "production_code": productionCode,
        "season_number": seasonNumber,
        "still_path": stillPath,
        "vote_average": voteAverage,
        "vote_count": voteCount,
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
        knownForDepartment: json["known_for_department"] == null
            ? ''
            : json["known_for_department"],
        name: json["name"] == null ? '' : json["name"],
        originalName:
            json["original_name"] == null ? '' : json["original_name"],
        popularity:
            json["popularity"] == null ? '' : json["popularity"].toDouble(),
        profilePath: json["profile_path"] == null ? '' : json["profile_path"],
      );

  Map<String, dynamic> toJson() => {
        "department": department,
        "job": job,
        "credit_id": creditId,
        "adult": adult,
        "gender": gender,
        "id": id,
        "known_for_department": knownForDepartment,
        "name": name,
        "original_name": originalName,
        "popularity": popularity,
        "profile_path": profilePath,
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
        knownForDepartment: json["known_for_department"] == null
            ? ''
            : json["known_for_department"],
        name: json["name"] == null ? '' : json["name"],
        originalName:
            json["original_name"] == null ? '' : json["original_name"],
        popularity:
            json["popularity"] == null ? '' : json["popularity"].toDouble(),
        profilePath: json["profile_path"] == null ? '' : json["profile_path"],
      );

  Map<String, dynamic> toJson() => {
        "character": character,
        "credit_id": creditId,
        "order": order,
        "adult": adult,
        "gender": gender,
        "id": id,
        "known_for_department": knownForDepartment,
        "name": name,
        "original_name": originalName,
        "popularity": popularity,
        "profile_path": profilePath,
      };
}
