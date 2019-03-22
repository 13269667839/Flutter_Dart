library todo;

import 'dart:math';

class Todo {
  final String who;
  final String what;
  const Todo(this.who, this.what);
}

class MacBook {
  Point p;
  // 编译器确定的常量
  static const pointAndLine = const {
    'point': const [const Point(0, 0)],
    'line': const [const Point(1, 10), const Point(-2, 11)],
  };

  // constructors 构造函数
  // MacBook (Point p) {
  //   //当变量名称冲突时写个this，不冲突时可以省略不写
  //   this.p = p;
  // }
  //语法糖写法
  // MacBook(this.p);
  MacBook({this.p});

  //Use a named constructor to implement multiple constructors for a class or to provide extra clarity
  MacBook.origen() {
    p = Point(0, 0);
  }

  testFunction() {
    var tc = TestCalss();
    tc.test();

    this.p = Point(2, 2);

    num dis = this.p.distanceTo(Point(4, 4));

    print(dis.runtimeType);
    var ss = MacBook.pointAndLine['line'][1].y;
    print(ss);

    print("自己的类型是:${this.runtimeType}");
  }
}

abstract class Doer {
  //抽象类不能实例化
  //抽象类定义一些方法
  void doSomething();
}

class EffcitiveDoer extends Doer {
  void doSomething() {
    print('implemetation for doSomething');
  }

  void effcitiveMethod() {
    print('effcitiveMethod');
  }
}

//implicit interfaces 想用EffcitiveDoer，但是不想继承该
class myDoer implements EffcitiveDoer {
  void doSomething() {
    print('myDoer implemetation for doSomething');
  }

  void effcitiveMethod() {
    print('myDoer effcitiveMethod');
  }
}

//overridable operators
class Vector {
  final int x, y;

  Vector(this.x, this.y);
  // Vector({this.x,this.y});

  Vector operator +(Vector v) => Vector(x + v.x, y + v.y);
  Vector operator -(Vector v) => Vector(x - v.x, y - v.y);

  onSuchMethod(Invocation invocation) {
    print('You tried to use a non-existent member: ' +
        '${invocation.memberName}');
  }
}

enum Color { red, green, blue }

List<Color> colors = Color.values;

//Adding features to a class: mixins
//在多个继承层级上复用类的代码

//Using generic methods
T first<T>(List<T> ts) {
  if (ts.isEmpty) {
    return null;
  }
  // Do some initial work or error checking, then...
  T tmp = ts[0];
  // Do some additional checking or processing...
  return tmp;
}

//异步问题
Future checkVersion() async {
  var version;
  try {
    version = await lookUpVersion();
    // Do something with version
  } catch (e) {
    // React to inability to look up the version
  }

  print(version);
  version = asy_lookUpVersion();
  print(version);
}

String lookUpVersion() => "1.0.0";
Future<String> asy_lookUpVersion() async => "asy_1.0.0";

//生成器
Iterable<int> naturalsTo(int n) sync* {
  //同步
  int k = 0;
  while (k < n) yield k++;
}

Stream<int> asynchronousNaturalsTo(int n) async* {
  //异步
  int k = 0;
  while (k < n) yield k++;
}

Iterable<int> naturalsDownFrom(int n) sync* {
  //同步递归
  if (n > 0) {
    yield n;
    yield* naturalsDownFrom(n - 1);
  }
}

//可调用类 callable class
class WannabeFunction {
  call(String a, String b, String c) => '$a $b $c!';
}

//typedefs
typedef int Compare(Object a, Object b);
typedef double Compare_T<T>(T a, T b);

int sort(Object a, Object b) {
  return 88;
}

double d_sort(double a, double b) => a + b;

class SortedCollection {
  // Compare_T compare;
  // SortedCollection(this.compare);

  //简化写法
  Compare compare;
  SortedCollection(this.compare);

  //初始写法
  // Function compare;
  // SortedCollection(int f(Object a,Object b)){
  //   compare = f;
  // }
}

//Metadata @deprecated @override
class Television {
  /// _Deprecated: Use [turnOn] instead
  @deprecated
  void activate() {
    turnOn();
  }
  

  /// Turns the TV`s power on.
  void turnOn() {
    print("TV power on");
  }
}

@Todo("seth", "make this do something")
void doSomething() {
  print("do something");
}

class TestCalss {
  void test() {
    SortedCollection coll = SortedCollection(sort);
    print(coll.compare);
    assert(coll.compare is Function);
    assert(coll.compare is Compare);
    print(coll.compare(4.5, 6.1));

    var wf = new WannabeFunction();
    wf("2", "4", "5");
    var out = wf("Hi", "there,", "gang");
    print('$out');

    var a = naturalsTo(5);
    for (var s in a) {
      print(s);
    }

    var b = asynchronousNaturalsTo(5);
    print(b);

    checkVersion();
    //泛型
    var names11 = List<String>();
    names11.addAll(["1", "2", "3"]);

    print(colors);

    var tempDoer = EffcitiveDoer();
    tempDoer.doSomething();

    final v = Vector(2, 3);
    final w = Vector(2, 2);
    var vw = v - w;
    print("${vw.x},${vw.y}");
  }
}
