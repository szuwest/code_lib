/// Copyright @2021  WeGene
/// Created by West 0n 2021/8/12
/// 类似Flutter framework里的XXXBinding机制
/// 用来理解多mixin继承和调用关系
/// mixin test

class TestA {
  int? a;

  test() {
    print("TestA test");
  }

  void initData() {
    a = 1;
    instance = this;
  }

  static TestA? instance;
}

abstract class TestB {
  int? a;
  int? b;
  TestB() {
    print("TestB constructor");
    initData();
  }

  test() {
    print("TestB test");
  }

  void initData() {
    print("TestB initData");
    a = 2;
    b = 2;
    // instance = this;
  }

  // static TestB? instance;
}

mixin MixinA on TestB{
  int? a;
  test() {
    print("MixinA test");
  }

  funcA() {
    print("MixinA funcA");
  }

  void initData() {
    print("MixinA initData");
    super.initData();
    a = 3;
    instance = this;
  }

  static MixinA? instance;
}

mixin MixinB on MixinA {
  int? a;
  int? b;
  test() {
    print("MixinB test");
  }

  funcB() {
    print("MixinB funcB");
  }
  void initData() {
    print("MixinB initData");
    super.initData();
    a = 4;
    b = 4;
    instance = this;
  }

  static MixinB? instance;
}

mixin MixinC on TestB, MixinB {
  int c = 1;
  void initData() {
    print("MixinC initData");
    super.initData();
    a = 5;
    b = 5;
    instance = this;
  }

  test() {
    print("MixinC test");
  }

  static MixinC? instance;
}

class Test extends TestB with MixinA, MixinB, MixinC {
  int? a;
  Test() {
    a = 10;
    print("Test constructor");
  }

  // test() {
  //   print("Test test");
  // }
}

void main() {
  var test = Test();
  print("a=${test.a}");
  print("b=${test.b}");
  print("c=${test.c}");
  test.test();
  test.funcA();
  test.funcB();
  MixinA.instance?.test();
  MixinA.instance?.funcA();
  MixinB.instance?.test();
  MixinC.instance?.test();
  MixinC.instance?.funcB();
  print("MixinA.instance = ${MixinA.instance?.runtimeType}");
  //输出：
  //TestB constructor
  // MixinC initData
  // MixinB initData
  // MixinA initData
  // TestB initData
  // Test constructor
  // a=10
  // b=5
  // c=1
  // MixinC test
  // MixinA funcA
  // MixinB funcB
  // MixinC test
  // MixinA funcA
  // MixinC test
  // MixinC test
  // MixinB funcB
  // MixinA.instance = Test
}