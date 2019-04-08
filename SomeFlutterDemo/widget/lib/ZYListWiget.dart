import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'ZYDetailWiget.dart';
import 'package:http/http.dart' as http;

class ZYListWiget extends StatefulWidget {
  @override
  _ZYListWigetState createState() => _ZYListWigetState();
}

class _ZYListWigetState extends State<ZYListWiget> {
  List _widgets = [];
  ScrollController _scrollController = ScrollController(); //listview的控制器
  double img_W = 112;
  double img_H = 84;
  double lineGap = 5;
  int page = 1;
  bool isRequesting = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _sendHttpRequest();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!isRequesting) {
          page++;
          print('滑动到了最底部,请求第$page页');
          _sendHttpRequest();
        }
      }
    });
  }

  getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  List _paserJsonData(http.Response response) {
    List tList = [];
    if (response is http.Response) {
      //增加解析中文
      Utf8Decoder dec = Utf8Decoder();
      tList = json.decode(dec.convert(response.bodyBytes));
      //没法解析中文
      // tList =json.decode(response.body);
    } else {}
    return tList;
  }

  _sendHttpRequest() async {
    isRequesting = true;
    String dataURL = "http://10.2.105.186:8675/flutterJson.json";

    //同步
    http.Response response = await http.get(dataURL);
    isRequesting = false;
    setState(() {
      if (page == 1) {
        _widgets = _paserJsonData(response);
      } else {
        _widgets.addAll(_paserJsonData(response));
      }
    });

    //异步
    // http.get(dataURL).then((Object response) {
    //   isRequesting = false;
    //   setState(() {
    //     _widgets = _paserJsonData(response);
    //   });
    // });
    print("object");
  }

  Widget getListView(BuildContext context) {
    if (_widgets.length > 0) {
      return Container(
        decoration: BoxDecoration(color: Color(0xFFf5f5f5)),
        child: ListView.builder(
          itemCount: _widgets.length,
          itemBuilder: (BuildContext context, int position) {
            // final double screen_W = getScreenWidth(context);
            return GestureDetector(
              child: getRow(position),
              onTap: () {
                print("点击了第${position}条");

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ZYDetailWiget(
                              detailTitle: _widgets[position]["title"],
                            ))).then((Object result) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      String str = result.toString();
                      return new AlertDialog(
                        content: new Text("您返回的内容为:$str"),
                      );
                    },
                  );
                });
              },
            );
          },
          controller: _scrollController,
        ),
      );
    } else {
      return getProgressDialog();
      // return Text("data");
    }
  }

  getProgressDialog() {
    return Center(child: CircularProgressIndicator());
  }

 /**
   * 加载更多时显示的组件,给用户提示
   */
  Widget _getMoreWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '加载中...',
              style: TextStyle(fontSize: 16.0),
            ),
            CircularProgressIndicator(
              strokeWidth: 1.0,
            )
          ],
        ),
      ),
    );
  }

  Widget getRow(int i) {
    String _getAgentCountString() {
      String agc = _widgets[i]["groupAgentCount"];

      agc = agc != null ? agc : "";

      return agc;
    }

    //左侧图片
    _getImageLine() {
      String verityByName = _widgets[i]["verityByName"];
      verityByName = verityByName != null ? verityByName : "";

      Widget nameLabel;
      if ("1" == verityByName) {
        nameLabel = Positioned(
          left: 2,
          top: 2,
          child: Container(
            padding: EdgeInsets.fromLTRB(4, 1, 4, 1),
            decoration: BoxDecoration(
                color: Color(0xFFF84748),
                borderRadius: BorderRadius.all(Radius.circular(2))),
            child: Text(
              "实名认证",
              style: TextStyle(color: Colors.white, fontSize: 11),
            ),
          ),
        );
      } else {
        nameLabel = SizedBox(
          height: 0,
          width: 0,
        );
      }

      return Container(
          width: img_W,
          height: img_H,
          child: Stack(
            children: <Widget>[
              Image.network(_widgets[i]["titleimage"]),
              nameLabel
            ],
          ));
    }

    String ZYSTR(Object input) {
      if (input is String) {
        return input;
      } else {
        return "";
      }
    }

    //标题行
    _getTitleLine() {
      int maxL = _getAgentCountString().length > 0 ? 1 : 2;

      _getSingleText(String text) {
        return Container(
          width: 18,
          height: 18,
          padding: EdgeInsets.fromLTRB(2, 0, 0, 1),
          margin: EdgeInsets.only(left: 5),
          decoration: BoxDecoration(
              color: Color(0xFFdf3031),
              borderRadius: BorderRadius.all(Radius.circular(2))),
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
        );
      }

      //精
      String checked = ZYSTR(_widgets[i]["checked"]);
      Widget cWidget;
      if ("6" == checked) {
        cWidget = _getSingleText("精");
      } else {
        cWidget = SizedBox(
          width: 0,
          height: 0,
        );
      }

      //顶
      String endPayTime = ZYSTR(_widgets[i]["endPayTime"]);
      Widget eWidget;
      if (endPayTime.length > 0) {
        eWidget = _getSingleText("顶");
      } else {
        eWidget = SizedBox(
          width: 0,
          height: 0,
        );
      }

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text("${_widgets[i]["title"]}",
                maxLines: maxL,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Color(0xFF394043),
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                )),
          ),
          eWidget,
          cWidget
        ],
      );
    }

    var detailFontStyle = TextStyle(
      color: Color(0xFF606668),
      fontSize: 12,
    );

    //第二行
    _getSecondLine(){
      return Container(
      margin: EdgeInsets.only(top: lineGap),
      child: Text(
        "${_widgets[i]["secondLine"]}",
        maxLines: 1,
        style: detailFontStyle,
      ),
    );
    }

    //第三行
    _getThirdLine(){
      return Container(
      margin: EdgeInsets.only(top: lineGap),
      child: Text(
        "${_widgets[i]["address"]}",
        maxLines: 1,
        style: detailFontStyle,
      ),
    );
    }

    //第4行
    _getAgentCountLine() {
      String agc = _getAgentCountString();

      if (agc.length > 0) {
        String fourthLine = "共有" + agc + "经纪公司发布";
        return Container(
          margin: EdgeInsets.only(top: lineGap),
          child: Text(
            fourthLine,
            maxLines: 1,
            style: detailFontStyle,
          ),
        );
      } else {
        return Container(
          height: 0,
        );
      }
    }

    //标签行
    _getTagsLine() {
      String tags = _widgets[i]["tags"];

      tags = tags != null ? tags : "";

      List tagList = tags.split(" ");
      tagList.remove("");

      if (tagList.length > 0) {
        List<Widget> tagWigets = [];
        for (String tag in tagList) {
          var con = Container(
            decoration: BoxDecoration(
              color: Color(0xFFf6f6f6),
              // border: Border.all(color: Color(3)),
              borderRadius: BorderRadius.all(Radius.circular(2)),
            ),
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            margin: EdgeInsets.only(right: 5),
            child: Text(
              tag,
              style: detailFontStyle,
            ),
          );

          tagWigets.add(con);
        }

        return Container(
          // color: Colors.yellow,
          margin: EdgeInsets.only(top: lineGap),
          child: Row(
            children: tagWigets,
          ),
        );
      } else {
        return Container(
          height: 0,
        );
      }
    }

    //价格
    _getPirceLine() {
      String price = ZYSTR(_widgets[i]["price"]);
      String priceType = ZYSTR(_widgets[i]["priceType"]);

      return Container(
        margin: EdgeInsets.only(top: lineGap + 2),
        // color: Colors.purple,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              price,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFFdf3031),
                  fontWeight: FontWeight.w500),
            ),
            Text(
              priceType,
              style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFdf3031),
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
      );
    }

    //右侧整体
    var col = Container(
      padding: EdgeInsets.fromLTRB(17, 0, 0, 0),
      // width: screen_W - img_W - 40,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _getTitleLine(),
          _getSecondLine(),
          _getThirdLine(),
          _getAgentCountLine(),
          _getTagsLine(),
          _getPirceLine()
        ],
      ),
    );

    //row整体
    return Container(
        padding: EdgeInsets.fromLTRB(20, 18, 20, 0),
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _getImageLine(),
                Expanded(
                  child: col,
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 18),
              height: .5,
              color: Color(0xFFEEEEEE),
            )
          ],
        ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("列表页"),
      ),
      body: getListView(context),
    );
  }
}
