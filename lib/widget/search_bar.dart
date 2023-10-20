import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/widget/webview_plugin.dart';

enum SearchBarType { home, normal, homeLight } // homeLight: 首页向上拖动屏幕后，搜索栏高亮的样式

class SearchBar extends StatefulWidget {
  final bool? enabled; //是否禁止搜索
  final bool?
      hideLeft; //是否隐藏搜索栏左边的回退按钮。当点击首页上方搜索栏切换到搜索页时是有返回按钮的，但是如果从首页下方搜索TAB切换过去则没有返回按钮
  final SearchBarType searchBarType;
  final String? hint;
  final String? defaultText; //语言搜索时，跳转到搜索页并传递过来的默认搜索关键字
  final void Function()? leftButtonClick; //搜索栏左边回退按钮的回调方法
  final void Function()? rightButtonClick; //搜索栏右边搜索按钮的回调方法
  final void Function()? speakClick; //语音搜索按钮的回调方法
  final void Function()? inputBoxClick; //首页点击搜索栏的回调方法
  final ValueChanged<String>? onChanged;

  SearchBar(
      {this.enabled = true,
      this.hideLeft,
      this.searchBarType = SearchBarType.normal,
      this.hint,
      this.defaultText,
      this.leftButtonClick,
      this.rightButtonClick,
      this.speakClick,
      this.inputBoxClick,
      this.onChanged}); //搜索栏文本改变时的回调方法

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool showClear = false; //当有任意搜索文本时，显示搜索栏右边的清除按钮；否则显示语言搜索按钮
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    //语言搜索时，跳转到搜索页并传递过来的默认搜索关键字
    if (widget.defaultText != null) {
      setState(() {
        _controller.text = widget.defaultText!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.searchBarType == SearchBarType.normal
        ? _genNormalSearch()
        : _genHomeSearch();
  }

  _genNormalSearch() {
    return Container(
        child: Row(
      children: <Widget>[
        _wrapTap(
            Container(
              padding: EdgeInsets.fromLTRB(6, 5, 10, 5),
              child: widget.hideLeft ?? false
                  ? null
                  : const Icon(
                      Icons.arrow_back,
                      color: Colors.grey,
                      size: 26,
                    )
            ),
            widget.leftButtonClick),
        Expanded(flex: 1, child: _inputBox()),
        _wrapTap(
            Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Text(
                  '搜索',
                  style: TextStyle(color: Colors.blue, fontSize: 17),
                )),
            widget.rightButtonClick)
      ],
    ));
  }

  _genHomeSearch() {
    return Container(
        child: Row(
          children: <Widget>[
            _wrapTap(
                Container(
                  padding: EdgeInsets.fromLTRB(6, 5, 5, 5),
                  child: Row(
                    children: <Widget>[
                      Text('上海', style: TextStyle(color: _homeFontColor(), fontSize: 14)),
                      Icon(Icons.expand_more, color: _homeFontColor(), size: 22)
                    ],
                  )
                ),
                widget.leftButtonClick),
            Expanded(flex: 1, child: _inputBox()),
            _wrapTap(
                Container(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Icon(Icons.comment, color: _homeFontColor(), size: 26)),
                widget.rightButtonClick)
          ],
        ));
  }

  _wrapTap(Widget child, void Function()? callback) {
    return GestureDetector(
      onTap: () {
        if (callback != null) {
          callback();
        }
      },
      child: child,
    );
  }

  _inputBox() {
    Color inputBoxColor;
    if (widget.searchBarType == SearchBarType.home) {
      inputBoxColor = Colors.white;
    } else {
      inputBoxColor = Color(int.parse('0xFFEDEDED'));
    }
    return Container(
      height: 45,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
          color: inputBoxColor,
          borderRadius: BorderRadius.circular(
              widget.searchBarType == SearchBarType.normal ? 5 : 15)),
      child: Row(
        children: <Widget>[
          Icon(Icons.search,
              size: 20,
              color: widget.searchBarType == SearchBarType.normal
                  ? const Color(0xffA9A9A9)
                  : Colors.blue),
          Expanded(
            flex: 1,
            child: widget.searchBarType == SearchBarType.normal
                ? TextField(
                    controller: _controller,
                    onChanged: _onTextChanged,
                    autofocus: true,
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w300),
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        border: InputBorder.none,
                        hintText: widget.hint ?? '',
                        hintStyle: TextStyle(fontSize: 15)),
                  )
                : _wrapTap(
                    Container(
                      child: Text(
                        widget.defaultText ?? '',
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ),
                    widget.inputBoxClick),
          ),
          !showClear
              ? _wrapTap(
                  Icon(Icons.mic,
                      size: 22,
                      color: widget.searchBarType == SearchBarType.normal
                          ? Colors.blue
                          : Colors.grey),
                  widget.speakClick)
              : _wrapTap(const Icon(Icons.clear, size: 22, color: Colors.grey), () {
                  setState(() {
                    _controller.clear();
                  });
                  _onTextChanged('');
                })
        ],
      ),
    );
  }

  void _onTextChanged(String text) {
    if (text.isNotEmpty) {
      setState(() {
        showClear = true; //显示清除按钮
      });
    } else {
      setState(() {
        showClear = false; //显示语音搜索按钮
      });
    }
    if (widget.onChanged != null) {
      widget.onChanged!(text);
    }
  }

  _homeFontColor() {
    return widget.searchBarType == SearchBarType.homeLight ? Colors.black54 : Colors.white;
  }
}
