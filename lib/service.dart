import 'package:dio/dio.dart';
import 'model/info_model.dart';
import 'model/result_model.dart';

class Service {
  final Dio dio = Dio();

  Future<ResultModel> getInfo(InfoModel model) async{
    try {
      final response = await dio.get("http://127.0.0.1:5000/busca");
      print(response.statusCode);
      ResultModel resultModel = ResultModel.fromJson(response.data);
      return resultModel;
    } catch (e) {
      throw "erro";
    }
  }
}
