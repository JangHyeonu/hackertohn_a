import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey _containerKey = GlobalKey();
  Size? size;
  Offset? offset;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        size = _getSize();
        offset = _getOffset();
      });
    });
  }

  Size? _getSize() {
    if (_containerKey.currentContext != null) {
      final RenderBox renderBox =
      _containerKey.currentContext!.findRenderObject() as RenderBox;
      Size size = renderBox.size;
      return size;
    }
  }

  Offset? _getOffset() {
    if (_containerKey.currentContext != null) {
      final RenderBox renderBox =
      _containerKey.currentContext!.findRenderObject() as RenderBox;
      Offset offset = renderBox.localToGlobal(Offset.zero);
      return offset;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('위젯 사이즈 구하기'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
              "컨테이너 정보\nwidth:${size?.width}\nheight:${size?.height}\ndx:${offset?.dx}\ndy:${offset?.dy}"),
          Center(
            child: Container(
              key: _containerKey,
              color: Colors.blue,
              padding: const EdgeInsets.all(20),
              child: const Text("컨테이너입니다."),
            ),
          ),
        ],
      ),
    );
  }
}