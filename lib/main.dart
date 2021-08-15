import 'package:flutter/material.dart';
import 'frame.dart';
import 'options.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme:
          ThemeData(primarySwatch: Colors.red, canvasColor: Colors.orange[100]),
      home: Provider<Options>(
          create: (BuildContext context) => Options(), child: Frame()),
    );
  }
}
