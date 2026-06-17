import 'package:dio/dio.dart';

import 'api_service.dart';
import '../../models/route_model.dart';

class RouteService {

  Future<List<RouteModel>> getRoutes() async {

    Response response =
        await ApiService.dio.get(
      '/routes',
    );

    List data =
        response.data['data'];

    return data
        .map(
          (e) => RouteModel.fromJson(e),
        )
        .toList();
  }
}