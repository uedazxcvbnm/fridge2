import 'package:flutter/material.dart';

//　column:賞味期限数値

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grid List',
      home: Scaffold(
        appBar: AppBar(
          title: Text('野菜・果物'),
        ),
        body: GridView.count(
          crossAxisCount: 3,
          children: List.generate(
            100,
            (index) {
              return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.remove),
                      iconSize: 20,
                    ),
                    Text('Item $index'),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.add),
                      iconSize: 20,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}


