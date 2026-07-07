import '../../models/checkpoint_model.dart';
import 'api_service.dart';

class CheckpointService {

  Future<List<CheckpointModel>>
      getAllCheckpoints() async {

    final response =
        await ApiService.dio.get(
      "/checkpoints",
    );

    final List data =
        response.data["data"];

    return data
        .map(
          (e) =>
              CheckpointModel.fromJson(e),
        )
        .toList();
  }
}