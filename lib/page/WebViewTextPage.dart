import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewExample extends StatelessWidget {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter WebView example'),
      ),
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: 'html/index.html',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          javascriptChannels: {
            JavascriptChannel(
                name: "Msg",
                onMessageReceived: (msg) {
                  print("msg");
                })
          },
        );
      }),
      floatingActionButton:
          FloatingActionButton(onPressed: () {}, child: Icon(Icons.hearing)),
    );
  }
}
