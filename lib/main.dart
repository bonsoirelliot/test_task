import 'package:flutter/material.dart';
import 'pages/shop_screen.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: CupertinoThemeData(
        barBackgroundColor: Color(0xFFF3F4F6),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: ShopScreen(),
    );
  }
}
