import 'package:PureBook/common/util.dart';
import 'package:PureBook/model/Asset.dart';
import 'package:PureBook/router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PrivateSpace extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PrivateSpaceState();
  }
}

class _PrivateSpaceState extends State<PrivateSpace>
    with AutomaticKeepAliveClientMixin {
  List<Asset> _assets = [];
  var page = 1;
  Widget body;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    _assets = [];
    page = 1;
    getData();
    if (mounted) {
      setState(() {});
    }
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    page += 1;
    getData();
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  getData() async {
    Response response = await Util(null)
        .http()
        .get('http://120.27.244.128/assets/chinese/$page/10');
    List data = response.data;
    _assets.addAll(data.map((f) => Asset.fromJson(f)).toList());
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

      body: SmartRefresher(
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
        child: StaggeredGridView.countBuilder(
          crossAxisCount: 4,
          itemCount: _assets.length,
          itemBuilder: (BuildContext context, int index) => Container(
              child: GestureDetector(
            child: CachedNetworkImage(

             imageUrl:  _assets[index].cover,
              fit: BoxFit.cover,
            ),
            onTap: () {
              Router.push(context, Router.lookVideoPage, [null,null,'http://120.27.244.128:8080/${_assets[index].name}.mp4',_assets[index].name,null,null],);
            },
          )),
          staggeredTileBuilder: (int index) =>
              StaggeredTile.count(2, index.isEven ? 2 : 1),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
