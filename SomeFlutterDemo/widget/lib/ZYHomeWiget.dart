import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'ZYDetailWiget.dart';
import 'package:http/http.dart' as http;

class ZYHomeWiget extends StatefulWidget {
  @override
  _ZYHomeWigetState createState() => _ZYHomeWigetState();
}

class _ZYHomeWigetState extends State<ZYHomeWiget> {
  bool toggle = true;
  List _widgets = [];

  double img_W = 112;
  double img_H = 84;
  double lineGap = 5;

  getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  void _toggel() {
    setState(() {
      toggle = !toggle;
    });
  }

  _sendHttpRequest() async {
    String dataURL = "http://10.2.105.186:8675/flutterJson.json";
    http.Response response = await http.get(dataURL);
    setState(() {
      //增加解析中文
      Utf8Decoder dec = Utf8Decoder();
      _widgets = json.decode(dec.convert(response.bodyBytes));
      //没法解析中文
      // _widgets =json.decode(response.body);
    });
  }

  _getToggleChild() {
    if (!toggle) {
      return Text("Toggle One");
    } else {
      return CupertinoButton(
        onPressed: () {
          _sendHttpRequest();
        },
        child: Text("Tap and send HttpRequest"),
      );
    }
  }

  Widget getListView(BuildContext context) {
    if (_widgets.length > 0) {
      return Expanded(
        child: Container(
          decoration: BoxDecoration(color: Colors.yellow),
          child: ListView.builder(
              itemCount: _widgets.length,
              itemBuilder: (BuildContext context, int position) {
                final double screen_W = getScreenWidth(context);
                return GestureDetector(
                  child: getRow(position, screen_W),
                  onTap: () {
                    print("点击了第${position}条");

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ZYDetailWiget(
                                  detailTitle: _widgets[position]["title"],
                                )));
                  },
                );
              }),
        ),
      );
    } else {
      // return getProgressDialog();
      return Text("data");
    }
  }

  getProgressDialog() {
    return Center(child: CircularProgressIndicator());
  }

  Widget getRow(int i, double screen_W) {
    //左侧图片
    var img = Container(
        width: img_W,
        height: img_H,
        child: Image.network(_widgets[i]["titleimage"]));

    //标题行
    var titleLine = Text("${_widgets[i]["title"]}",
        maxLines: 2,
        style: TextStyle(
          backgroundColor: Colors.green,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ));

    var detailFontStyle = TextStyle(
      backgroundColor: Colors.blue,
      fontSize: 12,
    );

    //第二行
    var secondLine = Container(
      margin: EdgeInsets.only(top: lineGap),
      child: Text(
        "${_widgets[i]["secondLine"]}",
        maxLines: 1,
        style: detailFontStyle,
      ),
    );

    //第三行
    var thirdLine = Container(
      margin: EdgeInsets.only(top: lineGap),
      child: Text(
        "${_widgets[i]["address"]}",
        maxLines: 1,
        style: detailFontStyle,
      ),
    );

    //标签行
    getTagsLine() {
      String tags = _widgets[i]["tags"];

      tags = tags != null ? tags : "";

      List tagList = tags.split(" ");
      tagList.remove("");

      if (tagList.length > 0) {
        List<Widget> tagWigets = [];
        for (String tag in tagList) {
          var con = Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              // border: Border.all(color: Color(3)),
              borderRadius: BorderRadius.all(Radius.circular(3)),
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
          color: Colors.yellow,
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
    getPirceLine() {
      String tags = _widgets[i]["price"];
      return Container(
        margin: EdgeInsets.only(top: lineGap + 2),
        color: Colors.purple,
        child: Text(
          tags,
          style: TextStyle(fontSize: 15),
        ),
      );
    }

    //右侧整体
    var col = Container(
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      width: screen_W - img_W - 40,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          titleLine,
          secondLine,
          thirdLine,
          getTagsLine(),
          getPirceLine()
        ],
      ),
    );

    //row整体
    return Container(
        padding: EdgeInsets.fromLTRB(20, 18, 20, 0),
        decoration: BoxDecoration(color: Colors.red),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[img, col],
            ),
            Container(
              margin: EdgeInsets.only(top: 18),
              height: .5,
              color: Colors.grey,
            )
          ],
        ));
  }

  //isolate 不能共享内存
  loadData() async {
    ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(dataLoader, receivePort.sendPort);

    // The 'echo' isolate sends its SendPort as the first message
    SendPort sendPort = await receivePort.first;

    List msg = await sendReceive(
        sendPort, "https://jsonplaceholder.typicode.com/posts");

    setState(() {
      _widgets = msg;
    });
  }

  // The entry point for the isolate
  static dataLoader(SendPort sendPort) async {
    // Open the ReceivePort for incoming messages.
    ReceivePort port = ReceivePort();

    // Notify any other isolates what port this isolate listens to.
    sendPort.send(port.sendPort);

    await for (var msg in port) {
      String data = msg[0];
      SendPort replyTo = msg[1];

      String dataURL = data;
      http.Response response = await http.get(dataURL);
      // Lots of JSON to parse
      replyTo.send(json.decode(response.body));
    }
  }

  Future sendReceive(SendPort port, msg) {
    ReceivePort response = ReceivePort();
    port.send([msg, response.sendPort]);
    return response.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ZYHomeWiget"),
      ),
      // body: getListView(context),
      body: Column(
        children: <Widget>[
          getGoBackBtn(context),
          cuperBtn,
          _getToggleChild(),
          getListView(context)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggel,
        tooltip: "Update Text",
        child: Icon(Icons.update),
      ),
    );
  }

  var cuperBtn = Center(
    child: MaterialButton(
      onPressed: () {
        print("点击了按钮");
      },
      child: Text("Hello"),
      padding: EdgeInsets.only(left: 10, right: 10),
    ),
  );

  Widget getGoBackBtn(BuildContext context) {
    return Center(
      child: RaisedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text("Go Back!!"),
      ),
    );
  }
}
