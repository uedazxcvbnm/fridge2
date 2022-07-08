import 'package:flutter/material.dart';
import './nextpage.dart';
import './main.dart';

//画面下部のバーの左から3つめのボタン　何も作っていない
class homePage3 extends StatefulWidget {
  //static const routeName = '/next';
  const homePage3({Key? key}) : super(key: key);
  //final String title;
  @override
  State<homePage3> createState() => _homePage3();
}

class _homePage3 extends State<homePage3> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // デフォルト表示
            Text('Default'),
          ],
        ),
      ),
    );
  }
}

//画面下部のバーの左から4つめのボタン　何も作っていない
class homePage4 extends StatefulWidget {
  //static const routeName = '/next';

  const homePage4({Key? key}) : super(key: key);
  //final String title;
  @override
  State<homePage4> createState() => _homePage4();
}

class _homePage4 extends State<homePage4> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // デフォルト表示
            Text('Default'),
          ],
        ),
      ),
    );
  }
}
