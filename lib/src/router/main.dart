import 'package:ai/src/pages/chat/view/main.dart';
import 'package:ai/src/pages/image/view/main.dart';
import 'package:ai/src/pages/starting/view/main.dart';
import 'package:flutter/material.dart';

class GeneratedRouter {
  static Route? router(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const StartingPage());
    }

    switch (settings.name) {
      case '/chatPage':
        return MaterialPageRoute(builder: (context) => const MessagingPage());
    }
    switch (settings.name) {
      case '/createPage':
        return MaterialPageRoute(builder: (context) => const ImagePage());
    }
    return null;
  }
}
