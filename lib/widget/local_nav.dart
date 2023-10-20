import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/widget/webview_plugin.dart';

class LocalNav extends StatelessWidget {
  final List<CommonModel> localNavList;

  const LocalNav({super.key, required this.localNavList});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(6))),
      child: Padding(
        padding: EdgeInsets.all(7),
        child: _items(context),
      ),
    );
  }

  _items(BuildContext context) {
    if (localNavList == null) return null;
    List<Widget> widgets = [];
    localNavList.forEach((item) {
      widgets.add(_item(context, item));
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: widgets,
    );
  }

  Widget _item(BuildContext context, CommonModel item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (buildContext) => WebViewPlugin(
                    url: item.url,
                    title: item.title,
                    statusBarColor: item.statusBarColor,
                    hideAppBar: item.hideAppBar,
                    backForbid: false)));
      },
      child: Column(
        children: <Widget>[
          Image.network(item.icon, width: 32, height: 32),
          Text(item.title, style: const TextStyle(fontSize: 12))
        ],
      ),
    );
  }
}
