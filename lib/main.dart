import 'dart:core';
import 'package:ai/firebase_options.dart';
import 'package:ai/src/pages/starting/view/main.dart';
import 'package:ai/src/router/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowMaterialGrid: false,
      showSemanticsDebugger: false,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: GeneratedRouter.router,
      initialRoute: "/",
      home: StartingPage(),
    );
  }
}

