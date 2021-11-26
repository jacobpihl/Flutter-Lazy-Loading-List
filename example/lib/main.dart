import 'package:flutter/material.dart';
import 'package:flutter_lazy_loader/flutter_lazy_loader.dart';

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
      home: FlutterLazyLoaderExample(),
    );
  }
}

class FlutterLazyLoaderExample extends StatefulWidget {
  FlutterLazyLoaderExample({Key? key}) : super(key: key);

  final List<int> list = List.generate(100, (index) => index);

  @override
  State<FlutterLazyLoaderExample> createState() =>
      _FlutterLazyLoaderExampleState();
}

class _FlutterLazyLoaderExampleState extends State<FlutterLazyLoaderExample> {
  int _lastIndex = 0;

  Future<List<int>> _dataloader() {
    if (_lastIndex >= widget.list.length) {
      // Returning empty list if we are out of data
      return Future.value(List.empty());
    }

    var _nextIndex = _lastIndex + 5 < widget.list.length
        ? _lastIndex + 5
        : widget.list.length - 1;

    var newListItems = widget.list.getRange(_lastIndex, _nextIndex).toList();
    _lastIndex += 5;

    // Otherwise return the next batch of data
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
        child: FlutterLazyLoader<int>(
          dataLoader: _dataloader,
          listTile: _listTile,
        ),
      ),
    );
  }
}
