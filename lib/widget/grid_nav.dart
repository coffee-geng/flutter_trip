import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/widget/webview_plugin.dart';

import '../utils/Utils.dart';

class GridNav extends StatelessWidget {
  final GridNavModel? gridNavModel;

  const GridNav({super.key, this.gridNavModel});

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      clipBehavior: Clip.antiAlias,
      child:  Column(
        children: _gridNavItems(context),
      )
    );
  }

  List<Widget> _gridNavItems(BuildContext context) {
    List<Widget> widgets = [];
    if (gridNavModel == null) {
      return [];
    }
    if (gridNavModel!.hotel != null) {
      widgets.add(_gridNavItem(context, gridNavModel!.hotel, true));
    }
    if (gridNavModel!.flight != null) {
      widgets.add(_gridNavItem(context, gridNavModel!.flight, false));
    }
    if (gridNavModel!.travel != null) {
      widgets.add(_gridNavItem(context, gridNavModel!.travel, false));
    }
    return widgets;
  }

  _gridNavItem(BuildContext context, GridNavItemModel model, bool first) {
    List<Widget> widgets = [];
    widgets.add(_mainItem(context, model.mainItem));
    widgets.add(_doubleItem(context, model.item1, model.item2));
    widgets.add(_doubleItem(context, model.item3, model.item4));
    List<Widget> expandedWidgets = [];
    for (var element in widgets) {
      expandedWidgets.add(Expanded(flex: 1, child: element));
    }

    Color startColor = Utils.StringToColor(model.startColor);
    Color endColor = Utils.StringToColor(model.endColor);
    return Container(
      height: 88,
      margin: first ? null : const EdgeInsets.only(top: 3),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [startColor, endColor])
      ),
      child: Row(
        children: expandedWidgets,
      ),
    );
  }

  _mainItem(BuildContext context, CommonModel model) {
    return _wrapGesture(context, Stack(
      alignment: AlignmentDirectional.topCenter,
      children: <Widget>[
        Image.network(model.icon, fit: BoxFit.contain,
          width: 121,
          height: 88,
          alignment: AlignmentDirectional.bottomEnd,),
        Container(
          margin: EdgeInsets.only(top: 11),
          child: Text(model.title, style: TextStyle(color: Colors.white, fontSize: 14))
        )
      ],
    ), model);
  }

  _doubleItem(BuildContext context, CommonModel topModel,
      CommonModel bottomModel) {
    return Column(
      children: <Widget>[
        Expanded(
          child: _item(context, topModel, true),
        ),
        Expanded(
            child: _item(context, bottomModel, false)
        )
      ],
    );
  }

  _item(BuildContext context, CommonModel model, bool isTop) {
    BorderSide borderSide = const BorderSide(width: 0.8, color: Colors.white);
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
          decoration: BoxDecoration(
              border: Border(
                  left: borderSide,
                  bottom: isTop ? borderSide : BorderSide.none
              )
          ),
          child: _wrapGesture(context, Center(
              child: Text(model.title, textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 14))
          ), model)
      ),
    );
  }

  _wrapGesture(BuildContext context, Widget widget, CommonModel model) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (buildContext) =>
                      WebViewPlugin(
                          url: model.url,
                          title: model.title,
                          statusBarColor: model.statusBarColor,
                          hideAppBar: model.hideAppBar,
                          backForbid: false)));
        },
        child: widget
    );
  }
}
