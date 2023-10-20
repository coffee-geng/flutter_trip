import 'package:flutter_trip/model/config_model.dart';
import 'package:flutter_trip/model/salebox_model.dart';
import 'dart:convert';
import 'common_model.dart';
import 'grid_nav_model.dart';

class HomeModel {
  final ConfigModel config;
  final List<CommonModel> bannerList;
  final List<CommonModel> localNavList;
  final GridNavModel gridNav;
  final List<CommonModel> subNavList;
  final SalesBoxModel salesBox;

  HomeModel(
      {required this.config,
      required this.bannerList,
      required this.localNavList,
      required this.gridNav,
      required this.subNavList,
      required this.salesBox});

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    if (json == null){
      throw Exception('json must be non-null.');
    }
    var bannerListJson = json['bannerList'] as List;
    var localNavListJson = json['localNavList'] as List;
    var subNavListJson = json['subNavList'] as List;
    List<CommonModel> bannerList =
        bannerListJson.map((element) => CommonModel.fromJson(element)).toList();
    List<CommonModel> localNavList = localNavListJson
        .map((element) => CommonModel.fromJson(element))
        .toList();
    List<CommonModel> subNavList =
        subNavListJson.map((element) => CommonModel.fromJson(element)).toList();

    return HomeModel(
        config: ConfigModel.fromJson(json['config']),
        bannerList: bannerList,
        localNavList: localNavList,
        gridNav: GridNavModel.fromJson(json['gridNav']),
        subNavList: subNavList,
        salesBox: SalesBoxModel.fromJson(json['salesBox']));
  }

  Map<String, dynamic> toJson(){
    return {
      'config': config.toJson(),
      'bannerList': bannerList.map((e) => e.toJson()).toList(),
      'localNavList': localNavList.map((e) => e.toJson()).toList(),
      'gridNav': gridNav.toJson(),
      'subNavList': subNavList.map((e) => e.toJson()).toList(),
      'salesBox': salesBox.toJson()
    };
  }
}
