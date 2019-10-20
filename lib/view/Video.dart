import 'dart:typed_data';

import 'package:PureBook/common/util.dart';
import 'package:PureBook/model/Asset.dart';
import 'package:PureBook/router.dart';
import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Video extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _VideoState();
  }
}

class _VideoState extends State<Video> {
  ChewieController _chewieController;
  int page = 1;
  var key;
  final Uint8List kTransparentImage = new Uint8List.fromList([
    0x89,
    0x50,
    0x4E,
    0x47,
    0x0D,
    0x0A,
    0x1A,
    0x0A,
    0x00,
    0x00,
    0x00,
    0x0D,
    0x49,
    0x48,
    0x44,
    0x52,
    0x00,
    0x00,
    0x00,
    0x01,
    0x00,
    0x00,
    0x00,
    0x01,
    0x08,
    0x06,
    0x00,
    0x00,
    0x00,
    0x1F,
    0x15,
    0xC4,
    0x89,
    0x00,
    0x00,
    0x00,
    0x0A,
    0x49,
    0x44,
    0x41,
    0x54,
    0x78,
    0x9C,
    0x63,
    0x00,
    0x01,
    0x00,
    0x00,
    0x05,
    0x00,
    0x01,
    0x0D,
    0x0A,
    0x2D,
    0xB4,
    0x00,
    0x00,
    0x00,
    0x00,
    0x49,
    0x45,
    0x4E,
    0x44,
    0xAE,
  ]);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setup();
  }

  setup() async {
    await getData();
//    await getKeys();
  }

  getData() async {
    Response response = await Util(context)
        .http()
        .get('http://120.27.244.128/assets/$key/$page/10');
    List data = response.data;
    data.forEach((f) {
      items.add(new Asset.fromJson(f));
    });
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  List<Asset> items = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
//    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    items = [];
    page = 1;
    getData();
    if (mounted) {
      setState(() {});
    }
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
//    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    page += 1;
    getData();
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            '视频',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            header: WaterDropHeader(),
            footer: CustomFooter(
              builder: (BuildContext context, LoadStatus mode) {
                Widget body;
                if (mode == LoadStatus.idle) {
                  body = Text("上拉加载");
                } else if (mode == LoadStatus.loading) {
                  body = CupertinoActivityIndicator();
                } else if (mode == LoadStatus.failed) {
                  body = Text("加载失败！点击重试！");
                } else if (mode == LoadStatus.canLoading) {
                  body = Text("松手,加载更多!");
                } else {
                  body = Text("没有更多数据了!");
                }

                return Center(
                  child: body,
                );
              },
            ),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: GridView.count(
              children: getWidgetList(),
              shrinkWrap: true,
               //水平子Widget之间间距
          crossAxisSpacing: 10.0,
          //垂直子Widget之间间距
          mainAxisSpacing: 1.0,
          //GridView内边距
          padding: EdgeInsets.all(20.0),
          //一行的Widget数量
          crossAxisCount: 3,
          //子Widget宽高比例
          childAspectRatio: 1 / 2,
            )));
  }

  List<Widget> getWidgetList() {
    return items.map((item) => getItemContainer(item)).toList();
  }

  Widget getItemContainer(Asset item) {
    return InkWell(
      child: Column(
        children: <Widget>[
          FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: item.cover,
            fit: BoxFit.fill,
          ),
          Text(
            item.name.trim(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          )
        ],
      ),
      onTap: () {
        Router.push(context, Router.lookVideoPage, item.v_url);
      },
    );
  }
}
