import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import "ZYShopListWiget.dart";

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

  double leftGap = 15;

  _getGrayLineView() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      height: 7,
      decoration: BoxDecoration(color: Color(0xFFF0F0F0)),
    );
  }

  //图片
  _getHeadImagePart() {
    return Image.asset('images/lake.png', fit: BoxFit.fitWidth);
  }

  _getTextLine({Widget child}) {
    if (child is Widget) {
      return Row(
        children: <Widget>[
          Expanded(
            child: child,
          )
        ],
      );
    } else {
      return SizedBox(
        height: 0,
        width: 0,
      );
    }
  }

  _getTitlePart() {
    var title = Container(
      margin: EdgeInsets.fromLTRB(leftGap, 18, leftGap, 0),
      child: _getTextLine(
          child: Text(
        detailTitle,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 20,
          color: Color(0xFF394043),
          fontWeight: FontWeight.w500,
        ),
      )),
    );

    var releaseDate = Container(
      margin: EdgeInsets.fromLTRB(leftGap, 8, leftGap, 0),
      child: _getTextLine(
          child: Text(
        "发布时间",
        textAlign: TextAlign.left,
      )),
    );

    var tags = Container(
      margin: EdgeInsets.fromLTRB(leftGap, 8, leftGap, 0),
      child: _getTextLine(child: Text("交通便利")),
    );

    return Column(
      children: <Widget>[title, releaseDate, tags, _getGrayLineView()],
    );
  }

  _getTextField() {
    //输入框
    final myController = TextEditingController();
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange,
      ),
      margin: EdgeInsets.fromLTRB(leftGap, 10, leftGap, 0),
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
      body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // 触摸收起键盘
            FocusScope.of(context).requestFocus(FocusNode());
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShoppingList(products: [
                          Product(name: "egg"),
                          Product(name: "egg"),
                          Product(name: "egg"),
                          Product(name: "egg")
                        ])));
          },
          child: ListView(
            children: <Widget>[
              _getHeadImagePart(),
              _getTitlePart(),
              _getTextField()
            ],
          )),
    );
  }
}
