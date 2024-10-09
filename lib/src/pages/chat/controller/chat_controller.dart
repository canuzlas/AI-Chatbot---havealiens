import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatController {
  final apiUrl = dotenv.env['OPEN_AI_CHAT_API_URL'];
  late String messagetxt = "";

  final controller = TextEditingController();
  final scrollController = ScrollController();

  late SharedPreferences prefs;

  getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  scroolToDown(messages) {
    messages.length > 1
        ? scrollController.animateTo(
            scrollController.position.maxScrollExtent + 100,
            curve: Curves.bounceInOut,
            duration: const Duration(milliseconds: 300),
          )
        : null;
  }

  Future sendMessage() async {
    getSharedPreferences();
    var response = await http.post(Uri.parse(apiUrl!),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${dotenv.env['OPEN_AI_KEY']}"
        },
        body: jsonEncode({
          "model": "gpt-4o",
          "messages": [
            {"role": "user", "content": messagetxt.trim()}
          ],
          "temperature": 0.7
        }));
    
     await prefs.setString("chatHistory", messagetxt.toString());
     messagetxt = "";
    if (response.body.contains("error")) {
      return {"result": "error"};
    } else {
      return {
        "message": jsonDecode(utf8.decode(response.bodyBytes))["choices"][0]
            ["message"]["content"],
        "role": "assistant"
      };
    }
  }

  writeWidget() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
            padding: EdgeInsets.only(
              left: 20,
            ),
            child:
                Text("👽", style: TextStyle(color: Colors.red, fontSize: 25))),
      ],
    );
  }
}
