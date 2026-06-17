import 'package:dio/dio.dart';

import 'api_service.dart';
import '../../models/schedule_model.dart';

class ScheduleService {

  Future<List<ScheduleModel>>
      getSchedules(
    int companyId,
  ) async {

    Response response =
        await ApiService.dio.get(
      '/schedules',
      queryParameters: {
        'company_id': companyId,
      },
    );

    List data =
        response.data['data'];

    return data
        .map(
          (e) => ScheduleModel.fromJson(e),
        )
        .toList();
  }
}