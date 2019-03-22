import 'dart:math';
import 'MacBook.dart';

void testPrint() {
  var iPhoneXsMax = 12799;
  var count = 2;

  //$变量
  //${表达式}
  print('单个iPhoneXsMax的价格:$iPhoneXsMax元,要是买两个的话就是${iPhoneXsMax * count}');

  void aFunc() {
    print('单个iPhoneXsMax的价格:$iPhoneXsMax元,要是买两个的话就是${iPhoneXsMax * count}');
  }

  aFunc();

  int lineCount;
  assert(lineCount == null);

  var s2 = 'The + operator ' + 'works, as well.';
  assert(s2 == 'The + operator works, as well.');

  int a = -88;

  // These work in a const string.
  const aConstNum = 0;
  const aConstBool = true;
  const aConstString = 'a constant string';

// These do NOT work in a const string.
  var aNum = 0;
  var aBool = true;
  var aString = 'a string';
  const aConstList = [1, 2, 3];
}

void testList() {
  var list = [1, 2, 3];
  list.add(4);
  list.remove(2);
  print(
      'length:${list.length} \nfirst object:${list[0]} \nlast object:${list[list.length - 1]}');
}

void testMap() {
  var yearForiPhone = const {
    //const 则说明在编译器就确定不变了
    //Key         : Value
    'iPhoneXs': "2018",
    'iPhoneXsMax': '2018',
    'iPhoneX': '2017'
  };

  var yearForiPhone1 = Map();
  yearForiPhone1['iPhoneXs'] = '2018';
  yearForiPhone1['iPhoneXsMax'] = '2018';
  yearForiPhone1['iPhoneX'] = '2017';

  print('$yearForiPhone \n$yearForiPhone1');

  assert(yearForiPhone['iPhoneXs'] == '2018');

  //直接使用 Unicode
  var card = {'黑桃': '\u2664', '红桃': '\u2665', '方片': '\u2666', '草花': '\u2667'};

  print('扑克四花色 : $card');

  Map tempMap = Map();
}

void testFunction() {
  //正常函数
  int addOperator(int a, int b) {
    return a + b;
  }

  //省略返回值类型
  addOperator_omitReturnType(int a, int b) {
    return a + b;
  }

  //单行函数 简写 语法糖 => expr; 等价 {return expr;}
  // => expr; 写法 expr 中只能是表达式不能包含声明
  int addOperator_singleLine_normal(int a, int b) {
    return a + b;
  }

  addOperator_singleLine(int a, int b) => a + b;

  String f = 'a + b = ';
  print('$f${addOperator(1, 2)}');
  print('$f${addOperator_omitReturnType(1, 2)}');
  print('$f${addOperator_omitReturnType(1, 2)}');
  print('$f${addOperator_singleLine_normal(1, 2)}');
  print('$f${addOperator_singleLine(1, 2)}');

  // 函数默认返回 null 隐式的加到函数体
  myDefaultReturnValue() {}
  assert(myDefaultReturnValue() == null);

  //可选参数 包括
  //1.Optional named parameters flutter用的是这个
  printStudentInfo(
          {int age, String name, String place = 'SouFun' /*默认参数 编译期常量 */}) =>
      print('$age-$name-$place');

  printStudentInfo(age: 10);
  printStudentInfo(name: 'flutter');
  printStudentInfo(place: '北京', age: 10);

  //2.Optional positional parameters
  String say(String from, String msg, [String device]) {
    var result = '$from says $msg';
    if (device != null) {
      result = '$result with a $device';
    }
    return result;
  }

  assert(say('Bob', 'Howdy') == 'Bob says Howdy');
  assert(say('Bob', 'Howdy', 'smoke signal') ==
      'Bob says Howdy with a smoke signal');

  // cascade(级联) 语法 .. 对一个对象多次调用
  List array = [1, 2, 3];
  array
    ..add(10)
    ..remove(3)
    ..addAll([11, 12, 13]);
  print('$array');

  // 函数作为参数
  void printElement(String element) {
    print(element);
  }

  var list1 = ['a', 's', 'd', 'f'];
  list1.forEach(printElement);
  list1.forEach((e) => print(e));

  // 函数赋值给变量
  var funcVar = (msg) => '!!! ${msg.toUpperCase()} !!!';
  assert(funcVar('hello') == '!!! HELLO !!!');

  // 匿名函数
  list1.forEach((e) {
    print('${list1.indexOf(e)}: $e');
  });

  //模拟网络请求
  httpRequest({String url, Map params, success(data), fail(error)}) {
    print('URL : $url');
    print('Params : $params');

    bool status = true;
    if (status) {
      if (success != null) {
        success({'status': 200});
      }
    } else {
      if (fail != null) {
        fail({'error': 'code404'});
      }
    }
  }

  httpRequest(
      url: 'www.baidu.com',
      params: {'messagename': 'zflist', 'city': '北京'},
      success: (d) => print(d),
      fail: (e) => print(e));
}

bool topLevel = true;

void testLexicalScope() {
  var insideMain = true;

  void myFunction() {
    var insideFunction = true;

    void nestedFunction() {
      var insideNestedFunction = true;

      assert(topLevel);
      assert(insideMain);
      assert(insideFunction);
      assert(insideNestedFunction);

      //addBy 的值会被记录
      makeAdder(num addBy) => (num i) => addBy + i;
      var add2 = makeAdder(2);
      var add4 = makeAdder(4);
      assert(add2(3) == 5);
      assert(add4(3) == 7);

      print('nestedFunction have done');
    }

    nestedFunction();
  }

  myFunction();
}

void foo() {} // A top-level function

class A {
  static void bar() {} // A static method
  void baz() {} // An instance method
}

testFunctionEquality() {
  var x = foo;
  // Comparing top-level functions.
  assert(foo == x);

  // Comparing static methods.
  x = A.bar;
  assert(A.bar == x);

  // Comparing instance methods.
  var v = A();
  var w = A();
  x = w.baz;

  // These closures refer to the same instance (#2),
  // so they're equal.
  assert(w.baz == x);

  // These closures refer to different instances,
  // so they're unequal.
  assert(v.baz != w.baz);

  print('testFunctionEquality have done');
}

void testTypeJudge() {
  String a = '1';
  if (a is String) {
    a = 'a是String';
    print(a);
  }

  var b;
  // b = (a as String);

  b ??= 'b是nul';
  print(b);
}

void testBitwiseAndShiftOperators() {
  final value = 0x22; //0010 0010
  final bitmask = 0x0f; //0000 1111

  assert((value & bitmask) == 0x02); // AND 0000 0010
  assert((value & ~bitmask) == 0x20); // AND NOT
  assert((value | bitmask) == 0x2f); // OR
  assert((value ^ bitmask) == 0x2d); // XOR
  assert((value << 4) == 0x220); // Shift left
  assert((value >> 4) == 0x02); // Shift right

  print('testBitwiseAndShiftOperators have done');
}

void testConditionalExpressions() {
  // v != null ? v : 'Guest' 等价于 v??'Guest'
  playerName({String name}) => name ?? 'Guest';

  var name1 = playerName();
  var name2 = playerName(name: 'Jack');
  print('name1 = $name1 \nname2 = $name2 ');
}

class computer {
  var cpu;
  var gpu;
  var disk;

  computer({this.cpu, this.gpu, this.disk});
  showInfo() => print('CPU:$cpu \nGPU:$gpu \nDISK:$disk');
}

void testCascadeNotation() {
  // .. 级联符号
  var myC = computer(cpu: 'Core i7 8700')
    ..gpu = 'TITAN V'
    ..disk = 'WD SSD 4T';
  myC.showInfo();

  //等同于
  var myOldC = computer();
  myOldC.cpu = 'Core i7 4790';
  myOldC.gpu = 'GTX 960';
  myOldC.disk = 'WD 1T';

  myOldC.showInfo();

  // ?. 防止null时崩溃
  var b;
  print('${b?.cpu}');
}

void testControlFlowStatements() {
  /*
  if else
  for loops
  while do-while
  break continue
  switch case
  assert
  try catch throw
   */

  var command = 'A';
  switch (command) {
    
    case 'OPEN':
      print('done open');
      break;
    case 'A':
      print('a');
      continue la;
      //如果 case中有语句 还需要继续执行其他case用continue:la; la: 来继续执行
    la:
    case 'CLOSED': // Empty case falls through.
    case 'NOW_CLOSED':
      // Runs for both CLOSED and NOW_CLOSED.
      print('done close');
      break;
  }
}

main(List<String> args) {
  // testPrint();
  // testList();
  // testMap();
  // testFunction();
  // testLexicalScope();
  // testFunctionEquality();
  // testTypeJudge();
  // testBitwiseAndShiftOperators();
  // testConditionalExpressions();
  // testCascadeNotation();
  // testControlFlowStatements();

  MacBook().testFunction();
}
