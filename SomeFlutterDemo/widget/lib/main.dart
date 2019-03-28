import 'package:flutter/material.dart';
import 'ZYHomeWiget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

// double screen_width = MediaQuery.of(context)

    return MaterialApp(
      title: 'Widget Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(title: 'Widget Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    var packedRow = new Container(
      padding: EdgeInsets.only(top: 32, bottom: 10),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Icon(Icons.star, color: Colors.green[500]),
          new Icon(Icons.star, color: Colors.green[500]),
          new Icon(Icons.star, color: Colors.green[500]),
          new Icon(Icons.star, color: Colors.black),
          new Icon(Icons.star, color: Colors.black),
        ],
      ),
    );

    var shuiPingRow = new Row(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Expanded(
          child: Image.asset('images/lake.png'),
        ),
        new Expanded(
          // flex: 2,相比于兄弟的大小
          child: Image.asset('images/lake.png'),
        ),
        new Expanded(
          child: Image.asset('images/lake.png'),
        )
      ],
    );

    var shuZhiColumn = new Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        new Image.asset('images/lake.png'),
        new Image.asset('images/lake.png'),
        new Image.asset('images/lake.png'),
      ],
    );

    var ratings = new Container(
      padding: new EdgeInsets.all(20.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Icon(Icons.star, color: Colors.black),
              new Icon(Icons.star, color: Colors.black),
              new Icon(Icons.star, color: Colors.black),
              new Icon(Icons.star, color: Colors.black),
              new Icon(Icons.star, color: Colors.black),
            ],
          ),
          new Text(
            '170 Reviews',
            style: new TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontFamily: 'Roboto',
              letterSpacing: 0.5,
              fontSize: 20.0,
            ),
          )
        ],
      ),
    );

    //评论
    var descTextStyle = new TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w800,
      fontFamily: 'Roboto',
      letterSpacing: 0.5,
      fontSize: 18.0,
      height: 2.0,
    );
    // DefaultTextStyle.merge可以允许您创建一个默认的文本样式，该样式会被其
    // 所有的子节点继承
    var iconList = DefaultTextStyle.merge(
        style: descTextStyle,
        child: new Container(
          padding: new EdgeInsets.all(20.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Column(
                children: [
                  new Icon(Icons.kitchen, color: Colors.green[500]),
                  new Text('PREP:'),
                  new Text('25 min'),
                ],
              ),
              new Column(
                children: [
                  new Icon(Icons.timer, color: Colors.green[500]),
                  new Text('COOK:'),
                  new Text('1 hr'),
                ],
              ),
              new Column(
                children: [
                  new Icon(Icons.restaurant, color: Colors.green[500]),
                  new Text('FEEDS:'),
                  new Text('4-6'),
                ],
              ),
            ],
          ),
        ));

    var titleText = new Text(
      'Flutter',
      style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
    );

    var subTitle = Column(
      children: <Widget>[
        Text('Flutter是Google一个新的用于构建跨平台的手机App的SDK。写一份代码，在Android 和iOS平台上都可以运行。'),
        Text('在Flutter中，每个应用程序都是Widget，这点和其他的应用框架不一样，Flutter的对象模型是统一的，也就是控件。'),
      ],
    );

    var leftColumn = new Container(
      padding: new EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 20.0),
      child: new Column(
        children: <Widget>[titleText, subTitle, ratings, iconList],
      ),
    );

    var rightImage = new Expanded(
      child: new Image.asset('images/lake.png'),
    );

    var demo1 = new Center(
      child: new Container(
        margin: new EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 30.0),
        height: 600.0,
        child: new Card(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                // width: 400.0,
                child: leftColumn,
              ),
              rightImage
            ],
          ),
        ),
      ),
    );

    //盒模型
    Widget createItem(String imageStr) {
      return new Expanded(
        child: new Container(
          decoration: new BoxDecoration(
              border: new Border.all(width: 10.0, color: Colors.black38),
              borderRadius: const BorderRadius.all(const Radius.circular(8.0))),
          margin: const EdgeInsets.all(4.0),
          child: new Image.asset(imageStr),
        ),
      );
    }

    var fourPic = new Container(
      decoration: new BoxDecoration(
        color: Colors.black26,
      ),
      child: new Column(
        children: <Widget>[
          new Row(
            children: <Widget>[
              createItem('images/lake.png'),
              createItem('images/lake.png'),
            ],
          ),
          new Row(
            children: <Widget>[
              createItem('images/lake.png'),
              createItem('images/lake.png'),
            ],
          )
        ],
      ),
    );

    //GridView
    // var myGV = new GridView(

    // );

    var pushButton = new RaisedButton(
      child: Text("Push Next Page!"),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ZYHomeWiget()));
      },
    );

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: new ListView(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          pushButton,
          demo1,
          shuiPingRow,
          packedRow,
          shuZhiColumn,
          fourPic,
        ],
      ),
    );
  }
}
