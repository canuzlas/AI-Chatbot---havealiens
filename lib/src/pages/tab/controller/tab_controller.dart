import 'package:ai/src/pages/chat/view/main.dart';
import 'package:ai/src/pages/image/view/main.dart';
import 'package:ai/src/pages/tab/model/tab_model.dart';
import 'package:flutter/material.dart';

class BottomBarController {
  int selectedIndex = 0;

  TabModel chat = TabModel(const MessagingPage());
  TabModel image = TabModel(const ImagePage());

  List<Widget> getBottomBarPages() {
    List<Widget> allPages = [chat.page, image.page];
    return allPages;
  }
}
