import 'dart:typed_data';

import 'package:PureBook/common/common.dart';
import 'package:PureBook/common/util.dart';
import 'package:PureBook/model/Asset.dart';
import 'package:PureBook/view/IndexCate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../router.dart';
import 'MySearchDelegate.dart';
import 'Search.dart';

class MovieIndex extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MovieIndexState();
  }
}

class _MovieIndexState extends State<MovieIndex>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  List<Widget> wds = [];
  List<String> cates = [
    'list01',
    'list02',
    'list03',
    'list04',
    'list05',
    'list06',
  ];
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

  List<Tab> _tabs = <Tab>[
    new Tab(
      text: '精选',
    ),
    Tab(text: '欧美片'),
    Tab(text: '华语片'),
    Tab(text: '日韩片'),
    Tab(text: '动画片'),
    Tab(text: '印度片'),
    Tab(text: '泰国片'),
  ];
  var _tabController;
  var data = [];

  List<Asset> items = new List();
  Widget body;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(vsync: this, length: _tabs.length);

    initData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return wds.length > 0
        ? Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white12,
              automaticallyImplyLeading: false,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(45),
                child: Column(
                  children: <Widget>[
                    TabBar(
                      labelColor: Colors.black,
                      isScrollable: true,
                      labelStyle: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.bold),
                      // 必须设置，设置 color 没用的，因为 labelColor 已经设置了
                      unselectedLabelColor: Colors.black38,
                      unselectedLabelStyle: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.bold),
                      // 设置 color 没用的，因为unselectedLabelColor已经设置了
                      controller: _tabController,
                      // tabbar 必须设置 controller 否则报错
                      // 有 tab 和 label 两种
                      tabs: _tabs,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        // 修饰搜索框, 白色背景与圆角
                        decoration: BoxDecoration(
                          color: Colors.black12,
                        ),
                        alignment: Alignment.center,
                        height: 36,
                        padding: EdgeInsets.fromLTRB(1.0, 0.0, 10.0, 0.0),
                        child: buildTextField(),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    )
                  ],
                ),
              ),
            ),
            body: TabBarView(controller: _tabController, children: wds))
        : Container(
            color: Colors.white,
          );

//
  }

  Widget buildTextField() {
    // theme设置局部主题
    return Theme(
      data: ThemeData(primaryColor: Colors.grey),
      child: TextField(
        onTap: () {
          myshowSearch(context: context, delegate: SearchBarDelegate('movie'));
        },
        cursorColor: Colors.grey,
        // 光标颜色
        // 默认设置
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(top: 1.0),
            border: InputBorder.none,
            hintText: '极速全网搜索',
            icon: Icon(
              Icons.search,
              color: Colors.orange,
            ),
            hintStyle: TextStyle(
              fontSize: 14,
              color: Color.fromARGB(50, 0, 0, 0),
            )),
        style: TextStyle(fontSize: 14, color: Colors.black),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  Widget _swiperBuilder(BuildContext context, int index) {
    return (CachedNetworkImage(
      imageUrl: Asset.fromJson(data[0][index]).cover,
      fit: BoxFit.fill,
    ));
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
        Router.push(context, Router.movieDetailPage, data);
      },
    );
  }

  Widget item(title, data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 17.0, top: 5.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        GridView.count(
          cacheExtent: 400,
          physics: NeverScrollableScrollPhysics(),
          children: getWidgetList(data),
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
        )
      ],
    );
  }

  initData() async {
    Response response =
        await Util(null).http().get('${Common.movieDomain}index/movie');
    var data = response.data;
    this.data = data;
    wds.add(SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width,
              height: 200.0,
              child: Swiper(
                itemBuilder: _swiperBuilder,
                itemCount: data[0].length,
                pagination: SwiperPagination(
                    builder: DotSwiperPaginationBuilder(
                  color: Colors.black54,
                  activeColor: Colors.white,
                )),
                control: SwiperControl(color: Colors.white12),
                scrollDirection: Axis.horizontal,
                onTap: (index) async {
                  var d = [];
                  Response response = await Util(context).http().get(
                      '${Common.movieDomain}movies/${Asset.fromJson(data[0][index]).v_url}');
                  d.add(response.data);
                  d.add(Asset.fromJson(data[0][index]));
                  Router.push(context, Router.movieDetailPage, d);
                },
              )),
          item('最新收录', data[1]),
          item('今日更新', data[2]),
          item('院线热播', data[3]),
          item('欧美电影', data[4]),
          item('华语电影', data[5]),
          item('日韩电影', data[6]),
          item('动画电影', data[7]),
        ],
      ),
    ));
    for (var i = 1; i < _tabs.length; i++) {
      wds.add(IndexCate(cates[i - 1]));
    }
    if (mounted) {
      setState(() {});
    }
  }
}
