import 'package:new_ebus/models/terminal_model.dart';

import 'api_service.dart';

class TerminalService {
  Future<List<TerminalModel>> getTerminals() async {
    final response = await ApiService.dio.get("/terminals");

    final List data = response.data["data"];

    return data.map((e) => TerminalModel.fromJson(e)).toList();
  }

  Future<void> createTerminal({
    required int cityId,
    required String namaTerminal,
    required String alamat,
    required double lat,
    required double lng,
  }) async {
    await ApiService.dio.post(
      "/terminals",
      data: {
        "city_id": cityId,
        "nama_terminal": namaTerminal,
        "alamat": alamat,
        "lat": lat,
        "lng": lng,
      },
    );
  }

  Future<void> updateTerminal({
    required int id,
    required int cityId,
    required String namaTerminal,
    required String alamat,
    required double lat,
    required double lng,
  }) async {
    await ApiService.dio.put(
      "/terminals/$id",
      data: {
        "city_id": cityId,
        "nama_terminal": namaTerminal,
        "alamat": alamat,
        "lat": lat,
        "lng": lng,
      },
    );
  }

  Future<void> deleteTerminal(int id) async {
    await ApiService.dio.delete("/terminals/$id");
  }
}
