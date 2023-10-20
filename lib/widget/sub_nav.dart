import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/widget/webview_plugin.dart';

class SubNav extends StatelessWidget {
  final List<CommonModel> subNavList;

  const SubNav({super.key, required this.subNavList});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(6)),
      child: Padding(
        padding: EdgeInsets.all(7),
        child: _items(context),
      ),
    );
  }

  _items(BuildContext context) {
    if (subNavList == null) return null;
    List<Widget> widgets = [];
    subNavList.forEach((item) {
      widgets.add(_item(context, item));
    });
    // 计算第一行显示的数量
    int columnsInFirstRow = (subNavList.length / 2 + 0.5).toInt();
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: widgets.sublist(0, columnsInFirstRow),
        ),
        Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: widgets.sublist(columnsInFirstRow),
            ))
      ],
    );
  }

  Widget _item(BuildContext context, CommonModel item) {
    return Expanded(
        flex: 1,
        child: GestureDetector(
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
              Image.network(item.icon, width: 18, height: 18),
              Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(item.title, style: const TextStyle(fontSize: 12)))
            ],
          ),
        ));
  }
}
