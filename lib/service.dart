import 'package:dio/dio.dart';
import 'package:hash_indice/configuration_model.dart';
import 'package:hash_indice/search_model.dart';
import 'package:hash_indice/table_model.dart';

class Service {
  final Dio dio = Dio();

  Future<ConfigurationModel> getConfiguration() async {
    try {
      final response = await dio.get("http://localhost:8080/configuration");

      ConfigurationModel configurationModel =
          ConfigurationModel.fromJson(response.data);
      return configurationModel;
    } catch (e) {
      throw "erro";
    }
  }

  Future<int> postConfiguration(ConfigurationModel configurationModel) async {
    try{
      final response = await dio.post("http://localhost:8080/configuration", data: {
        "pageSize": configurationModel.pageSize,
        "bucketSize": configurationModel.bucketSize
      });
    return response.statusCode!;
    }catch (e){
      throw "erro";
    }

  }

  Future<TableModel> getTable() async{
    try {
      final response = await dio.get("http://localhost:8080/table");
      TableModel tableModel =
      TableModel.fromJson(response.data);
      return tableModel;
    } catch (e) {
      throw "erro";
    }
  }


Future<SearchModel> getSearch(String name) async{
  try {
    final response = await dio.get("http://localhost:8080/table/search?search=$name");
    print(response.statusCode);
    SearchModel searchModel =
    SearchModel.fromJson(response.data);
    return searchModel;
  } catch (e) {
    throw "erro";
  }
}



}
