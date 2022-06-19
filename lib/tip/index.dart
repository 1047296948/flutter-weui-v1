import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../icon/index.dart';
import '../utils.dart';

// 间距
final double _spacing = 8.0;
// 背景色
final Color _color = Color(0xff303133);

// 方向
enum WeTipPlacement { top, right, bottom, left }

class WeTip extends StatefulWidget {
  // 位置
  final WeTipPlacement placement;

  // 元素
  final Widget child;

  // 提示内容
  final Widget content;

  WeTip(
      {this.placement = WeTipPlacement.top,
      required this.child,
      required this.content});

  @override
  WeTipState createState() => WeTipState();
}

class WeTipState extends State<WeTip> {
  GlobalKey _boxKey = GlobalKey();
  late Function remove;

  void show() {
    remove = createOverlayEntry(
        context: context,
        child: _WeTipWidget(
            maskClick: close,
            boxContext: _boxKey.currentContext,
            placement: widget.placement,
            child: widget.content),
        willPopCallback: close);
  }

  void close() {
    remove();
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Column(mainAxisSize: MainAxisSize.min, children: [
        GestureDetector(key: _boxKey, onTap: show, child: widget.child)
      ])
    ]);
  }
}

class _WeTipWidget extends StatelessWidget {
  final Function? maskClick;
  final Widget? child;
  final boxContext;
  final WeTipPlacement placement;
  late Offset _offset;
  late double _top;
  late double _left;
  late Offset _triangleOffset;
  late double _triangleTop;
  late double _triangleLeft;
  late double _angle;

  _WeTipWidget(
      {this.maskClick,
      this.child,
      this.boxContext,
      this.placement = WeTipPlacement.top}) {
    final Size size = boxContext.size;
    final RenderBox box = boxContext.findRenderObject();
    final Offset boxOffset = box.localToGlobal(Offset.zero);

    // 判断方向
    switch (placement) {
      // top
      case WeTipPlacement.top:
        _top = boxOffset.dy - _spacing;
        _left = boxOffset.dx + (size.width / 2);
        _offset = Offset(-0.5, -1);
        // 三角形
        _triangleOffset = _offset;
        _triangleTop = boxOffset.dy + 2;
        _triangleLeft = _left;
        _angle = math.pi;
        break;
      // right
      case WeTipPlacement.right:
        _top = boxOffset.dy + (size.height / 2);
        _left = boxOffset.dx + size.width + _spacing;
        _offset = Offset(0, -0.5);
        // 三角形
        _triangleOffset = _offset;
        _triangleTop = _top;
        _triangleLeft = boxOffset.dx + size.width - 2;
        _angle = (math.pi / 2) * 3;
        break;
      // bottom
      case WeTipPlacement.bottom:
        _top = boxOffset.dy + size.height + _spacing;
        _left = boxOffset.dx + (size.width / 2);
        _offset = Offset(-0.5, 0);
        // 三角形
        _triangleOffset = _offset;
        _triangleTop = boxOffset.dy + size.height - 2;
        _triangleLeft = _left;
        _angle = 0;
        break;
      // left
      case WeTipPlacement.left:
        _top = boxOffset.dy + (size.height / 2);
        _left = boxOffset.dx - _spacing;
        _offset = Offset(-1, -0.5);
        // 三角形
        _triangleOffset = _offset;
        _triangleTop = _top;
        _triangleLeft = boxOffset.dx + 2;
        _angle = math.pi / 2;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Stack(children: [
      GestureDetector(
          onPanDown: (_) {
            if (maskClick is Function) maskClick!();
          },
          child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.transparent),
              child: SizedBox(width: size.width, height: size.height))),
      Positioned(
          top: _top,
          left: _left,
          child: FractionalTranslation(
              translation: _offset,
              child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: _color,
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  child: DefaultTextStyle(
                      style: TextStyle(color: Colors.white, fontSize: 13.0),
                      child: Padding(
                          padding: EdgeInsets.all(10), child: child))))),
      Positioned(
          top: _triangleTop,
          left: _triangleLeft,
          child: FractionalTranslation(
              translation: _triangleOffset,
              child: Transform.rotate(
                  angle: _angle,
                  child: Icon(WeIcons.triangle, color: _color, size: 14))))
    ]);
  }
}
