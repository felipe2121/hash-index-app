class InfoModel {
  final double limit;
  final double page_size;
  final String value;

  InfoModel({required this.limit, required this.page_size, required this.value});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['limit'] = limit;
    data['page_size'] = page_size;
    data['value'] = value;
    return data;
  }
}