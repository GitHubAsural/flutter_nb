import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nb/constants/constants.dart';
import 'package:flutter_nb/ui/widget/loading_widget.dart';
import 'package:flutter_nb/ui/widget/more_widgets.dart';
import 'package:flutter_nb/ui/widget/search_appbar.dart';
import 'package:flutter_nb/utils/device_util.dart';
import 'package:flutter_nb/utils/dialog_util.dart';
import 'package:rxdart/rxdart.dart';

/*
*  搜索页
*/
class SearchPage extends StatelessWidget {
  final String function;
  SearchPage(this.function, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    DeviceUtil.setBarStatus(true);
    return new Search(function: function);
  }
}

class Search extends StatefulWidget {
  final String function;
  Search({Key key, this.function}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new SearchState();
  }
}

class SearchState extends State<Search> {
  Operation _operation = new Operation();
  FocusNode _focusNode = FocusNode();
  TextEditingController _controller = new TextEditingController();
  var _items = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new LoadingScaffold(
        operation: _operation,
        backPressType: BackPressType.CLOSE_PARENT, //返回关闭整个页面
        child: new Scaffold(
          backgroundColor: Colors.white,
          primary: true,
          body: SafeArea(
              child: new ListView.builder(
                  itemCount: _items.length, itemBuilder: itemView)),
          appBar: new SearchAppBarWidget(
              focusNode: _focusNode,
              controller: _controller,
              elevation: 2.0,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              inputFormatters: [
                LengthLimitingTextInputFormatter(50),
              ],
              onChangedCallback: () {
                setState(() {
                  _items.clear();
                });
              },
              onEditingComplete: () => _checkInput()),
        ));
  }

  void _checkInput() {
    var username = _controller.text;
    if (username.isEmpty) {
      FocusScope.of(context).requestFocus(_focusNode);
      DialogUtil.buildToast('请输入搜索内容');
      return;
    }
    _doSearch();
  }

  Widget itemView(BuildContext context, int index) {
    Widget resWidget;
    if (Constants.FUNCTION_SEARCH_FRIENDS == widget.function) {
      //搜索朋友列表
      resWidget = MoreWidgets.buildListViewItem(
          'search_friend', _controller.text,
          format: 'jpg', dir: 'icon', padding: 10.0, imageSize: 42.0);
    }
    return resWidget;
  }

  void _doSearch() {
    _items.clear();
    _operation.setShowLoading(true);
    if (Constants.FUNCTION_SEARCH_FRIENDS == widget.function) {
      //搜索朋友列表
      Observable.just(1).delay(new Duration(milliseconds: 1500)).listen((_) {
        _operation.setShowLoading(false);
        setState(() {
          //环信IM SDK 不提供好友查找的服务，如需要查找好友，需要调用开发者自己服务器的用户查询接口。这里模拟加一个好友
          _items.add(0);
        });
      });
    }
  }
}
