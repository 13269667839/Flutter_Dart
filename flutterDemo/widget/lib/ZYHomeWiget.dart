import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

class ZYHomeWiget extends StatefulWidget {
  @override
  _ZYHomeWigetState createState() => _ZYHomeWigetState();
}

class _ZYHomeWigetState extends State<ZYHomeWiget> {
  bool toggle = true;
  void _toggel() {
    setState(() {
      toggle = !toggle;
    });
  }

  _getToggleChild() {
    if (toggle) {
      return Text("Toggle One");
    } else {
      return CupertinoButton(
        onPressed: (){
        },
        child: Text("Toggle Two"),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ZYHomeWiget"),
        ),
        body: ListView(
          children: <Widget>[
            getGoBackBtn(context),
            cuperBtn,
            _getToggleChild(),
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
