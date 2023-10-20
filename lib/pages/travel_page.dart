import 'package:flutter/material.dart';
import 'package:flutter_trip/model/travel_tab_model.dart';
import 'package:flutter_trip/pages/travel_tab_page.dart';

import '../dao/travel_tab_dao.dart';

class TravelPage extends StatefulWidget {
  @override
  _travelPageState createState() => _travelPageState();
}

class _travelPageState extends State<TravelPage> with TickerProviderStateMixin {
  late TabController _tabController;
  List<TravelTab> tabs = [];
  late TravelTabModel travelTabModel;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 0, vsync: this);
    TravelTabDao.fetch().then((TravelTabModel model) {
      _tabController = TabController(length: model.tabs!.length, vsync: this);
      setState(() {
        tabs = model.tabs ?? [];
        travelTabModel = model;
      });
    }).catchError((err) {
      print(err);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Container(
          color: Colors.white,
          padding: EdgeInsets.only(top: 30),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            //支持左右滑动
            labelColor: Colors.black,
            labelPadding: EdgeInsets.fromLTRB(20, 0, 10, 5),
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(color: Color(0xff2fcfbb), width: 3),
              insets: EdgeInsets.only(bottom: 10),
            ),
            tabs: tabs.map<Tab>((TravelTab tab) {
              return Tab(text: tab.labelName);
            }).toList(),
          ),
        ),
        Flexible(
            child: TabBarView(
                controller: _tabController,
                children: tabs.map((TravelTab tab) {
                  return TravelTabPage(
                      travelUrl: travelTabModel.url,
                      params: travelTabModel.params,
                      groupChannelCode: tab.groupChannelCode??'');
                }).toList()))
      ],
    ));
  }
}
