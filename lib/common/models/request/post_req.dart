class PostsReq {
  String latitude;
  String longitude;
  int? isVideo;
  int? pageNo;
  int? pageSize;

  PostsReq({
    required this.latitude,
    required this.longitude,
    this.isVideo,
    this.pageNo = 1,
    this.pageSize = 10,
  });

  factory PostsReq.fromJson(Map<String, dynamic> json) => PostsReq(
    latitude: json['latitude'] as String,
    longitude: json['longitude'] as String,
    isVideo: json['isVideo'] as int?,
    pageNo: json['pageNo'] as int?,
    pageSize: json['pageSize'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'isVideo': isVideo,
    'pageNo': pageNo,
    'pageSize': pageSize,
  };
}
