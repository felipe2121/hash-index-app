class ResultModel {
  num? access;
  num? colisions;
  num? overflow;
  num? countRegistro;
  num? buckets;
  num? bucketLimit;
  num? size;

  ResultModel({
    required this.access,
    required this.colisions,
    required this.overflow,
    required this.countRegistro,
    required this.buckets,
    required this.bucketLimit,
    required this.size
  });

  ResultModel.fromJson(Map<String, dynamic> json) {
    access = json['access'];
    colisions = json['colisions'];
    overflow = json['overflow'];
    countRegistro = json['countRegistro'];
    buckets = json['buckets'];
    bucketLimit = json['bucketLimit'];
    size = json['size'];
  }
}