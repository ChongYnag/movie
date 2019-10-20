import 'package:PureBook/common/common.dart';
import 'package:PureBook/common/util.dart';
import 'package:PureBook/model/Asset.dart';
import 'package:PureBook/router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'MySearchDelegate.dart';

class SearchBarDelegate extends MySearchDelegate<String> {
  var type;

  SearchBarDelegate(this.type);

  List<Asset> items = [];
  int page = 0;
  Widget body;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: Colors.black,
        ),
        onPressed: () {
          query = "";
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SerarchScen(query, type);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return new SearchSuggestion(type);
  }
}

class SearchSuggestion extends StatefulWidget {
  var type;

  SearchSuggestion(this.type);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _SearchSuggestionState();
  }
}

class _SearchSuggestionState extends State<SearchSuggestion> {
  List<Asset> hots = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        this.widget.type == 'tv'
            ? Padding(
                padding: const EdgeInsets.only(left: 17.0, top: 5.0),
                child: Text(
                  '热搜榜',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              )
            : Container(),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, i) {
              return GestureDetector(
                child: Padding(
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 25,
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        color: getColor(i + 1),
                        child: Align(
                          child: Text(
                            (i + 1).toString(),
                            style: TextStyle(fontSize: 13, color: Colors.white),
                          ),
                          alignment: Alignment.center,
                        ),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Text(
                        hots[i].name,
                        style: TextStyle(fontSize: 15, color: Colors.black87),
                      )
                    ],
                  ),
                  padding: const EdgeInsets.only(top: 15),
                ),
                onTap: () async {
                  var data = [];
                  Response response = await Util(context)
                      .http()
                      .get('${Common.movieDomain}movies/${hots[i].v_url}');
                  data.add(response.data);
                  data.add(hots[i]);
                  Router.push(context, Router.movieDetailPage, data);
                },
              );
            },
            itemCount: hots.length,
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (this.widget.type == 'tv') {
      getHot();
    }
  }

  getHot() async {
    Response response = await Util(null).http().get('${Common.movieDomain}hot');
    List data = response.data;
    data.forEach((f) {
      hots.add(new Asset.fromJson(f));
    });
    if (mounted) {
      setState(() {});
    }
  }

  getColor(int i) {
    switch (i) {
      case 1:
        return Colors.deepOrange;
        break;
      case 2:
        return Colors.deepOrangeAccent;
        break;
      case 3:
        return Colors.orangeAccent;
        break;
      default:
        return Colors.grey;
        break;
    }
  }
}

class SerarchScen extends StatefulWidget {
  String word;
  String type;

  SerarchScen(this.word, this.type);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
//    return _IndexCateState(cate, data);
    return _SerarchScenState();
  }
}

class _SerarchScenState extends State<SerarchScen>
    with AutomaticKeepAliveClientMixin {
  var data = [];

  var page = 1;
  Widget body;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataByWord();
  }

  void _onRefresh() async {
    data = [];
    page = 0;
    getDataByWord();
    if (mounted) {
      setState(() {});
    }
    _refreshController.refreshCompleted();
  }

  getDataByWord() async {
    var url =
        '${Common.movieDomain}movies/${this.widget.word}/search/$page/${this.widget.type}';
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
    getDataByWord();
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
        mainAxisSpacing: 5.0,
        //GridView内边距
        padding: EdgeInsets.all(5.0),
        //一行的Widget数量
        crossAxisCount: 3,
        //子Widget宽高比例
        childAspectRatio: 1 / 2,
        cacheExtent: 400.0,
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
