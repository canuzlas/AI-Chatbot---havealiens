import 'package:ai/src/pages/image/model/image_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Images extends StateNotifier<ImageModel> {
  Images() : super(ImageModel([]));

  addMessage(message) {
    state = ImageModel([...state.messages, message]);
  }

  changeGetting(tooggle) {
    state.getting = tooggle;
  }

  getStatusGetting() {
    return state.getting;
  }

  getMessages() {
    return state.messages;
  }
}

final imagesNotifierProvider = StateNotifierProvider((ref) => Images());
