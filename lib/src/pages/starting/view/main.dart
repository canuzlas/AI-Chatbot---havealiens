// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:drop_shadow_image/drop_shadow_image.dart';
import 'package:flutter/material.dart';

class StartingPage extends StatefulWidget {
  const StartingPage({super.key});

  @override
  State<StartingPage> createState() => _StartingPageState();
}

class _StartingPageState extends State<StartingPage> {
  void setTimeout(callback, time) {
    Duration timeDelay = Duration(milliseconds: time);
    Timer(timeDelay, callback);
  }

  @override
  void initState() {
    setTimeout(() => { Navigator.popAndPushNamed(context, '/chatPage')}, 2000);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SizedBox(
              height: 100,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                 Center(
            child: DropShadowImage(
              offset: Offset(4,4),
              scale: 0.7,
              blurRadius: 10,
              borderRadius: 1,
              image: Image.asset('assets/logo.png',
                width: 300,),
            ),
          )
      
      
                ],
              )),
        ),
      ),
    );
  }
}
