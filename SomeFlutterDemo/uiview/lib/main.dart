import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState(_a);
}

const String _a = 'I like Flutter';
const String _b = 'Flutter is Awesome';

class _MyHomePageState extends State<MyHomePage> {
  String _textToShow;

  _MyHomePageState(String a) {
    this._textToShow = a;
  }

  void _updateText() {
    setState(() {
      if (_textToShow == _a) {
        _textToShow = _b;
      } else {
        _textToShow = _a;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: new Center(
        child: new Text(
          _textToShow,
          style: new TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.purple,
        onPressed: _updateText,
        tooltip: 'Update Text',
        child: Icon(Icons.update),
      ),
    );
  }
}
