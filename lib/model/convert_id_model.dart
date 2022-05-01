import 'dart:convert';

ConvertId convertIdFromJson(String str) => ConvertId.fromJson(json.decode(str));

String convertIdToJson(ConvertId data) => json.encode(data.toJson());

class ConvertId {
  ConvertId({
    required this.id,
    required this.imdbId,
    required this.freebaseMid,
    required this.freebaseId,
    required this.tvdbId,
    required this.tvrageId,
    required this.facebookId,
    required this.instagramId,
    required this.twitterId,
  });

  int id;
  String imdbId;
  String freebaseMid;
  String freebaseId;
  int tvdbId;
  int tvrageId;
  String facebookId;
  String instagramId;
  String twitterId;

  factory ConvertId.fromJson(Map<String, dynamic> json) => ConvertId(
        id: json["id"] == null ? 0 : json["id"],
        imdbId: json["imdb_id"] == null ? '' : json["imdb_id"],
        freebaseMid: json["freebase_mid"] == null ? '' : json["freebase_mid"],
        freebaseId: json["freebase_id"] == null ? '' : json["freebase_id"],
        tvdbId: json["tvdb_id"] == null ? 0 : json["tvdb_id"],
        tvrageId: json["tvrage_id"] == null ? 0 : json["tvrage_id"],
        facebookId: json["facebook_id"] == null ? '' : json["facebook_id"],
        instagramId: json["instagram_id"] == null ? '' : json["instagram_id"],
        twitterId: json["twitter_id"] == null ? '' : json["twitter_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "imdb_id": imdbId,
        "freebase_mid": freebaseMid,
        "freebase_id": freebaseId,
        "tvdb_id": tvdbId,
        "tvrage_id": tvrageId,
        "facebook_id": facebookId,
        "instagram_id": instagramId,
        "twitter_id": twitterId,
      };
}
