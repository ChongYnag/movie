import 'package:PureBook/common/Screen.dart';
import 'package:PureBook/common/common.dart';
import 'package:PureBook/common/util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../router.dart';

class MovieDetail extends StatefulWidget {
  var asset;

  MovieDetail(this.asset);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MovieDetailState();
  }
}

class _MovieDetailState extends State<MovieDetail> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white12,
          automaticallyImplyLeading: true,
          elevation: 0,
          title: Text(
            this.widget.asset[1].name,
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(
                          left: 10.0, top: 10.0, bottom: 10.0),
                      child: CachedNetworkImage(
                        imageUrl: this.widget.asset[1].cover,
                        height: 220,
                        width: 140,
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    Container(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        height: 220,
                        width: Screen.width - 170,
                        child: ListView(
                          shrinkWrap: true,
                          children: <Widget>[
                            Text(this.widget.asset[0][0]),
                          ],
                        ))
                  ],
                )
              ]),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(left: 17.0, top: 5.0),
                child: Text(
                  '在线播放',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 17.0, top: 5.0),
                child: Wrap(
                  spacing: 2, //主轴上子控件的间距
                  runSpacing: 5, //交叉轴上子控件之间的间距
                  children: Boxs(),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(left: 17.0, top: 15.0),
                child: new Text(
                  '剧情简介',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 17.0, top: 15.0),
                child: Text(
                  this.widget.asset[0][2],
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(left: 17.0, top: 15.0),
                child: new Text(
                  '影片截图',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              GridView.count(
                physics: new NeverScrollableScrollPhysics(),
                children: getPicList(),
                shrinkWrap: true,
                //水平子Widget之间间距
                crossAxisSpacing: 10.0,
                //垂直子Widget之间间距
                mainAxisSpacing: 5.0,
                //GridView内边距
                padding: EdgeInsets.all(10.0),
                //一行的Widget数量
                crossAxisCount: 2,
                //子Widget宽高比例
                childAspectRatio: 1,
              )
            ],
          ),
        ));
  }

  List<Widget> Boxs() {
    List<Widget> wds = [];
    List x = List.of(this.widget.asset[0][1]);
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
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () async {
            var type;
            if (this.widget.asset[1].v_url.endsWith('.htm')) {
              type = 'tv';
            } else {
              type = 'movie';
            }
            var url =
                '${Common.movieDomain}movies/${Map.castFrom(x[i]).keys.toList()[0]}/$type';
            Response response = await Util(context).http().get(url);

            List data = response.data;
            data.add(this.widget.asset[1].name);
            data.add(this.widget.asset[0][1]);
            data.add(i);
            data.add(type);

            Router.push(context, Router.lookVideoPage, data);
          },
        ),
      ));
    }

    return wds;
  }

  getPicList() {
    List<Widget> wds = [];
    List.castFrom(this.widget.asset[0][3]).forEach((f) {
      wds.add(CachedNetworkImage(
        imageUrl: f,
        fit: BoxFit.fill,
      ));
    });
    return wds;
  }
}
