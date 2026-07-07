import '../../models/city_model.dart';

import 'api_service.dart';

class CityService {

  Future<List<CityModel>>
      getCitiesByProvince(
    int provinceId,
  ) async {

    final response =
        await ApiService.dio.get(
      "/cities/province/$provinceId",
    );

    final List data =
        response.data["data"];

    return data
        .map(
          (e) =>
              CityModel.fromJson(e),
        )
        .toList();
  }
}