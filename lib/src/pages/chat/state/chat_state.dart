import 'package:ai/src/pages/chat/model/chat_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Messages extends StateNotifier<ChatModel> {
  Messages() : super(ChatModel([]));

  addMessage(message) {
    state = ChatModel([...state.messages, message]);
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

  setChatHistory(txt){
    state.chatHistory = txt;
  }
  getChatHistory(){
    return state.chatHistory;
  }

}

final messagesNotifierProvider = StateNotifierProvider((ref) => Messages());
