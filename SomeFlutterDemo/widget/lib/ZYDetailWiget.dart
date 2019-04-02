import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ZYDetailWiget extends StatefulWidget {
  String detailTitle;

  //构造方法
  ZYDetailWiget({Key key, @required this.detailTitle}) : super(key: key);

  @override
  _ZYDeatilWigetState createState() =>
      _ZYDeatilWigetState(detailTitle: detailTitle);
}

class _ZYDeatilWigetState extends State<ZYDetailWiget> {
  String detailTitle;
  _ZYDeatilWigetState({this.detailTitle}) : super();

  //输入框
  final myController = TextEditingController();

  _getTextField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange,
      ),
      margin: EdgeInsets.only(left: 10, right: 10),
      child: TextField(
        decoration: InputDecoration(hintText: "请输入"),
        controller: myController,
      ),
    );
  }

  bool isEmail(String emailString) {
    String emailRegexp =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(emailRegexp);

    return regExp.hasMatch(emailString);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("详情页"),
      ),
      body: ListView(
        children: <Widget>[
          Center(
            child: Text(detailTitle),
          ),
          _getTextField()
        ],
      ),
    );
  }
}
