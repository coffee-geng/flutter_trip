import 'package:flutter/material.dart';
import 'package:flutter_trip/widget/loading_container.dart';
import 'package:flutter_trip/widget/webview_plugin.dart';

import '../dao/travel_dao.dart';
import '../model/travel_model.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

const PAGE_SIZE = 10;
const TRAVEL_URL =
    'https://m.ctrip.com/restapi/soa2/16189/json/searchTripShootListForHomePageV2?_fxpcqlniredt=09031014111431397988&__gw_appid=99999999&__gw_ver=1.0&__gw_from=10650013707&__gw_platform=H5';

class TravelTabPage extends StatefulWidget {
  final String? travelUrl;
  final String groupChannelCode;
  final Map params;

  const TravelTabPage(
      {Key? key,
      this.travelUrl,
      required this.params,
      required this.groupChannelCode})
      : super(key: key);

  @override
  _TravelTabPageState createState() => _TravelTabPageState();
}

class _TravelTabPageState extends State<TravelTabPage>
    with AutomaticKeepAliveClientMixin {
  List<TravelItem> travelItems = [];
  int pageIndex = 1;
  bool _loading = true;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        _loadData(loadMore: true);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LoadingContainer(
            isLoading: _loading,
            child: RefreshIndicator(
              onRefresh: () async {
                _loadData();
                return;
              },
              child: MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: MasonryGridView.count(
                    controller: _scrollController,
                    crossAxisCount: 2,
                    itemCount: travelItems.length,
                    itemBuilder: (BuildContext context, int index) =>
                        _TravelItem(index: index, item: travelItems[index]),
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                  )),
            )));
  }

  void _loadData({bool loadMore = false}) {
    if (loadMore) {
      pageIndex++;
    } else {
      pageIndex = 1;
    }
    TravelDao.fetch(widget.travelUrl ?? TRAVEL_URL, widget.params,
            widget.groupChannelCode, pageIndex, PAGE_SIZE)
        .then((TravelItemModel model) {
      _loading = false;
      setState(() {
        List<TravelItem> items = _filterItems(model.resultList);
        if (travelItems != null && loadMore) {
          travelItems.addAll(items);
        } else {
          travelItems = items;
        }
      });
    }).catchError((err) {
      _loading = false;
    });
  }

  List<TravelItem> _filterItems(List<TravelItem>? resultList) {
    if (resultList == null) {
      return [];
    }
    List<TravelItem> filterItems = [];
    resultList.forEach((item) {
      if (item.article != null) {
        filterItems.add(item);
      }
    });
    return filterItems;
  }

  @override
  bool get wantKeepAlive => true; //返回true表示缓存了当前页面，这样打开过的页面再次切换就不会重新加载
}

class _TravelItem extends StatelessWidget {
  final TravelItem item;
  final int? index;

  _TravelItem({Key? key, required this.item, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (item.article?.urls != null && item.article!.urls!.length > 0) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WebViewPlugin(
                        title: '详情',
                        url: item.article!.urls?[0].h5Url,
                      )));
        }
      },
      child: Card(
        child: PhysicalModel(
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _itemImage(),
              Container(
                padding: EdgeInsets.all(4),
                child: Text(
                  item.article?.articleTitle ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
              _infoText()
            ],
          ),
        ),
      ),
    );
  }

  _itemImage() {
    String? imageUrl = null;
    if (item.article?.images != null) {
      if (item.article!.images!.length > 0) {
        imageUrl = item.article!.images![0].dynamicUrl;
      }
    }
    return Stack(
      children: <Widget>[
        imageUrl != null ? Image.network(imageUrl!) : Container(),
        Positioned(
            left: 8,
            bottom: 8,
            child: Container(
              padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
              decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(right: 3),
                      child: Icon(Icons.location_on,
                          color: Colors.white, size: 12)),
                  LimitedBox(
                    maxWidth: 130,
                    child: Text(
                      _poiName(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  )
                ],
              ),
            ))
      ],
    );
  }

  String _poiName() {
    if (item.article?.pois != null && item.article!.pois!.length > 0) {
      return item.article!.pois![0].poiName ?? '未知';
    } else {
      return '未知';
    }
  }

  _infoText() {
    String? coverImage = item.article?.author?.coverImage?.dynamicUrl;

    return Container(
      padding: EdgeInsets.fromLTRB(6, 0, 6, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              PhysicalModel(
                  color: Colors.transparent,
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.circular(12),
                  child: coverImage != null
                      ? Image.network(coverImage!, width: 24, height: 24)
                      : Icon(Icons.location_city, size: 24)),
              Container(
                padding: EdgeInsets.all(5),
                width: 90,
                child: Text(
                  item.article?.author?.nickName ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black87, fontSize: 12),
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Icon(Icons.thumb_up, size: 14, color: Colors.grey),
              Padding(
                  padding: EdgeInsets.only(left: 3),
                  child: Text(item.article?.likeCount?.toString() ?? '0',
                      style: TextStyle(fontSize: 10)))
            ],
          )
        ],
      ),
    );
  }
}
