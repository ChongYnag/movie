import 'package:PureBook/common/common.dart';
import 'package:PureBook/common/util.dart';
import 'package:PureBook/model/Asset.dart';
import 'package:PureBook/router.dart';
import 'package:PureBook/view/MyVideoControls.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LookVideo extends StatefulWidget {
  List src;

  LookVideo(this.src);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _LookVideoState();
  }
}

class _LookVideoState extends State<LookVideo> {
  ChewieController _chewieController;
  VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.network(this.widget.src[2]);
    // TODO: implement initState
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        allowedScreenSleep: false,
        allowFullScreen: true,
        aspectRatio: 16 / 9,
        customControls: MyVideoControls(this.widget.src[3]));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _chewieController.dispose();
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: XFileAppbar(
        contentChild: Chewie(
          controller: _chewieController,
        ),
        contentHeight: 220,
        statusBarColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 17.0, top: 5.0),
              child: Wrap(
                spacing: 2, //主轴上子控件的间距
                runSpacing: 5, //交叉轴上子控件之间的间距
                children: Boxs(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 17.0, top: 20.0),
              child: Text(
                '喜欢这个视频的人也喜欢···',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            GridView.count(
              physics: new NeverScrollableScrollPhysics(),
              children: getWidgetList(this.widget.src[0]),
              shrinkWrap: true,
              //水平子Widget之间间距
              crossAxisSpacing: 10.0,
              //垂直子Widget之间间距
              mainAxisSpacing: 5.0,
              //GridView内边距
              padding: EdgeInsets.all(5.0),
              //一行的Widget数量
              crossAxisCount: 3,
              //子Widget宽高比例
              childAspectRatio: 1 / 2,
              cacheExtent: 400.0,
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 17.0, top: 15.0),
              child: new Text(
                ' 每日更新',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            GridView.count(
              physics: new NeverScrollableScrollPhysics(),
              children: getWidgetList(this.widget.src[1]),
              shrinkWrap: true,
              //水平子Widget之间间距
              crossAxisSpacing: 10.0,
              //垂直子Widget之间间距
              mainAxisSpacing: 5.0,
              //GridView内边距
              padding: EdgeInsets.all(5.0),
              //一行的Widget数量
              crossAxisCount: 3,
              //子Widget宽高比例
              childAspectRatio: 1 / 2,
              cacheExtent: 400.0,
            )
          ],
        ),
      ),
    );
  }

  List<Widget> Boxs() {
    List<Widget> wds = [];
    List x = List.of(this.widget.src[4]);

    for (var i = 0; i < x.length; i++) {
      wds.add(Container(
        width: 90,
        height: 30,
        alignment: Alignment.center,
        color: Colors.grey,
        child: InkWell(
          child: Text(
            Map.castFrom(x[i]).values.toList()[0],
            style: TextStyle(
              color:
                  this.widget.src[5] == i ? Colors.amberAccent : Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () async {
            var url =
                '${Common.movieDomain}movies/${Map.castFrom(x[i]).keys.toList()[0]}/${this.widget.src[6]}';
            Response response = await Util(context).http().get(url);
            List data = response.data;
            data.add(this.widget.src[3]);
            data.add(this.widget.src[4]);
            data.add(i);
            data.add(this.widget.src[6]);
            Navigator.pop(context);
            Router.push(context, Router.lookVideoPage, data);
          },
        ),
      ));
    }
    return wds;
  }

  List<Widget> getWidgetList(List x) {
    List<Widget> wds = [];
    x.forEach((f) {
      wds.add(getItemContainer(new Asset.fromJson(f)));
    });

    return wds;
  }

  Widget getItemContainer(Asset item) {
    return InkWell(
      child: Column(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: item.cover,
            fit: BoxFit.cover,
            height: 190,
          ),
          Text(
            item.name.trim(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          )
        ],
      ),
      onTap: () async {
        var data = [];
        Response response = await Util(context)
            .http()
            .get('${Common.movieDomain}movies/${item.v_url}');
        data.add(response.data);
        data.add(item);
        Navigator.pop(context);
        Router.push(context, Router.movieDetailPage, data);
      },
    );
  }
}

class XFileAppbar extends StatefulWidget implements PreferredSizeWidget {
  final double contentHeight; //从外部指定高度
  final Widget contentChild; //从外部指定内容
  final Color statusBarColor; //设置statusbar的颜色

  XFileAppbar({this.contentChild, this.contentHeight, this.statusBarColor})
      : super();

  @override
  State<StatefulWidget> createState() {
    return new _XFileAppbarState();
  }

  @override
  Size get preferredSize => new Size.fromHeight(contentHeight);
}

/**
 * 这里没有直接用SafeArea，而是用Container包装了一层
 * 因为直接用SafeArea，会把顶部的statusBar区域留出空白
 * 外层Container会填充SafeArea，指定外层Container背景色也会覆盖原来SafeArea的颜色
 */
class _XFileAppbarState extends State<XFileAppbar> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      color: widget.statusBarColor,
      child: SafeArea(
        top: true,
        child: widget.contentChild,
      ),
    );
  }
}
