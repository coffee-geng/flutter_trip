import 'dart:async';
import 'dart:convert';
import 'package:flutter_trip/model/home_model.dart';
import 'package:flutter_trip/model/search_model.dart';
import 'package:http/http.dart' as http;

///搜索接口
class SearchDao {
  static String? SEARCH_URL;

  static Future<SearchModel> fetch(String url, String keyword) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Utf8Decoder utf8decoder = const Utf8Decoder();
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      var model = SearchModel.fromJson(result);
      model.keyword = keyword;
      return model;
    } else {
      throw Exception('Failed to load search_page.json');
    }
  }
}
