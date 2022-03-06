class SearchModel {
  String? name;
  int? cost;

  SearchModel({this.name, this.cost});

  SearchModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    cost = json['cost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['cost'] = this.cost;
    return data;
  }
}