import 'package:flutter/material.dart';
import 'package:flutter_trip/widget/search_bar.dart' as search_bar;
import 'package:flutter_trip/widget/webview_plugin.dart';

import '../dao/search_dao.dart';
import '../model/search_model.dart';

const SEARCH_URL =
    'https://m.ctrip.com/restapi/h5api/globalsearch/search?source=mobileweb&action=mobileweb&keyword=';

const TYPES = [
  'channelgroup',
  'gs',
  'plane',
  'train',
  'cruise',
  'district',
  'food',
  'hotel',
  'huodong',
  'shop',
  'sight',
  'ticket',
  'travelgroup'
];

class SearchPage extends StatefulWidget {
  final bool hideLeft;
  final String? searchUrl;
  final String? keyword;
  final String? hint;

  SearchPage(
      {this.hideLeft = true,
      this.searchUrl = SEARCH_URL,
      this.keyword,
      this.hint});

  @override
  _searchPageState createState() => _searchPageState();
}

class _searchPageState extends State<SearchPage> {
  String keyword = '';
  SearchModel? searchModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        _appBar(),
        MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Expanded(
                flex: 1,
                child: ListView.builder(
                    itemCount: searchModel?.data?.length ?? 0,
                    itemBuilder: (BuildContext context, int position) {
                      return _item(position);
                    })))
      ],
    ));
  }

  _appBar() {
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
            padding: EdgeInsets.only(top: 36),
            height: 80,
            decoration: BoxDecoration(color: Colors.white),
            child: search_bar.SearchBar(
              hideLeft: widget.hideLeft,
              defaultText: widget.keyword,
              hint: widget.hint,
              speakClick: _jumpToSpeak,
              leftButtonClick: () {
                FocusScope.of(context).requestFocus(FocusNode());
                Navigator.pop(context);
              },
              rightButtonClick: (){
                FocusScope.of(context).requestFocus(FocusNode());
              },
              onChanged: _onTextChanged,
            ),
          ),
        )
      ],
    );
  }

  void _onTextChanged(String text) {
    keyword = text;
    if (text.isEmpty) {
      setState(() {
        searchModel = null;
      });
      return;
    }
    String url = widget.searchUrl! + text;
    SearchDao.fetch(url, text).then((SearchModel model) {
      if (model?.keyword == text) {
        setState(() {
          searchModel = model;
        });
      }
    }).catchError((err) {
      print('throw exception by: ${err}');
    });
  }

  Widget? _item(int position) {
    if (searchModel == null || searchModel!.data == null) {
      return null;
    }
    SearchItem item = searchModel!.data[position];
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return WebViewPlugin(
            url: item.url,
            title: '详情',
          );
        }));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 0.3, color: Colors.grey))),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(1),
              child: Image(
                height: 26,
                width: 26,
                image: AssetImage(_typeImage(item.type)),
              ),
            ),
            Column(
              children: <Widget>[
                Container(width: 300, child: _title(item)),
                Container(
                    width: 300,
                    margin: EdgeInsets.only(top: 5),
                    child: _subTitle(item))
              ],
            )
          ],
        ),
      ),
    );
  }

  String _typeImage(String? type) {
    if (type == null) {
      return 'images/type_travelgroup.png';
    }
    String path = 'travelgroup';
    for (final val in TYPES) {
      if (type.contains(val)) {
        path = val;
        break;
      }
    }
    return 'images/type_${path}.png';
  }

  _title(SearchItem item) {
    if (item == null) {
      return null;
    }
    List<TextSpan> spans = [];
    spans.addAll(_keywordTextSpans(item.word, searchModel?.keyword));
    spans.add(TextSpan(
        text: ' ' + (item.districtname ?? '') + ' ' + (item.zonename ?? ''),
        style: TextStyle(fontSize: 16, color: Colors.grey)));
    return RichText(text: TextSpan(children: spans));
  }

  _subTitle(SearchItem item) {
    return RichText(
        text: TextSpan(children: <TextSpan>[
      TextSpan(
          text: item.price ?? '',
          style: TextStyle(fontSize: 16, color: Colors.orange)),
      TextSpan(
          text: ' ' + (item.star ?? ''),
          style: TextStyle(fontSize: 12, color: Colors.grey))
    ]));
  }

  Iterable<TextSpan> _keywordTextSpans(String? word, String? keyword) {
    List<TextSpan> spans = [];
    if (word == null ||
        word!.length == 0 ||
        keyword == null ||
        keyword.length == 0) {
      return spans;
    }
    // 'wordwoc'.split('w') -> [, ord, oc]
    String wordL = word.toLowerCase();
    String keywordL = keyword.toLowerCase();
    List<String> arr = wordL.split(keywordL);
    TextStyle normalStyle = TextStyle(fontSize: 16, color: Colors.black87);
    TextStyle keywordStyle = TextStyle(fontSize: 16, color: Colors.orange);

    int preIndex = 0;
    for (int i = 0; i < arr.length; i++) {
      if (i != 0) {
        preIndex = wordL.indexOf(keywordL, preIndex);
        spans.add(TextSpan(text: word.substring(preIndex, preIndex + keyword.length), style: keywordStyle));
      }
      String val = arr[i];
      if (val != null && val.length > 0) {
        //从忽略大小写关键字筛选的搜索文本中找出原文本中对应位置的匹配字符串
        preIndex = preIndex + (i > 0 ? keyword.length : 0);
        val = word.substring(preIndex, preIndex + val.length);
        spans.add(TextSpan(text: val, style: normalStyle));
      }
    }
    return spans;
  }

  void _jumpToSpeak() {

  }
}
