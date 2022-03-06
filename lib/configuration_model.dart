class ConfigurationModel {
  int? pageSize;
  int? bucketSize;

  ConfigurationModel({required pageSize, required bucketSize});

  ConfigurationModel.fromJson(Map<String, dynamic> json) {
    pageSize = json["pageSize"];
    bucketSize = json["bucketSize"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["pageSize"] = pageSize;
    data["bucketSize"] = bucketSize;
    return data;
  }
}
