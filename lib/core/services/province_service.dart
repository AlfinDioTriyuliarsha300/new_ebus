import '../../models/province_model.dart';

import 'api_service.dart';

class ProvinceService {

  Future<List<ProvinceModel>>
      getProvinces() async {

    final response =
        await ApiService.dio.get(
      "/provinces",
    );

    final List data =
        response.data["data"];

    return data
        .map(
          (e) =>
              ProvinceModel.fromJson(
            e,
          ),
        )
        .toList();
  }
}