class TableModel {
  int? readSize;
  int? pageSize;
  int? bucketSize;
  int? colisionCount;
  int? overflowCount;
  int? bucketNumber;

  TableModel(
      {this.readSize,
        this.pageSize,
        this.bucketSize,
        this.colisionCount,
        this.overflowCount,
        this.bucketNumber});

  TableModel.fromJson(Map<String, dynamic> json) {
    readSize = json['readSize'];
    pageSize = json['pageSize'];
    bucketSize = json['bucketSize'];
    colisionCount = json['colisionCount'];
    overflowCount = json['overflowCount'];
    bucketNumber = json['bucketNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['readSize'] = this.readSize;
    data['pageSize'] = this.pageSize;
    data['bucketSize'] = this.bucketSize;
    data['colisionCount'] = this.colisionCount;
    data['overflowCount'] = this.overflowCount;
    data['bucketNumber'] = this.bucketNumber;
    return data;
  }
}