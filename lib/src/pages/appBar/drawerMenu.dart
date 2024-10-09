import 'package:ai/src/pages/chat/controller/chat_controller.dart';
import 'package:ai/src/pages/chat/state/chat_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerMenu extends ConsumerStatefulWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  ConsumerState<DrawerMenu> createState() =>
      _MyProfilePageDrawerMenuState();
}

class _MyProfilePageDrawerMenuState extends ConsumerState<DrawerMenu> {

  @override
  Widget build(BuildContext context) {
    
    return Drawer(
      backgroundColor: Colors.black,
      child: Column(
        children: [
          const SafeArea(child: Text("")),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 2.0, right: 0.0),
            title: Row(children: [Image.asset("assets/icon.png",width: 35,height: 45,),const Text('Create photo',style: TextStyle(color: Colors.white),)]),
            onTap: () {
              Navigator.popAndPushNamed(context, '/createPage');
            },
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 2.0, right: 0.0),
            title: Row(children: [Image.asset("assets/icon.png",width: 35,height: 45,),const Text('Chat',style: TextStyle(color: Colors.white),)]),
            onTap: () {
              Navigator.popAndPushNamed(context, '/chatPage');
            },
          ),
        ],
      ),
    );
  }
}