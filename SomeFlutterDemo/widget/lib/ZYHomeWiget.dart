import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
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
                return getRow(position, screen_W);
              }),
        ),
      );
    } else {
      return getProgressDialog();
    }
  }

  getProgressDialog() {
    return Center(child: CircularProgressIndicator());
  }

  Widget getRow(int i, double screen_W) {
    var img = Container(
        width: img_W,
        height: img_H,
        child: Image.network(_widgets[i]["titleimage"]));

    var col = Container(
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      width: screen_W - img_W - 40,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "${_widgets[i]["title"]}",
            maxLines: 2,
            style: TextStyle(backgroundColor: Colors.green),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              "${_widgets[i]["secondLine"]}",
              maxLines: 1,
              style: TextStyle(backgroundColor: Colors.orange),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              "${_widgets[i]["address"]}",
              maxLines: 1,
              style: TextStyle(backgroundColor: Colors.blue),
            ),
          ),
        ],
      ),
    );

    return Container(
        padding: EdgeInsets.fromLTRB(20, 18, 20, 18),
        decoration: BoxDecoration(color: Colors.red),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[img, col],
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
        // setState(() {

        // });
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
