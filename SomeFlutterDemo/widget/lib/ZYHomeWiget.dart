import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'ZYListWiget.dart';
import 'package:http/http.dart' as http;
import 'ZYShopListWiget.dart';

class ZYHomeWiget extends StatefulWidget {
  @override
  _ZYHomeWigetState createState() => _ZYHomeWigetState();
}

class _ZYHomeWigetState extends State<ZYHomeWiget> {
  bool toggle = true;

  //isolate 不能共享内存
  loadData() async {
    ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(dataLoader, receivePort.sendPort);

    // The 'echo' isolate sends its SendPort as the first message
    SendPort sendPort = await receivePort.first;

    List msg = await sendReceive(
        sendPort, "https://jsonplaceholder.typicode.com/posts");

    setState(() {});
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

  void _toggel() {
    setState(() {
      toggle = !toggle;
    });
  }

  _getZFListChild(BuildContext context) {
    return CupertinoButton(
      color: Colors.green,
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ZYListWiget()));
      },
      child: Text("跳转到列表页"),
    );
  }

  _getCuperBtn(BuildContext context) => Center(
        child: MaterialButton(
          color: Colors.red,
          onPressed: () {
            print("点击了按钮");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShoppingList(products: [
                          Product(name: "egg"),
                          Product(name: "Flour"),
                          Product(name: "egg"),
                          Product(name: "egg")
                        ])));
          },
          child: Text("跳转到ShoppingList页"),
          padding: EdgeInsets.only(left: 10, right: 10),
        ),
      );

  Widget _getGoBackBtn(BuildContext context) {
    return Center(
      child: RaisedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          "Go Back!!",
          style: TextStyle(color: toggle == true ? Colors.red : Colors.blue),
        ),
      ),
    );
  }

  _getGrideViewBtn(BuildContext contex) {
    return CupertinoButton(
      onPressed: () {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => GridListDemo()));
      },
      child: Text("跳转到GrideView"),
    );
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
          _getGoBackBtn(context),
          _getCuperBtn(context),
          _getGrideViewBtn(context),
          _getZFListChild(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggel,
        tooltip: "Update Text",
        child: Icon(Icons.update),
      ),
    );
  }
}
