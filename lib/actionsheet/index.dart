import 'package:flutter/material.dart';
import './android_widget.dart';
import './ios_widget.dart';
import '../utils.dart';

// 关闭函数
typedef _Close = Function();
// change
typedef _OnChange = Function(String index);
// 安卓
typedef WeActionSheetAndroid = Function(
    {_Close? onClose,
    bool maskClosable,
    _OnChange? onChange,
    required List<WeActionSheetItem> options});
// ios
typedef WeActionSheetIos = Function(
    {dynamic title,
    required List<WeActionSheetItem> options,
    bool maskClosable,
    dynamic cancelButton,
    _Close? onClose,
    _OnChange? onChange});

// WeActionSheet
class WeActionSheet {
  // 安卓样式
  static WeActionSheetAndroid android(BuildContext context) {
    return ({maskClosable = true, onClose, onChange, required options}) {
      final GlobalKey widgetKey = GlobalKey();
      late Function remove;

      // 关闭
      void hide() {
        remove();
        if (onClose is Function) {
          onClose!();
        }
      }

      // 点击
      void itemClick(int index) {
        remove();
        if (onChange is Function) {
          final String? value = options[index].value;
          onChange!(value == null ? index.toString() : value);
        }
      }

      remove = createOverlayEntry(
          context: context,
          backIntercept: true,
          child: AndroidWidget(
              key: widgetKey,
              maskClosable: maskClosable,
              close: hide,
              onChange: itemClick,
              children: options),
          willPopCallback: () {
            (widgetKey.currentState as AndroidWidgetState).close();
          });
    };
  }

  // ios 样式
  static WeActionSheetIos ios(BuildContext context) {
    return (
        {title,
        required options,
        maskClosable = true,
        cancelButton,
        onClose,
        onChange}) {
      final GlobalKey widgetKey = GlobalKey();
      late Function remove;

      // 关闭
      void hide() {
        remove();
        if (onClose is Function) {
          onClose!();
        }
      }

      // 点击
      void itemClick(int index) {
        remove();
        if (onChange is Function) {
          final String value = options[index].value;
          onChange!(value == null ? index.toString() : value);
        }
      }

      remove = createOverlayEntry(
          context: context,
          backIntercept: true,
          child: IosWidget(
              key: widgetKey,
              title: title,
              cancelButton: cancelButton,
              maskClosable: maskClosable,
              close: hide,
              onChange: itemClick,
              children: options),
          willPopCallback: () {
            (widgetKey.currentState as IosWidgetState).close();
          });
    };
  }
}

class WeActionSheetItem {
  final label;
  final String value;

  WeActionSheetItem({required this.label, required this.value});
}
