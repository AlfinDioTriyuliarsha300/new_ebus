import 'package:dio/dio.dart';

import '../../models/mesin_model.dart';
import 'api_service.dart';

class MesinService {

  Future<List<MesinModel>> getMesin() async {

    Response response =
        await ApiService.dio.get(
      "/buses/mesin",
    );

    List data =
        response.data["data"];

    return data
        .map(
          (e) => MesinModel.fromJson(e),
        )
        .toList();
  }
}