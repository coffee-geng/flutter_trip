import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:flutter_trip/dao/home_dao.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/model/salebox_model.dart';
import 'package:flutter_trip/pages/search_page.dart';
import 'package:flutter_trip/widget/grid_nav.dart';
import 'package:flutter_trip/widget/local_nav.dart';
import 'package:flutter_trip/widget/sales_box.dart';
import 'package:flutter_trip/widget/sub_nav.dart';
import 'package:flutter_trip/widget/loading_container.dart';
import 'package:flutter_trip/widget/webview_plugin.dart';
import 'package:flutter_trip/widget/search_bar.dart' as search_bar;
import 'dart:convert';

import '../model/common_model.dart';

const SEARCH_BAR_DEFAULT_TEXT = '网红打卡地 景点 酒店 美食';

class HomePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<HomePage> {
  final _defaultColor = Colors.grey;
  final _activeColor = Colors.blue;

  static const APPBAR_SCROLL_OFFSET = 100;
  double appBarAlpha = 0;
  bool _loading = true;

  List<CommonModel> bannerList = [];
  List<CommonModel> localNavList = [];
  GridNavModel? gridNavModel;
  List<CommonModel> subNavList = [];
  SalesBoxModel? salesBoxModel;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        body: LoadingContainer(
          isLoading: _loading,
          child: Stack(
            children: <Widget>[
              MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await loadData();
                      return;
                    },
                    child: NotificationListener(
                        onNotification: (scrollNotification) {
                          // ListView直接被NotificationListener包裹，所以scrollNotification.depth为0。其子孙的depth依次递增.
                          if (scrollNotification is ScrollUpdateNotification &&
                              scrollNotification.depth == 0) {
                            _onScroll(scrollNotification.metrics.pixels);
                          }
                          return false;
                        },
                        child: _listView),
                  )),
              _appBar
            ],
          ),
        ));
  }

  void _onScroll(double offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
  }

  loadData() async {
    try {
      var result = await HomeDao.fetch();
      setState(() {
        localNavList = result.localNavList;
        gridNavModel = result.gridNav;
        subNavList = result.subNavList;
        salesBoxModel = result.salesBox;
        bannerList = result.bannerList;
        _loading = false;
        // var s = json.encode(result);
        // resultString = String.fromCharCodes(utf8.encode(s));
        // Utf8Decoder utf8decoder = const Utf8Decoder();
        // var result2 = json.decode(utf8decoder.convert(s.codeUnits));
      });
    } catch (e) {
      setState(() {
        _loading = false;
        // resultString = e.toString();
      });
    }
  }

  Widget get _listView {
    return ListView(
      children: <Widget>[
        _banner,
        Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: LocalNav(localNavList: localNavList),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child: GridNav(gridNavModel: gridNavModel),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: SubNav(subNavList: subNavList),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: SalesBox(salesBox: salesBoxModel),
        ),
        Container(
          height: 800,
          child: ListTile(title: Text('尾部')),
        )
      ],
    );
  }

  Widget get _appBar {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  //AppBar渐变遮罩背景
                  colors: [Color(0x66000000), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 36, 0, 0),
            height: 80,
            decoration: BoxDecoration(
                color:
                    Color.fromARGB((appBarAlpha * 255).toInt(), 255, 255, 255)),
            child: search_bar.SearchBar(
              searchBarType: appBarAlpha > 0.2
                  ? search_bar.SearchBarType.homeLight
                  : search_bar.SearchBarType.home,
              inputBoxClick: _jumpToSearch,
              speakClick: _jumpToSpeak,
              defaultText: SEARCH_BAR_DEFAULT_TEXT,
              leftButtonClick: () {},
            ),
          ),
        ),
        Container(
          height: appBarAlpha > 0.2 ? 0.5 : 0,
          decoration: const BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 0.5)]),
        )
      ],
    );
  }

  _jumpToSearch() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                SearchPage(hint: SEARCH_BAR_DEFAULT_TEXT, hideLeft: false)));
  }

  _jumpToSpeak() {
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (BuildContext context) =>
    //             SpeakPage()));
  }

  Widget get _banner {
    return Container(
        height: 160,
        child: Swiper(
            itemCount: bannerList.length,
            autoplay: true,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      CommonModel model = bannerList[index];
                      return WebViewPlugin(
                          url: model.url,
                          title: model.title,
                          statusBarColor: model.statusBarColor,
                          hideAppBar: false,
                          backForbid: false);
                    }));
                  },
                  child:
                      Image.network(bannerList[index].icon, fit: BoxFit.fill));
            },
            pagination: SwiperPagination(
                builder: DotSwiperPaginationBuilder(
                    color: _defaultColor, activeColor: _activeColor))));
  }
}
