import 'package:flutter/material.dart';

import '../core/services/checkpoint_service.dart';
import '../models/checkpoint_model.dart';

class CheckpointProvider extends ChangeNotifier {

  final CheckpointService _service =
      CheckpointService();

  List<CheckpointModel>
      checkpoints = [];

  bool isLoading = false;

  Future<void>
      loadCheckpoints() async {

    isLoading = true;

    notifyListeners();

    try {

      checkpoints =
          await _service
              .getAllCheckpoints();

    } finally {

      isLoading = false;

      notifyListeners();

    }
  }
}