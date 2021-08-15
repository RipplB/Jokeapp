import 'package:flutter/material.dart';

class Joke extends StatelessWidget {
  final String joketext;
  Joke(String txt) : joketext = txt;
  @override
  Widget build(BuildContext context) => Card(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1000),
          child: Container(
            child: Text(joketext),
            padding: EdgeInsets.all(5),
          ),
        ),
      );
}
