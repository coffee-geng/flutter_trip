import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/model/salebox_model.dart';
import 'package:flutter_trip/widget/webview_plugin.dart';

/// 底部卡片入口
class SalesBox extends StatelessWidget {
  final SalesBoxModel? salesBox;

  const SalesBox({super.key, required this.salesBox});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: _items(context),
    );
  }

  _items(BuildContext context) {
    if (salesBox == null) return null;
    List<Widget> widgets = [];
    widgets.add(_doubleItem(
        context, salesBox!.bigCard1, salesBox!.bigCard2, true, false));
    widgets.add(_doubleItem(
        context, salesBox!.smallCard1, salesBox!.smallCard2, false, false));
    widgets.add(_doubleItem(
        context, salesBox!.smallCard3, salesBox!.smallCard4, false, true));
    return Column(
      children: <Widget>[
        Container(
          height: 44,
          margin: EdgeInsets.only(left: 10),
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1, color: Color(0xfff2f2f2)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.network(salesBox!.icon, height: 15, fit: BoxFit.fill),
              Container(
                padding: EdgeInsets.fromLTRB(10, 1, 8, 1),
                margin: EdgeInsets.only(right: 7),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                        colors: [Color(0xffff4e63), Color(0xffff6cc9)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight)),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewPlugin(
                                url: salesBox!.moreUrl,
                                title: '更多活动',
                                statusBarColor: '',
                                hideAppBar: true,
                                backForbid: false)));
                  },
                  child: Text(
                    '获取更多福利 >',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              )
            ],
          ),
        ),
        widgets.sublist(0, 1).first,
        widgets.sublist(1, 2).first,
        widgets.sublist(2, 3).first
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: widgets.sublist(0, 1),
        // ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: widgets.sublist(1, 2),
        // ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: widgets.sublist(2, 3),
        // )
      ],
    );
  }

  Widget _item(BuildContext context, CommonModel item, bool isBigCard,
      bool isLeftCard, bool isLast) {
    BorderSide borderSide =
        const BorderSide(width: 0.8, color: Color(0xfff2f2f2));
    return Expanded(
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
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      right: isLeftCard ? borderSide : BorderSide.none,
                      bottom: isLast ? BorderSide.none : borderSide)),
              child: Image.network(item.icon,
                  fit: BoxFit.fill,
                  width: MediaQuery.of(context).size.width / 2 - 10,
                  height: isBigCard ? 129 : 80),
            )));
  }

  Widget _doubleItem(BuildContext context, CommonModel leftModel,
      CommonModel rightModel, bool isBigCard, bool isLast) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _item(context, leftModel, isBigCard, true, isLast),
        _item(context, rightModel, isBigCard, false, isLast),
      ],
    );
  }
}
