import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/animation.dart';

class ZYDetailWiget extends StatefulWidget {
  String detailTitle;

  //构造方法
  ZYDetailWiget({Key key, @required this.detailTitle}) : super(key: key);

  @override
  _ZYDeatilWigetState createState() =>
      _ZYDeatilWigetState(detailTitle: detailTitle);
}

class _ZYDeatilWigetState extends State<ZYDetailWiget>
    with SingleTickerProviderStateMixin {
  String detailTitle;
  ScrollController _detailScrlCtr;
  _ZYDeatilWigetState({this.detailTitle}) : super();

  Animation<double> logoAnima;
  AnimationController logoAnimaCtr;
  double pix = 0;
  bool isBig = false;
  @override
  void initState() {
    super.initState();

    //滑动相关
    _detailScrlCtr = ScrollController();
    _detailScrlCtr.addListener(() {
      setState(() {
        pix = _detailScrlCtr.position.pixels;
      });
    });

    //动画相关
    logoAnimaCtr =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _changeLogoAni();
  }

  _changeLogoAni() {
    logoAnima = Tween<double>(begin: 100, end: 300).animate(logoAnimaCtr)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed) {
          logoAnimaCtr.reverse();
        } else if (s == AnimationStatus.dismissed) {
          logoAnimaCtr.forward();
        }
      });

    logoAnimaCtr.forward();
  }

  _getAnimationChild() {
    return GestureDetector(
      onTap: () {
        _changeLogoAni();
        print("objectddd");
      },
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          height: logoAnima.value,
          width: logoAnima.value,
          child: FlutterLogo(),
        ),
      ),
    );
  }

  /**
   * Animation, a core class in Flutter’s animation library, interpolates the values used to guide an animation.
   * An Animation object knows the current state of an animation (for example, whether it’s started, stopped, or moving forward or in reverse), but doesn’t know anything about what appears onscreen.
   * An AnimationController manages the Animation.
   * A CurvedAnimation defines progression as a non-linear curve.
   * A Tween
   */
  _testForAnimation() {
    AnimationController ctr = AnimationController(
      duration: const Duration(seconds: 2),
    );
    CurvedAnimation aaa = CurvedAnimation(parent: ctr, curve: Curves.easeIn);
    Tween tw = Tween(begin: -200, end: 0);

    ColorTween cTw =
        ColorTween(begin: Color(0xFFFFFFFF), end: Color(0xFFdf3031));

    tw.animate(aaa);
  }

  double leftGap = 15;

  _getGrayLineView() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      height: 7,
      decoration: BoxDecoration(color: Color(0xFFF0F0F0)),
    );
  }

  //图片
  _getHeadImagePart(double screen_w, bool isOver) {
    double abs = 1;
    double imgHeight = screen_w * 0.7;
    if (pix < 0) {
      abs = (-pix + imgHeight) / imgHeight;
    } else {}

    if (isOver) {
      return Container(
        width: screen_w * abs,
        height: imgHeight * abs,
        child: Image.asset('images/lake.png', fit: BoxFit.fill),
      );
    } else {
      return Container(
        width: screen_w,
        height: imgHeight,
        child: Image.asset('images/lake.png', fit: BoxFit.fill),
      );
    }
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

  getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  _getListView(BuildContext context) {
    double screen_w = getScreenWidth(context);

    ListView ls = ListView(
      children: <Widget>[
        _getHeadImagePart(screen_w, false),
        _getTitlePart(),
        _getAnimationChild(),
        _getTextField(),
        
      ],
      controller: _detailScrlCtr,
    );

    return ls;
  }

  _getOver() {
    if (pix < 0) {
      return OverflowBox(
        alignment: Alignment.topCenter,
        maxWidth: getScreenWidth(context) * 10,
        maxHeight: getScreenWidth(context) * 0.7 * 10,
        child: _getHeadImagePart(getScreenWidth(context), true),
      );
    } else {
      return SizedBox(
        width: 0,
        height: 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("${pix.toStringAsFixed(6)}"),
      ),
      body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // 触摸收起键盘
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Stack(
            children: <Widget>[
              _getListView(context),
              _getOver(),
            ],
          )),
    );
  }

  @override
  void dispose() {
    logoAnimaCtr.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
