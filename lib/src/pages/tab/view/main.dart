import 'package:flutter/material.dart';
import 'package:ai/src/pages/tab/controller/tab_controller.dart';

class TabPage extends StatefulWidget {
  const TabPage({Key? key}) : super(key: key);

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  late List<Widget> allPages;
  BottomBarController bottomBarController = BottomBarController();

  @override
  void initState() {
    super.initState();
    allPages = bottomBarController.getBottomBarPages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: "Chat",
              backgroundColor: Color.fromRGBO(37, 37, 38, 1)),
          BottomNavigationBarItem(
              icon: Icon(Icons.broken_image_outlined),
              label: "Creator",
              backgroundColor: Color.fromRGBO(37, 37, 38, 1)),
        ],
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white30,
        currentIndex: bottomBarController.selectedIndex,
        onTap: (index) {
          setState(() {
            bottomBarController.selectedIndex = index;
          });
        },
      ),
      body: allPages[bottomBarController.selectedIndex],
    );
  }
}
