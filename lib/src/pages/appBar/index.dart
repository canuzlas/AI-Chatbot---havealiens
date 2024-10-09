import 'package:flutter/material.dart';

class AppBarHavealiens extends StatelessWidget implements PreferredSizeWidget {
  const AppBarHavealiens({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.2,
      leading:Builder(builder: (context) {
          return Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();  
              },
              color: Colors.white,
              icon: const Icon(Icons.menu),
            ),
          );
        }) ,
    
      backgroundColor: const Color.fromRGBO(0, 0, 0,1 ),
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: const Align(
        alignment: Alignment.centerRight,
        child:  Text(
          "HAVEALIENS",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}