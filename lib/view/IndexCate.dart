import 'package:PureBook/common/common.dart';
import 'package:PureBook/common/util.dart';
import 'package:PureBook/model/Asset.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../router.dart';

class IndexCate extends StatefulWidget {
  var cate;

//  List data;
//
  IndexCate(this.cate);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
//    return _IndexCateState(cate, data);
    return _IndexCateState(cate);
  }
}

class _IndexCateState extends State<IndexCate>
    with AutomaticKeepAliveClientMixin {
  var cate;
  var data = [];

  _IndexCateState(this.cate);

  var page = 0;
  Widget body;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataByCate();
  }

  void _onRefresh() async {
    data = [];
    page = 0;
    getDataByCate();
    if (mounted) {
      setState(() {});
    }
    _refreshController.refreshCompleted();
  }

  getDataByCate() async {
    String url =
        '${Common.movieDomain}movies/category/${this.widget.cate}/page/$page';
    Response response = await Util(context).http().get(url);
    if (List.castFrom(response.data).length == 0) {
      _refreshController.loadNoData();
    } else {
      this.data.addAll(response.data);
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _onLoading() async {
    page += 1;
    getDataByCate();
    if (mounted) setState(() {});
    _refreshController.loadComplete();
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // TODO: implement build
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus mode) {
          if (mode == LoadStatus.idle) {
          } else if (mode == LoadStatus.loading) {
            body = CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text("加载失败！点击重试！");
          } else if (mode == LoadStatus.canLoading) {
            body = Text("松手,加载更多!");
          } else {
            body = Text("到底了!");
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
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
