import 'package:PureBook/view/LookVideo.dart';
import 'package:PureBook/view/MovieDetail.dart';
import 'package:PureBook/view/MovieIndex.dart';
import 'package:PureBook/view/TVIndex.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///https://www.jianshu.com/p/b9d6ec92926f

class Router {
  static const detailPage = 'app://DetailPage';
  static const playListPage = 'app://VideosPlayPage';
  static const searchPage = 'app://SearchPage';
  static const photoHero = 'app://PhotoHero';
  static const personDetailPage = 'app://PersonDetailPage';
  static const lookVideoPage = 'app://LookVideoPage';
  static const tvIndexPage = 'app://TvIndexPage';
  static const movieDetailPage = 'app://MovieDetailPage';
  static const movieIndexPage = 'app://MovieIndexPage';

//  Widget _router(String url, dynamic params) {
//    String pageId = _pageIdMap[url];
//    return _getPage(pageId, params);
//  }
//
//  Map<String, dynamic> _pageIdMap = <String, dynamic>{
//    'app/': 'ContainerPageWidget',
//    detailPage: 'DetailPage',
//  };

  Widget _getPage(String url, dynamic params) {
    if (url.startsWith('https://') || url.startsWith('http://')) {
//      return WebViewPage(url, params: params);
    } else {
      switch (url) {
        case lookVideoPage:
          return LookVideo(params);
        case tvIndexPage:
          return TVIndex();
        case movieDetailPage:
          return MovieDetail(params);
        case movieIndexPage:
          return MovieIndex();

//        case photoHero:
//          return PhotoHeroPage(
//              photoUrl: params['photoUrl'], width: params['width']);
//        case personDetailPage:
//          return PersonDetailPage(params['personImgUrl'], params['id']);
      }
    }
    return null;
  }

//
//  void push(BuildContext context, String url, dynamic params) {
//    Navigator.push(context, MaterialPageRoute(builder: (context) {
//      return _getPage(url, params);
//    }));
//  }

  Router.pushNoParams(BuildContext context, String url) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return _getPage(url, null);
    }));
  }

  Router.push(BuildContext context, String url, dynamic params) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return _getPage(url, params);
    }));
  }
}
