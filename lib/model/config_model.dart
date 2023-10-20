class ConfigModel{
  final String searchUrl;

  ConfigModel({this.searchUrl = ''});

  factory ConfigModel.fromJson(Map<String, dynamic> json){
    if (json != null) {
      return ConfigModel(
          searchUrl: json['searchUrl']
      );
    } else{
      return ConfigModel();
    }
  }

  Map<String, dynamic> toJson(){
    return {
      'searchUrl': searchUrl
    };
  }
}