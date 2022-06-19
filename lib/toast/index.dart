import 'dart:async';
import 'package:flutter/material.dart';
import '../utils.dart';
import './info.dart';
import './toast.dart';
import '../animation/rotating.dart';
import '../icon/index.dart';
import '../theme/index.dart';

// 对齐方式
enum WeToastInfoAlign {
  // 上对齐
  top,
  // 居中
  center,
  // 下对齐
  bottom
}

// loading icon
final Widget _loadingIcon =
    Image.asset('assets/images/loading.png', height: 42.0, package: 'weui');
// success icon
const Widget _successIcon = Icon(WeIcons.hook, color: Colors.white, size: 49.0);
// fail icon
const Widget _failIcon = Icon(WeIcons.info, color: Colors.white, size: 49.0);
// 对齐方式
final List<String> _weToastAlign = ['top', 'center', 'bottom'];

// info
typedef Info = Function(dynamic message,
    {int duration, WeToastInfoAlign align, double distance});
// loading
typedef Loading = Function(
    {dynamic message, int duration, bool mask, Widget icon});
// success
typedef Success = Function(
    {dynamic message, int duration, bool mask, Widget icon, Function? onClose});
// fail
typedef Fail = Function(
    {dynamic message, int duration, bool mask, Widget icon, Function? onClose});
// toast
typedef Toast = Function(
    {dynamic message, int duration, bool mask, Widget icon, Function? onClose});
// loading close
typedef Close = Function();

class WeToast {
  // 信息提示
  static Info info(BuildContext context) {
    return (message,
        {int? duration, WeToastInfoAlign? align, distance = 100.0}) async {
      final WeConfig config = WeUi.getConfig(context)!;
      // 转换
      final Widget? messageWidget = toTextWidget(message, 'message');
      final remove = createOverlayEntry(
          context: context,
          child: InfoWidget(messageWidget!,
              align: _weToastAlign[
                  align == null ? config.toastInfoAlign.index : align.index],
              distance: distance));

      // 自动关闭
      await Future.delayed(Duration(
          milliseconds:
              duration == null ? config.toastInfoDuration : duration));
      remove();
    };
  }

  // 加载中
  static Loading loading(BuildContext context) {
    Close show({message, duration, mask = true, icon}) {
      final int toastLoadingDuration =
          WeUi.getConfig(context)!.toastLoadingDuration;

      return WeToast.toast(context)(
          icon: Rotating(icon == null ? _loadingIcon : icon, duration: 800),
          mask: mask,
          message: message,
          duration: duration == null ? toastLoadingDuration : duration);
    }

    return show;
  }

  // 成功
  static Success success(BuildContext context) {
    return (
        {message,
        int? duration,
        mask = true,
        icon = _successIcon,
        Function? onClose}) {
      final int toastSuccessDuration =
          WeUi.getConfig(context)!.toastSuccessDuration;
      WeToast.toast(context)(
          icon: icon,
          mask: mask,
          message: message,
          duration: duration == null ? toastSuccessDuration : duration,
          onClose: onClose);
    };
  }

  // 失败
  static Fail fail(BuildContext context) {
    return (
        {message,
        int? duration,
        mask = true,
        icon = _failIcon,
        Function? onClose}) {
      final int toastFailDuration = WeUi.getConfig(context).toastFailDuration;
      WeToast.toast(context)(
          icon: icon,
          mask: mask,
          message: message,
          duration: duration == null ? toastFailDuration : duration,
          onClose: onClose);
    };
  }

  // 提示
  static Toast toast(BuildContext context) {
    return (
        {message,
        int? duration,
        mask = true,
        Widget? icon,
        Function? onClose}) {
      // 转换
      final Widget? messageWidget = toTextWidget(message, 'message');
      Function? remove = createOverlayEntry(
          context: context,
          child: ToastWidget(
            message: messageWidget,
            mask: mask,
            icon: icon,
          ));

      void close() {
        if (remove != null) {
          remove!();
          remove = null;
        }
      }

      // 自动关闭
      if (duration != null) {
        Future.delayed(Duration(milliseconds: duration), () {
          close();
          // 关闭回调
          if (onClose is Function) onClose();
        });
      }

      return close;
    };
  }
}
