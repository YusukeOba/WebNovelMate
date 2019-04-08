import 'package:flutter/material.dart';

class GeneralError extends StatelessWidget {
  final Icon icon;
  final String errorMessage;
  final String btnMessage;
  final VoidCallback btnHandle;

  GeneralError(this.icon, this.errorMessage, this.btnMessage, this.btnHandle);

  static GeneralError networkError(VoidCallback refreshHandler) {
    return GeneralError(Icon(Icons.refresh),
        "通信エラーが発生しました",
        "リトライ",
        refreshHandler);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: <Widget>[
            Text(
              errorMessage,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              height: 8.0,
            ),
            RaisedButton.icon(
                onPressed: btnHandle, icon: icon, label: Text(btnMessage))
          ],
        ));
  }
}
