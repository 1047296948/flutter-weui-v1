import 'package:flutter/material.dart';
import '../layout/sample.dart';
import 'package:weui/weui.dart';

// final list = [
//   Text('选项一'),
//   Text('选项二'),
//   Text('选项三')
// ];

final options = [
  WeActionSheetItem(
    label: '选项一',
    value: '1'
  ),
  WeActionSheetItem(
    label: '选项二',
    value: '2'
  ),
  WeActionSheetItem(
    label: '选项三',
    value: '3'
  )
];

class ActionsheetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WeActionSheetAndroid actionsheetAndroid = WeActionSheet.android(context);
    final WeActionSheetIos actionsheetIos = WeActionSheet.ios(context);

    return Sample(
      'Actionsheet',
      describe: '弹出式菜单',
      child: Column(
        children: <Widget>[
          WeButton('android', theme: WeButtonType.primary, onClick: () {
            actionsheetAndroid(
              options: options,
              onChange: (String value) {
                WeToast.info(context)('选择了$value');
              },
              onClose: () {
                WeToast.info(context)('关闭');
              }
            );
          }),
          Container(height: 20.0),
          WeButton('ios', theme: WeButtonType.primary, onClick: () {
            actionsheetIos(
              title: '请选择',
              options: options,
              cancelButton: '取消',
              onChange: (String value) {
                WeToast.info(context)('选择了$value');
              },
              onClose: () {
                WeToast.info(context)('关闭');
              }
            );
          }),
          Container(height: 20.0),
          WeButton('ios 无取消按钮', theme: WeButtonType.primary, onClick: () {
            actionsheetIos(
              title: '请选择',
              options: options,
              onChange: (String value) {
                WeToast.info(context)('选择了$value');
              },
              onClose: () {
                WeToast.info(context)('关闭');
              }
            );
          }),
          Container(height: 20.0),
          WeButton('android 禁止遮罩层点击', theme: WeButtonType.primary, onClick: () {
            actionsheetAndroid(
              options: options,
              maskClosable: false,
              onChange: (String value) {
                WeToast.info(context)('选择了$value');
              },
              onClose: () {
                WeToast.info(context)('关闭');
              }
            );
          }),
          Container(height: 20.0),
          WeButton('ios 禁止遮罩层点击', theme: WeButtonType.primary, onClick: () {
            actionsheetIos(
              title: '请选择',
              options: options,
              maskClosable: false,
              cancelButton: '取消',
              onChange: (String value) {
                WeToast.info(context)('选择了$value');
              },
              onClose: () {
                WeToast.info(context)('关闭');
              }
            );
          }),
        ]
      )
    );
  }
}
