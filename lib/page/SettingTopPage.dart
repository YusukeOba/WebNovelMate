import 'package:NovelMate/page/TextSettingPage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingTopPage extends StatefulWidget {
  @override
  SettingTopState createState() {
    return SettingTopState();
  }
}

class SettingTopState extends State<SettingTopPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("設定"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("テキストの設定"),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return TextSettingPage();
              }));
            },
          ),
          Divider(),
          ListTile(
            title: Text("ライセンス情報"),
            onTap: () {
              showLicensePage(context: context);
            },
          ),
          Divider(),
          ListTile(
            title: Text("お問い合わせ"),
            onTap: () {
              _launchUrl();
            },
          ),
          Divider(),
        ],
      ),
    );
  }

  _launchUrl() async {
    const url =
        'https://docs.google.com/forms/d/1VAo0yPnzK0p1K0zKwrePQLoz4FQjC0T6KUkcaT8gLTQ/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
