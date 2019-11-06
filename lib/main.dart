import 'dart:io';

import 'package:PureBook/view/MovieIndex.dart';
import 'package:PureBook/view/PrivateSpace.dart';
import 'package:PureBook/view/TVIndex.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  await SpUtil.getInstance();


  runApp(MyApp());
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
    SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: 'Movie',
      theme: ThemeData.light(),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  int _tabIndex = 0;
  var appBarTitles = {
    0: "美剧",
    1: "电影",
    2: "燃图",
  };

  var _pageController = PageController();
  List<BottomNavigationBarItem> bottoms = [
    BottomNavigationBarItem(
        icon: Icon(Icons.tv),
        title: Text(
          '美剧',
        )),
    BottomNavigationBarItem(
        icon: Icon(Icons.movie),
        title: Text(
          '电影',
        )),
    BottomNavigationBarItem(
        icon: Icon(Icons.weekend),
        title: Text(
          '燃图',
        )),
  ];

  Text getTabTitle(int curIndex) {
    if (curIndex == _tabIndex) {
      return new Text(appBarTitles[curIndex]);
    } else {
      return new Text(appBarTitles[curIndex]);
    }
  }

  /*
   * 存储的四个页面，和Fragment一样
   */
  var _pages = [TVIndex(), MovieIndex(),PrivateSpace()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView.builder(
            //要点1
            physics: NeverScrollableScrollPhysics(),
            //禁止页面左右滑动切换
            controller: _pageController,
            onPageChanged: _pageChanged,
            //回调函数
            itemCount: _pages.length,
            itemBuilder: (context, index) => _pages[index]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        selectedItemColor: Colors.deepOrange,
        items: bottoms,
        type: BottomNavigationBarType.fixed,
        currentIndex: _tabIndex,
        onTap: (index) {
          _pageController.jumpToPage(index);
        },
      ),
    );
  }

  void _pageChanged(int index) {
    setState(() {
      if (_tabIndex != index) _tabIndex = index;
    });
  }


}
