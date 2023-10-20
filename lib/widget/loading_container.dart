import 'package:flutter/material.dart';

class LoadingContainer extends StatelessWidget {
  final Widget child; //加载完成后，要呈现的内容
  final bool isLoading;
  final bool cover;

  LoadingContainer(
      {super.key,
      required this.child,
      required this.isLoading,
      this.cover = false});

  @override
  Widget build(BuildContext context) {
    return !cover
        ? (!isLoading ? child : _loadingView)
        : Stack(
            children: <Widget>[child, isLoading ? _loadingView : Placeholder()],
          );
  } //加载进度条是替换呈现的内容，还是叠加在其内容上面显示

  Widget get _loadingView {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
