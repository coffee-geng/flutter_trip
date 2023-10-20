import 'dart:async';
import 'dart:convert';
import 'package:flutter_trip/dao/search_dao.dart';
import 'package:flutter_trip/model/home_model.dart';
import 'package:flutter_trip/model/travel_tab_model.dart';
import 'package:http/http.dart' as http;

const TRAVEL_TAB_URL = 'http://www.devio.org/io/flutter_app/json/travel_page.json';

///旅拍类别接口
class TravelTabDao {

  static Future<TravelTabModel> fetch() async {
    final response = await http.get(Uri.parse(TRAVEL_TAB_URL));
    if (response.statusCode == 200) {
      Utf8Decoder utf8decoder = const Utf8Decoder();
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      var model = TravelTabModel.fromJson(result);
      return model;
    } else {
      throw Exception('Failed to load travel_page.json');
    }
  }
}
