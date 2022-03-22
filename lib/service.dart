import 'package:dio/dio.dart';
import 'model/info_model.dart';
import 'model/result_model.dart';

class Service {
  final Dio dio = Dio();

  Future<ResultModel> getInfo(InfoModel model) async{
    try {

      final response = await dio.post("http://10.0.2.2:5000/busca", data: {
        "limit" : model.limit.toInt(),
        "page_size" : model.page_size.toInt(),
        "value" : model.value
      });
      print(response.statusCode);
      ResultModel resultModel = ResultModel.fromJson(response.data);
      return resultModel;
    } catch (e) {
      throw e;
    }
  }
}
