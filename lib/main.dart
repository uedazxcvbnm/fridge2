/*クラス名
MyStatefulWidget　画面下部のバーを作るときに必要なクラス　画面を表示しているクラスではない
MyHomePage　食品の登録画面
*/
//StreamBuilderを使おうとしたけど、エラーが出たのでコメントしてます
import 'package:flutter/material.dart';
import './page1.dart';
import './page2.dart';
import './popup_check.dart';
import './nextpage.dart';
import './provider.dart';
import './main3_4.dart';
/*import './page3.dart';
import './page4.dart';*/
import './database_myref.dart';
import './database_material.dart';
//import './provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:stream_transform/stream_transform.dart';
import 'package:stack_trace/stack_trace.dart';
import 'package:blobs/blobs.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

GlobalKey navBarGlobalKey = GlobalKey(debugLabel: 'bottomAppBar');
//BottomNavigationBar
void main() {
  //Stetho.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String _title = 'BottomNavBar Code Sample';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BottomNavBar Code Sample',
      home: MyStatefulWidget(),
      routes: {
        //'/': (context) => MyHomePage(),
        '/page2': (context) => NextPage(),
        //'/page2': (context) => InputTest(),
      },
    );
  }
}

//画面上部のバー　食材を種類ごとに分類する画面に移動するボタン
class TabInfo {
  String label;
  Widget widget;
  TabInfo(this.label, this.widget);
}

//MyStatefulWidget　ボトムナビゲーションバーを作るときに必要なクラス（画面下部のバー）
class MyStatefulWidget extends StatefulWidget {
  //constが必要
  const MyStatefulWidget({Key? key}) : super(key: key);
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

//画面下部のバー　画面移動するボタン
//画面下部のバー　画面移動するボタン
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  var _childPageList = <Widget>[
    //食品の登録画面
    MyHomePage(),
    //食品を表示する画面
    NextPage(),
    //賞味期限が切れそうな食品で作った料理の紹介画面
    homePage3(),
    //設定画面
    homePage4(),
  ];
  //画面移動するボタンの関数　画面下部のバー
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //画面下部のバー　https://zenn.dev/urasan/articles/5bb85a54fb23fb
  //https://qiita.com/taki4227/items/e3c7e640b7986a80b2f9

  //https://qiita.com/canisterism/items/d648da85c300a3751db0 に変更
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: const Text('DEMO'),
        backgroundColor: Colors.green,
      ),*/
      body: PersistentTabView(
        context,
        //index: _selectedIndex,
        screens: _childPageList,
        backgroundColor: Colors.green,
        //画面を移動するボタン
        items: [
          PersistentBottomNavBarItem(
            icon: Icon(Icons.shopping_cart),
            activeColorPrimary: Colors.orange,
            inactiveColorPrimary: Colors.white,
            //Flutter3なのでここではlabelを使うべき
            //label: 'ラベル1',
            //バーの色はここで設定する
            //backgroundColor: Colors.green,
          ),
          PersistentBottomNavBarItem(
              icon: Icon(Icons.home),
              activeColorPrimary: Colors.orange,
              inactiveColorPrimary: Colors.white
              //label: 'ラベル2',
              //backgroundColor: Colors.green,
              ),
          PersistentBottomNavBarItem(
              icon: Icon(Icons.add),
              activeColorPrimary: Colors.orange,
              inactiveColorPrimary: Colors.white
              //label: 'ラベル3',
              //backgroundColor: Colors.green,
              ),
          PersistentBottomNavBarItem(
              icon: Icon(Icons.settings),
              activeColorPrimary: Colors.orange,
              inactiveColorPrimary: Colors.white
              //label: 'ラベル4',
              //backgroundColor: Colors.green,
              ),
        ],
      ),
    );
  }
}

//食品の登録画面（追加画面）MyHomePage　ボトムナビゲーションバーの１つ目のページ（食品を登録する画面）
class HomeWidget extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePage();
}

//https://flutter.keicode.com/basics/tabbarview.php
class _MyHomePage extends State<MyHomePage> {
  //食品を種類ごとに分類して表示する画面に、移動するボタン
  final List<TabInfo> _tabs = [
    TabInfo("野菜・果物", Page1()),
    TabInfo("肉・魚", Page2()),
    //TabInfo("インスタント食品", Page3()),
    //TabInfo("頻繁に買う食品", Page4()),
  ];

  //複数のテーブルを同時に取得するために必要な関数を作るために定義したリスト
  List<Refri> _memoList = [];
  Stream<int> initializeDemo() async* {
    _memoList = await Refri.getMemos();
  }

  List<Material_db> _memolist2 = [];
  Stream<int> initializeDemo2() async* {
    _memolist2 = await Material_db.getMaterial();
  }

  List<Refri> _memolist3 = [];
  Stream<int> initializeDemo3() async* {
    _memolist3 = await Refri.getMemos();
  }

  //複数のテーブルを同時に取得するために必要な関数
  //https://qiita.com/ninoko1995/items/fe7115d8030a7a4cce0d
  Stream<Map<String, dynamic>> streamName() {
    return initializeDemo()
        .combineLatestAll([initializeDemo2(), initializeDemo3()]).map((data) {
      return {
        "initializeDemo()": data[0],
        "initializeDemo2()": data[1],
        "initializeDemo3()": data[2],
      };
    });
  }

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      //title: 'Grid List',
      child: Scaffold(
        appBar: AppBar(
          title: Text('賞味期限管理アプリ'),
          actions: [
            IconButton(
              icon: Icon(Icons.android),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => popUpPage())));
              },
            ),
          ],
          backgroundColor: Colors.green,
          bottom: PreferredSize(
            child: TabBar(
              isScrollable: true,
              tabs: _tabs.map((TabInfo tab) {
                return Tab(text: tab.label);
              }).toList(),
            ),
            preferredSize: Size.fromHeight(30.0),
          ),
        ),
        body: Center(
          child: StreamBuilder(
            stream: streamName(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // 非同期処理未完了 = 通信中
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              //食品の登録画面
              //https://flutter.ctrnost.com/layout/body/grid/
              return GridView.builder(
                //crossAxisCount: 2,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, //カラム数
                ),
                itemCount: _memolist2.length, //要素数
                itemBuilder: (context, index) {
                  //return Container(
                  return Card(
                    child: Column(
                      children: <Widget>[
                        //materialテーブルのid
                        Text('ID${_memolist2[index].id.toString()}'),
                        //materialテーブルのexday 保存期間の基準
                        //参考サイトhttps://foo-d.info/vegetables/
                        Text(
                          '${_memolist2[index].exday.toString()}日後',
                        ),
                        //refriテーブルのname
                        Text('${_memoList[index].name}'),
                        //画像表示 materialテーブルのimage
                        Container(
                          width: 80,
                          height: 80,
                          child: Image.asset('${_memolist2[index].image}'),
                        ),
                        //食品のカウントアップをするボタン　食品の個数を登録
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () async {
                                //今日の日付
                                var now = DateTime.now();

                                //日付の表示形式
                                var _now = DateFormat('yyyy-MM-dd').format(now);
                                //stringからDateTimeに変換
                                var _nowDate = DateTime.parse(_now);

                                //テーブルの値を取り出す
                                ///////_memolist2 = await Material_db.getExday();
                                //materialテーブルからexdayカラムを取り出す
                                var sql3 = _memolist2[index].id;
                                int sql4 = _memolist2[sql3].exday;

                                //賞味期限の計算　賞味期限＝今日の日付+materialテーブルのexdayカラム
                                var _time = _nowDate.add(Duration(days: sql4));
                                var _nowtime =
                                    DateFormat('yyyy-MM-dd').format(_time);

                                //食品の個数　プラスボタンを1回タップしたら、食品の登録量が1個増える
                                var _counter = _memoList[index].count + 1;

                                var update_refri2 = Refri(
                                    id: _memoList[index].id,
                                    count: _counter,
                                    date: _nowtime.toString(),
                                    name: _memoList[index].name);
                                //データベースをアップデート
                                await Refri.insertMemo(update_refri2);
                                //データの取得
                                final List<Refri> memos2 =
                                    await Refri.getMemos();
                                super.setState(() {
                                  //_selectedvalue_id = null;
                                  _memolist3 = memos2;
                                  setState(() {});
                                });
                              },
                              //プラスボタン　アイコンの指定
                              icon: Icon(Icons.add),
                              iconSize: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
