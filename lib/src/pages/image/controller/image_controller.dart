import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:dio/dio.dart';

class ImageController {
  final apiUrl = dotenv.env['OPEN_AI_IMAGE_API_URL'];
  late String messagetxt = "";

  final controller = TextEditingController();
  final scrollController = ScrollController();

  scroolToDown(messages) {
    messages.length > 1
        ? scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            curve: Curves.linear,
            duration: const Duration(milliseconds: 300),
          )
        : null;
  }

  Future sendMessage() async {
    var response = await http.post(Uri.parse(apiUrl!),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${dotenv.env['OPEN_AI_KEY']}"
        },
        body: jsonEncode({
          "model": "dall-e-3",
          "prompt": messagetxt.trim(),
          "n": 1,
          "size": "1024x1024"
        }));

    if (response.body.contains("error")) {
      print(response.body);
      return {"result": "error"};
    } else {
      print(response.body);
      return {
        "message": jsonDecode(utf8.decode(response.bodyBytes))["data"][0]
            ["url"],
        "role": "assistant"
      };
    }
  }

  downloadToImage(String url) async {
    var response = await Dio()
        .get(url, options: Options(responseType: ResponseType.bytes));
    await ImageGallerySaver.saveImage(Uint8List.fromList(response.data),
        quality: 100, name: "sad");

    return Fluttertoast.showToast(
        msg: "saved to gallery",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
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
