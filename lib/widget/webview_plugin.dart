import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

const CATCH_URLS = ['m.ctrip.com/', 'm.ctrip.com/html5/', 'm.ctrip.com/html5'];

class WebViewPlugin extends StatefulWidget {
  String? url;
  final String? title;
  final String? statusBarColor;
  final bool? hideAppBar;
  final bool backForbid;

  WebViewPlugin(
      {this.url,
      this.title,
      this.statusBarColor,
      this.hideAppBar,
      this.backForbid = false}) {
    if (url != null && url!.contains('ctrip.com')) {
      //fix 携程H5 http://无法打开问题
      url = url!.replaceAll('http://', 'https://');
    }
  }

  @override
  _WebVeiwPluginState createState() => _WebVeiwPluginState();
}

class _WebVeiwPluginState extends State<WebViewPlugin> {
  late final WebViewController _webviewController;
  bool exiting = false;

  _isToMain(String? url) {
    bool contain = false;
    for (final value in CATCH_URLS) {
      if (url?.endsWith(value) ?? false) {
        contain = true;
        break;
      }
    }
    return contain;
  }

  @override
  void initState() {
    super.initState();
    _webviewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (_isToMain(request.url)) {
              print('blocking navigation to $request');
              Navigator.pop(context);
              return NavigationDecision.prevent;
            }
            print('allowing navigation to $request');
            return NavigationDecision.navigate;
          }));
    if (widget.url != null) {
      _webviewController.loadRequest(Uri.parse(widget.url!));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String statusBarColorStr = 'ffffff';
    if (widget.statusBarColor != null && widget.statusBarColor != '') {
      statusBarColorStr = widget.statusBarColor!;
    }
    Color backButtonColor;
    if (statusBarColorStr == 'ffffff') {
      backButtonColor = Colors.black;
    } else {
      backButtonColor = Colors.white;
    }
    if (!statusBarColorStr.startsWith('0x')) {
      if (statusBarColorStr.length == 6) {
        statusBarColorStr = 'ff' + statusBarColorStr;
      }
      statusBarColorStr = '0x' + statusBarColorStr;
    } else {
      String str = statusBarColorStr.substring(2);
      if (str.length == 6) {
        str = 'ff' + str;
      }
      statusBarColorStr = '0x' + str;
    }
    return Scaffold(
      body: Column(
        children: <Widget>[
          _appBar(Color(int.parse(statusBarColorStr)), backButtonColor),
          Expanded(
              child: WebViewWidget(
            controller: _webviewController,
          ))
        ],
      ),
    );
  }

  _appBar(Color backgroundColor, Color backButtonColor) {
    if (widget.hideAppBar ?? false) {
      return Container(
        color: backButtonColor,
        height: 52,
      );
    } else {
      return Container(
        padding: EdgeInsets.fromLTRB(0, 55, 0, 10),
        color: backgroundColor,
        child: FractionallySizedBox(
          widthFactor: 1,
          child: Stack(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
              Positioned(
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(widget.title ?? '',
                        style: TextStyle(color: backButtonColor, fontSize: 20)),
                  ))
            ],
          ),
        ),
      );
    }
  }
}
