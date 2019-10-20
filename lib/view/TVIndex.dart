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

class TVIndex extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TVIndexState();
  }
}

class _TVIndexState extends State<TVIndex>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  List<Widget> wds = [];
  List<String> cates = [
    'kehuanpian',
    'juqingpian',
    'dongzuopian',
    'xijupian',
    'donghuapian',
    'qihuanpian',
    'kongbupian',
    'xuanyipian',
    'jilupian',
    'zhenrenxiu'
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
    Tab(
      text: '精选',
    ),
    Tab(text: '科幻片'),
    Tab(text: '剧情片'),
    Tab(text: '动作片'),
    Tab(text: '喜剧片'),
    Tab(text: '动画片'),
    Tab(text: '奇幻片'),
    Tab(text: '恐怖片'),
    Tab(text: '悬疑片'),
    Tab(text: '纪录片'),
    Tab(text: '真人秀'),
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
                      indicatorColor: Colors.deepOrange,
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
          myshowSearch(context: context, delegate: SearchBarDelegate('tv'));
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
        await Util(null).http().get('${Common.movieDomain}index');
    var data = response.data;
    this.data = data;
    wds.add(SingleChildScrollView(
      child: Column(
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
          item('每日更新', data[1]),
          item('最新美剧', data[2]),
          item('科幻', data[3]),
          item('恐怖', data[4]),
          item('喜剧', data[5]),
          item('剧情', data[6]),
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
