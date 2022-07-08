//参考にしたサイト
//https://qiita.com/takois/items/6cf59811d3af5b1d33aa
//https://dev-yakuza.posstree.com/flutter/widget/sqflite/#%E6%97%A2%E5%AD%98db%E3%82%92%E4%BD%BF%E3%81%86%E5%A0%B4%E5%90%88

//わかりやすい説明https://417.run/pg/flutter-dart/flutter-sqlite-import/

//memo(小文字)がテーブル名に設定されているので、訂正する必要がある
//myref2(myref.dbをコピーしたもの)を使用
//一時的にimageカラムを削除
//import 'dart:html';
import 'package:blobs/blobs.dart';
import 'dart:io' as io;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import './database_myref.dart';

//assetカラムからデータベースを取得する
Future<Database> get database async {
  var databasesPath = await getDatabasesPath();
  var path = join(databasesPath, 'assets/myref3.db');
  var exists = await databaseExists(path);

  if (!exists) {
    try {
      await io.Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    var data = await rootBundle.load(join('assets', 'myref3.db'));
    List<int> bytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );

    await io.File(path).writeAsBytes(bytes, flush: true);
  }
  //import 'dart:html';をコメントするとエラーが消える
  return await openDatabase(path);
}

//クラス名Material テーブル名material
//materialテーブルのカラム
class Material_db {
  final int id;
  final String name;
  final String kana;
  final String category;
  final int exday;
  final String  image;

  Material_db({
    required this.id,
    required this.name,
    required this.kana,
    required this.category,
    required this.exday,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'kana': this.kana,
      'category': this.category,
      'exday': this.exday,
      'image': this.image,
    };
  }

  @override
  String toString() {
    return 'material{id: $id, name: $name, kana:$kana,category:$category,exday:$exday,image:$image)'; /**/
  }

  
  //挿入
  static Future<void> insertMaterial(Material_db material) async {
    final Database db = await database;
    await db.insert(
      'material',
      material.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //取得
  static Future<List<Material_db>> getMaterial() async {
    final Database db = await database;
    //const String sql = 'SELECT * FROM material';
    final List<Map<String, dynamic>> maps = await db.query('material');
    return List.generate(maps.length, (i) {
      return Material_db(
        id: maps[i]['id'],
        name: maps[i]['name'],
        kana: maps[i]['kana'],
        category: maps[i]['category'],
        exday: maps[i]['exday'],
        image: maps[i]['image'],
      );
    });
  }
}
  
