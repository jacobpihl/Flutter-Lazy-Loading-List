library lazy_loading_list;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef GenericAsyncCallback<T> = Future<T> Function();
typedef WidgetFunction<T> = Widget Function(T data);

class LazyLoadingList<T> extends StatefulWidget {
  const LazyLoadingList(
      {Key? key, required this.dataLoader, required this.listTile})
      : super(key: key);

  final GenericAsyncCallback<T?> dataLoader;
  final WidgetFunction<T> listTile;

  @override
  _LazyLoadingListState<T> createState() => _LazyLoadingListState();
}

class _LazyLoadingListState<T> extends State<LazyLoadingList<T>> {
  final List<T> _dataList = List.empty(growable: true);
  final Map<int, Widget> _listTileCache = {};

  bool _isLoading = true;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() {
    _isLoading = true;
    widget.dataLoader().then((data) => _handleData(data));
  }

  _handleData(T? data) {
    if (data == null) {
      setState(() {
        _isLoading = false;
        _hasMore = false;
      });
    } else {
      setState(() {
        _isLoading = false;
        _dataList.add(data);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _hasMore ? _dataList.length + 1 : _dataList.length,
      itemBuilder: (BuildContext context, int index) {
        if (index >= _dataList.length) {
          if (!_isLoading) {
            _loadData();
          }

          return const Center(
            child: SizedBox(
              child: CircularProgressIndicator(),
              height: 24,
              width: 24,
            ),
          );
        }

        if (_listTileCache.containsKey(index)) {
          return _listTileCache[index]!;
        }

        var tile = widget.listTile(_dataList[index]);
        _listTileCache[index] = tile;

        return tile;
      },
    );
  }
}
