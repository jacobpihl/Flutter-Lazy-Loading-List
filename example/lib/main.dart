import 'package:flutter/material.dart';
import 'package:lazy_loading_list/lazy_loading_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lazy loading list demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LazyListExample(),
    );
  }
}

class LazyListExample extends StatefulWidget {
  LazyListExample({Key? key}) : super(key: key);

  final List<int> list = List.generate(100, (index) => index);

  @override
  State<LazyListExample> createState() => _LazyListExampleState();
}

class _LazyListExampleState extends State<LazyListExample> {
  int _lastIndex = 0;

  Future<List<int>> _dataloader() {
    var newListItems =
        widget.list.getRange(_lastIndex, _lastIndex + 5).toList();
    _lastIndex += 5;

    return Future.delayed(const Duration(seconds: 1))
        .then((value) => newListItems);
  }

  Widget _listTile(int data) {
    return ListTile(
      leading: Text(data.toString()),
      title: Text("A list tile from data $data"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List example"),
      ),
      body: Center(
        child: LazyLoadingList<int>(
          dataLoader: _dataloader,
          listTile: _listTile,
        ),
      ),
    );
  }
}
