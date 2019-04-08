import 'package:flutter/material.dart';

class AlertUtils {
  /// 汎用のOKのみのダイアログ
  static AlertDialog notifyAlert(String title, String msg,
      {String buttonMsg = "OK", VoidCallback buttonPressed}) {
    return AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: <Widget>[
        new FlatButton(onPressed: buttonPressed, child: Text(buttonMsg))
      ],
    );
  }

  /// 汎用通信エラー
  static AlertDialog networkError(BuildContext context, VoidCallback callback) {
    return notifyAlert("エラー", "通信エラーが発生しました", buttonPressed: () {
      Navigator.of(context).pop();
      callback();
    });
  }
}
