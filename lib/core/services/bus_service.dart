import 'package:dio/dio.dart';

import 'api_service.dart';
import '../../models/bus_model.dart';

class BusService {

  Future<List<BusModel>> getBuses() async {

    try {

      Response response =
          await ApiService.dio.get(
        '/buses',
      );

      List data =
          response.data['data'];

      return data
          .map(
            (e) => BusModel.fromJson(e),
          )
          .toList();

    } catch (e) {

      throw Exception(e);
    }
  }
}