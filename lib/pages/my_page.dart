import 'package:flutter/material.dart';
import 'package:flutter_trip/widget/webview_plugin.dart';

class MyPage extends StatefulWidget{
  @override
  _myPageState createState() => _myPageState();

}

class _myPageState extends State<MyPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: WebViewPlugin(
          url: 'https://m.ctrip.com/webapp/myctrip',
          hideAppBar: true,
          backForbid: true,
          statusBarColor: '4c5bca',
        )
      ),
    );
  }

}