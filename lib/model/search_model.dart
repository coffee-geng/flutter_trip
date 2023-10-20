class SearchModel{
  final List<SearchItem> data;
  String? keyword;

  SearchModel(this.data, {this.keyword});

  factory SearchModel.fromJson(Map<String, dynamic> json){
    if (json != null){
      var jsonData = json['data'] as List;
      var data = jsonData.map((e) => SearchItem.fromJson(e)).toList();
      return SearchModel(data);
    }else{
      return SearchModel([]);
    }
  }
}

class SearchItem {
  final String? word; //XX酒店
  final String? type; //hotel
  final String? price; //实时计价
  final String? star; //豪华型
  final String? zonename; //虹桥
  final String? districtname; //上海
  final String url;


  SearchItem({this.word, this.type, this.price, this.star, this.zonename,
    this.districtname, required this.url});

  factory SearchItem.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return SearchItem(
        word: json['word'] ?? '',
        type: json['type'] ?? '',
        price: json['price'] ?? '',
        star: json['star'] ?? '',
        zonename: json['zonename'] ?? '',
        districtname: json['districtname'],
        url: json['url']
      );
    } else {
      return SearchItem(url: '');
    }
  }

  Map<String, dynamic> toJson(){
    return {
      'word': word,
      'type': type,
      'price': price,
      'star': star,
      'zonename': zonename,
      'districtname': districtname,
      'url': url
    };
  }
}
