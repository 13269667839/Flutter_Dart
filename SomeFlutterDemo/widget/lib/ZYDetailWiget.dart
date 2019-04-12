import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/animation.dart';

typedef DetailOnTap = void Function();

class InfoModel {
  InfoModel({this.key, this.value, this.onTap});

  String key;
  String value;
  DetailOnTap onTap;
}

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
  bool isStar = false;

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
        // if (s == AnimationStatus.completed) {
        //   logoAnimaCtr.reverse();
        // } else if (s == AnimationStatus.dismissed) {
        //   logoAnimaCtr.forward();
        // }
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

  _getGrayLineView({double h, double w, double mL, double mR}) {
    return Container(
      margin: EdgeInsets.only(
          top: leftGap, left: mL == null ? 0 : mL, right: mR == null ? 0 : mR),
      height: h == null ? 7 : h,
      decoration: BoxDecoration(color: Color(0xFFF0F0F0)),
    );
  }

  _getSeparateLineView() {
    return Container(
      margin: EdgeInsets.only(top: leftGap, bottom: leftGap),
      width: 0.5,
      decoration: BoxDecoration(color: Color(0xFFF0F0F0)),
    );
  }

  //图片
  _getHeadImagePart(double screen_w, bool isOver) {
    double abs = 1;
    double imgHeight = screen_w * 0.7;
    if (pix < 0) {
      abs = (-pix + imgHeight) / imgHeight;
    } else {
      abs = ((imgHeight + 20) - pix) / (imgHeight + 20);
    }

    if (isOver) {
      return Container(
        width: screen_w * abs + 20 * 10 / 7,
        height: imgHeight * abs + 20,
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
        "发布时间  2019-04-10 11:11:11",
        style: TextStyle(color: Color(0xFF999D9E)),
        textAlign: TextAlign.left,
      )),
    );

    _getSingleText(String txt) {
      return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFFD8181), width: 0.5),
            borderRadius: BorderRadius.all(Radius.circular(2))),
        margin: EdgeInsets.only(right: 9),
        padding: EdgeInsets.only(left: 5, right: 7),
        child: Text(
          txt,
          style: TextStyle(fontSize: 11, color: Color(0xFFFD8181)),
        ),
      );
    }

    List tagList = ["交通便利", "近地铁", "一家人"];
    List<Widget> tagWidget = [];
    for (var txt in tagList) {
      tagWidget.add(_getSingleText(txt));
    }

    var tags = Container(
      margin: EdgeInsets.fromLTRB(leftGap, 8, leftGap, 0),
      child: Row(
        children: tagWidget,
      ),
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

  _getPricePart() {
    _getSingleP(String key, String value) {
      return Expanded(
        flex: 1,
        child: Column(
          children: <Widget>[
            Text(
              key,
              style: TextStyle(color: Color(0xFF999D9E), fontSize: 16),
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              child: Text(
                value,
                style: TextStyle(
                    color: Color(0xFFDF3031),
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            )
          ],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.only(top: leftGap),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              _getSingleP("租金", "12.8万元/月"),
              _getSingleP("单价", "5.33元/㎡.天"),
              _getSingleP("面积", "800㎡"),
            ],
          ),
          _getGrayLineView(h: 0.5, mL: leftGap, mR: leftGap)
        ],
      ),
    );
  }

  _getDetailInfoPart() {
    InfoModel m = InfoModel(key: "使用面积：", value: "720㎡");

    Map<String, String> deMap = {
      "使用面积：": "720㎡",
      "起 租 期：": "2019",
      "支付方式：": "押一付三",
      "物 业 费：": "3元/㎡.月（租金已包含）",
      "楼     层：": "低层/21层",
      "是否分割：": "不可分割",
      "类型：": "纯写字楼",
      "等级：": "甲级",
      "建筑年代：": "2018",
      "区域：": "丰台大葆台",
      "楼盘名：": "建工汇豪商务广场",
      "物业公司：": "龙湖物业",
      "委托编号：": "400829476156",
      "委托书：": "已上传",
    };

    List<InfoModel> models = [];
    deMap.forEach((k, v) {
      if (k == "楼盘名：") {
        models.add(InfoModel(
            key: k,
            value: v,
            onTap: () {
              print("点击了楼盘名");
            }));
      } else if (k == "委托书：") {
        models.add(InfoModel(
            key: k,
            value: v,
            onTap: () {
              print("点击了委托书");
            }));
      } else {
        models.add(InfoModel(key: k, value: v));
      }
    });

    List<Widget> deLi = [];
    for (var item in models) {
      var sg = Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10),
            width: 80,
            child: Text(
              item.key,
              style: TextStyle(color: Color(0xFF999D9E), fontSize: 16),
            ),
          ),
          GestureDetector(
            onTap: item.onTap,
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                item.value,
                style: TextStyle(
                    color: item.onTap == null
                        ? Color(0xFF394043)
                        : Color(0xFF7D9CB2),
                    fontSize: 16),
              ),
            ),
          )
        ],
      );
      deLi.add(sg);
    }
    
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 5, left: leftGap, right: leftGap),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: deLi,
          ),
        ),
        _getGrayLineView()
      ],
    );
  }

  _getListView(BuildContext context) {
    double screen_w = getScreenWidth(context);

    ListView ls = ListView(
      children: <Widget>[
        _getHeadImagePart(screen_w, false),
        _getTitlePart(),
        _getPricePart(),
        _getDetailInfoPart(),
        _getAnimationChild(),
      ],
      controller: _detailScrlCtr,
    );

    return ls;
  }

  _getOver() {
    if (pix <= 20) {
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

  _getCustomNaviBar() {
    double ooo = 1;
    Color bc = Colors.transparent;
    Color iconC = Colors.white;

    if (pix <= 0) {}
    if (pix > 0 && pix <= 64) {
      ooo = pix / 64;
      bc = Color.fromRGBO(255, 255, 255, ooo);
      iconC = Color.fromRGBO(0, 0, 0, ooo);
    } else if (pix > 64) {
      ooo = 0;
      bc = Colors.white;
      iconC = Colors.black;
    }
    // print("toolbarOpacity:$ooo");
    // print("backgroundColor:$bc");

    return SizedBox(
      width: getScreenWidth(context),
      height: 64,
      child: AppBar(
        // toolbarOpacity: ooo,
        iconTheme: IconThemeData(color: iconC),
        actions: <Widget>[
          IconButton(
              icon: Icon(isStar ? Icons.star : Icons.star_border),
              tooltip: 'Open shopping cart',
              onPressed: () {
                setState(() {
                  isStar = !isStar;
                });
              }),
          IconButton(
              icon: Icon(Icons.chat),
              tooltip: 'Open shopping cart',
              onPressed: () {}),
          IconButton(
              icon: Icon(Icons.share),
              tooltip: 'Open shopping cart',
              onPressed: () {
                // Implement navigation to shopping cart page here...
                print('Shopping cart opened.');
              }),
        ],
        backgroundColor: bc,
        elevation: 0,
        // title: Text(
        //   "${pix.toStringAsFixed(6)}",
        //   style: TextStyle(color: iconC),
        // ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      // backgroundColor: Colors.transparent,
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   title: Text("${pix.toStringAsFixed(6)}"),
      // ),
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
              _getCustomNaviBar()
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
