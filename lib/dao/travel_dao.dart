import 'dart:async';
import 'dart:convert';
import 'package:flutter_trip/dao/search_dao.dart';
import 'package:flutter_trip/model/home_model.dart';
import 'package:flutter_trip/model/travel_tab_model.dart';
import 'package:http/http.dart' as http;

import '../model/travel_model.dart';

const TRAVEL_TAB_URL = 'http://www.devio.org/io/flutter_app/json/travel_page.json';

///旅拍页接口
var Params =  {
  "districtId": -1,
  "groupChannelCode": "tourphoto_global1",
  "type": null,
  "lat": -180,
  "lon": -180,
  "locatedDistrictId": 2,
  "pagePara": {
    "pageIndex": 1,
    "pageSize": 10,
    "sortType": 9,
    "sortDirection": 0
  },
  "imageCutType": 1,
  "head": {
    "cid": "09031014111431397988"
  },
  "contentType": "json"
};

class TravelDao {

  static Future<TravelItemModel> fetch(String url, Map params, String groupChannelCode, int pageIndex, int pageSize) async {
    Map paramsMap = params['pagePara']; //固定携带的额外参数，不需变更
    paramsMap['pageIndex'] = pageIndex; //分页请求的页码
    paramsMap['pageSize'] = pageSize; //每页显示的条数
    Params['groupChannelCode'] = groupChannelCode; //频道码，在travel_tab_model.dart的TravelTab中有定义
    final response = await http.post(Uri.parse(url), body: jsonEncode(Params));
    if (response.statusCode == 200) {
      Utf8Decoder utf8decoder = const Utf8Decoder();
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      var model = TravelItemModel.fromJson(result);
      return model;
    } else {
      throw Exception('Failed to load travel');
    }
  }
}
