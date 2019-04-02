import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class ZYDetailWiget extends StatefulWidget {

  String detailTitle;

  //构造方法  
  ZYDetailWiget({Key key, @required this.detailTitle}) : super(key: key);

  @override
  _ZYDeatilWigetState createState() => _ZYDeatilWigetState(detailTitle: detailTitle);
}


class _ZYDeatilWigetState extends State<ZYDetailWiget> {

  String detailTitle;
  _ZYDeatilWigetState({this.detailTitle}) : super();

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
          )
        ],
      ),
    );
  }
}
