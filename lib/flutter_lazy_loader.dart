library flutter_lazy_loader;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef _GenericAsyncCallback<T> = Future<List<T>> Function();
typedef _WidgetFunction<T> = Widget Function(T data);

/// Lazy loading list for flutter
///
/// Takes a `dataLoader` and a `listTile` as parameters
///
/// The `dataloader` is used for loading more data into the list.
/// Should the `dataloader`-function return an empty list it is assumed that this is the end of the data and no more will be loaded.
///
/// The `listTile` is the [Widget] that will be rendered for each data in the list
class FlutterLazyLoader<T> extends StatefulWidget {
  const FlutterLazyLoader({
    Key? key,
    required this.dataLoader,
    required this.listTile,
  }) : super(key: key);

  /// Function responsible for loading more data to the list.
  /// Return an empty list when there is no more data and the list will stop trying to request more.
  final _GenericAsyncCallback<T> dataLoader;

  /// Widget to be displayed for each rendered data in the list
  final _WidgetFunction<T> listTile;

  @override
  _FlutterLazyLoaderState<T> createState() => _FlutterLazyLoaderState();
}

class _FlutterLazyLoaderState<T> extends State<FlutterLazyLoader<T>> {
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

  _handleData(List<T> data) {
    if (data.isEmpty) {
      setState(() {
        _isLoading = false;
        _hasMore = false;
      });
    } else {
      setState(() {
        _isLoading = false;
        _dataList.addAll(data);
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
