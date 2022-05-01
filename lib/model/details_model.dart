import 'dart:convert';

Details detailsFromJson(String str) => Details.fromJson(json.decode(str));

String detailsToJson(Details data) => json.encode(data.toJson());

class Details {
  Details({
    required this.status,
    required this.statusMessage,
    required this.data,
    required this.meta,
  });

  String status;
  String statusMessage;
  Data data;
  Meta meta;

  factory Details.fromJson(Map<String, dynamic> json) => Details(
    status: json["status"],
    statusMessage: json["status_message"],
    data: Data.fromJson(json["data"]),
    meta: Meta.fromJson(json["@meta"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "status_message": statusMessage,
    "data": data.toJson(),
    "@meta": meta.toJson(),
  };
}

class Data {
  Data({
    required this.movie,
  });

  Movie movie;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    movie: Movie.fromJson(json["movie"]),
  );

  Map<String, dynamic> toJson() => {
    "movie": movie.toJson(),
  };
}

class Movie {
  Movie({
    required this.id,
    required this.url,
    required this.imdbCode,
    required this.title,
    required this.titleEnglish,
    required this.titleLong,
    required this.slug,
    required this.year,
    required this.rating,
    required this.runtime,
    required this.genres,
    required this.downloadCount,
    required this.likeCount,
    required this.descriptionIntro,
    required this.descriptionFull,
    required this.ytTrailerCode,
    required this.language,
    required this.mpaRating,
    required this.backgroundImage,
    required this.backgroundImageOriginal,
    required this.smallCoverImage,
    required this.mediumCoverImage,
    required this.largeCoverImage,
    required this.mediumScreenshotImage1,
    required this.mediumScreenshotImage2,
    required this.mediumScreenshotImage3,
    required this.largeScreenshotImage1,
    required this.largeScreenshotImage2,
    required this.largeScreenshotImage3,
    required this.cast,
    required this.torrents,
    required this.dateUploaded,
    required this.dateUploadedUnix,
  });

  int id;
  String url;
  String imdbCode;
  String title;
  String titleEnglish;
  String titleLong;
  String slug;
  int year;
  double rating;
  int runtime;
  List<String> genres;
  int downloadCount;
  int likeCount;
  String descriptionIntro;
  String descriptionFull;
  String ytTrailerCode;
  String language;
  String mpaRating;
  String backgroundImage;
  String backgroundImageOriginal;
  String smallCoverImage;
  String mediumCoverImage;
  String largeCoverImage;
  String mediumScreenshotImage1;
  String mediumScreenshotImage2;
  String mediumScreenshotImage3;
  String largeScreenshotImage1;
  String largeScreenshotImage2;
  String largeScreenshotImage3;
  List<Cast> cast;
  List<Torrent> torrents;
  DateTime dateUploaded;
  int dateUploadedUnix;

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
    id: json["id"],
    url: json["url"],
    imdbCode: json["imdb_code"],
    title: json["title"],
    titleEnglish: json["title_english"],
    titleLong: json["title_long"],
    slug: json["slug"],
    year: json["year"],
    rating: json["rating"].toDouble(),
    runtime: json["runtime"],
    genres: List<String>.from(json["genres"].map((x) => x)),
    downloadCount: json["download_count"],
    likeCount: json["like_count"],
    descriptionIntro: json["description_intro"],
    descriptionFull: json["description_full"],
    ytTrailerCode: json["yt_trailer_code"],
    language: json["language"],
    mpaRating: json["mpa_rating"],
    backgroundImage: json["background_image"],
    backgroundImageOriginal: json["background_image_original"],
    smallCoverImage: json["small_cover_image"],
    mediumCoverImage: json["medium_cover_image"],
    largeCoverImage: json["large_cover_image"],
    mediumScreenshotImage1: json["medium_screenshot_image1"],
    mediumScreenshotImage2: json["medium_screenshot_image2"],
    mediumScreenshotImage3: json["medium_screenshot_image3"],
    largeScreenshotImage1: json["large_screenshot_image1"],
    largeScreenshotImage2: json["large_screenshot_image2"],
    largeScreenshotImage3: json["large_screenshot_image3"],
    cast: json["cast"]==null?[]:List<Cast>.from(json["cast"].map((x) => Cast.fromJson(x))),
    torrents: List<Torrent>.from(json["torrents"].map((x) => Torrent.fromJson(x))),
    dateUploaded: DateTime.parse(json["date_uploaded"]),
    dateUploadedUnix: json["date_uploaded_unix"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "url": url,
    "imdb_code": imdbCode,
    "title": title,
    "title_english": titleEnglish,
    "title_long": titleLong,
    "slug": slug,
    "year": year,
    "rating": rating,
    "runtime": runtime,
    "genres": List<dynamic>.from(genres.map((x) => x)),
    "download_count": downloadCount,
    "like_count": likeCount,
    "description_intro": descriptionIntro,
    "description_full": descriptionFull,
    "yt_trailer_code": ytTrailerCode,
    "language": language,
    "mpa_rating": mpaRating,
    "background_image": backgroundImage,
    "background_image_original": backgroundImageOriginal,
    "small_cover_image": smallCoverImage,
    "medium_cover_image": mediumCoverImage,
    "large_cover_image": largeCoverImage,
    "medium_screenshot_image1": mediumScreenshotImage1,
    "medium_screenshot_image2": mediumScreenshotImage2,
    "medium_screenshot_image3": mediumScreenshotImage3,
    "large_screenshot_image1": largeScreenshotImage1,
    "large_screenshot_image2": largeScreenshotImage2,
    "large_screenshot_image3": largeScreenshotImage3,
    "cast": List<dynamic>.from(cast.map((x) => x.toJson())),
    "torrents": List<dynamic>.from(torrents.map((x) => x.toJson())),
    "date_uploaded": dateUploaded.toIso8601String(),
    "date_uploaded_unix": dateUploadedUnix,
  };
}

class Cast {
  Cast({
    required this.name,
    required this.characterName,
    required this.urlSmallImage,
    required this.imdbCode,
  });

  String name;
  String characterName;
  String urlSmallImage;
  String imdbCode;

  factory Cast.fromJson(Map<String, dynamic> json) => Cast(
    name: json["name"],
    characterName: json["character_name"],
    urlSmallImage: json["url_small_image"]??'',
    imdbCode: json["imdb_code"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "character_name": characterName,
    "url_small_image": urlSmallImage,
    "imdb_code": imdbCode,
  };
}

class Torrent {
  Torrent({
    required this.url,
    required this.hash,
    required this.quality,
    required this.type,
    required this.seeds,
    required this.peers,
    required this.size,
    required this.sizeBytes,
    required this.dateUploaded,
    required this.dateUploadedUnix,
  });

  String url;
  String hash;
  String quality;
  String type;
  int seeds;
  int peers;
  String size;
  int sizeBytes;
  DateTime dateUploaded;
  int dateUploadedUnix;

  factory Torrent.fromJson(Map<String, dynamic> json) => Torrent(
    url: json["url"],
    hash: json["hash"],
    quality: json["quality"],
    type: json["type"],
    seeds: json["seeds"],
    peers: json["peers"],
    size: json["size"],
    sizeBytes: json["size_bytes"],
    dateUploaded: DateTime.parse(json["date_uploaded"]),
    dateUploadedUnix: json["date_uploaded_unix"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "hash": hash,
    "quality": quality,
    "type": type,
    "seeds": seeds,
    "peers": peers,
    "size": size,
    "size_bytes": sizeBytes,
    "date_uploaded": dateUploaded.toIso8601String(),
    "date_uploaded_unix": dateUploadedUnix,
  };
}

class Meta {
  Meta({
    required this.serverTime,
    required this.serverTimezone,
    required this.apiVersion,
    required this.executionTime,
  });

  int serverTime;
  String serverTimezone;
  int apiVersion;
  String executionTime;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    serverTime: json["server_time"],
    serverTimezone: json["server_timezone"],
    apiVersion: json["api_version"],
    executionTime: json["execution_time"],
  );

  Map<String, dynamic> toJson() => {
    "server_time": serverTime,
    "server_timezone": serverTimezone,
    "api_version": apiVersion,
    "execution_time": executionTime,
  };
}
