// 首页网格卡片模型
import 'package:flutter_trip/model/common_model.dart';

class GridNavModel {
  final GridNavItemModel hotel;
  final GridNavItemModel flight;
  final GridNavItemModel travel;

  GridNavModel(
      {required this.hotel, required this.flight, required this.travel});

  factory GridNavModel.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw Exception('json must be non-null.');
    }
    dynamic hotel = json['hotel'];
    dynamic flight = json['flight'];
    dynamic travel = json['travel'];
    return GridNavModel(
        hotel: GridNavItemModel.fromJson(hotel),
        flight: GridNavItemModel.fromJson(flight),
        travel: GridNavItemModel.fromJson(travel));
  }

  Map<String, dynamic> toJson(){
    return {
      'hotel': hotel.toJson(),
      'flight': flight.toJson(),
      'travel': travel.toJson()
    };
  }
}

class GridNavItemModel {
  final String startColor;
  final String endColor;
  final CommonModel mainItem;
  final CommonModel item1;
  final CommonModel item2;
  final CommonModel item3;
  final CommonModel item4;

  GridNavItemModel(
      {this.startColor = '',
      this.endColor = '',
      required this.mainItem,
      required this.item1,
      required this.item2,
      required this.item3,
      required this.item4});

  factory GridNavItemModel.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw Exception('json must be non-null.');
    }
    return GridNavItemModel(
        startColor: json['startColor'],
        endColor: json['endColor'],
        mainItem: CommonModel.fromJson(json['mainItem']),
        item1: CommonModel.fromJson(json['item1']),
        item2: CommonModel.fromJson(json['item2']),
        item3: CommonModel.fromJson(json['item3']),
        item4: CommonModel.fromJson(json['item4']));
  }

  Map<String, dynamic> toJson(){
    return {
      'startColor': startColor,
      'endColor': endColor,
      'mainItem': mainItem.toJson(),
      'item1': item1.toJson(),
      'item2': item2.toJson(),
      'item3': item3.toJson(),
      'item4': item4.toJson()
    };
  }
}
