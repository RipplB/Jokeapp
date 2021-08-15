import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OptionsPage extends StatelessWidget {
  final List<String> categories = [
    "Misc",
    "Programming",
    "Dark",
    "Pun",
    "Spooky",
    "Christmas"
  ];
  final List<String> flags = [
    "nsfw",
    "religious",
    "political",
    "racist",
    "sexist",
    "explicit"
  ];
  @override
  Widget build(BuildContext context) => ListView(children: [
        Divider(),
        Text(
          "Categories:",
          style: TextStyle(fontSize: 25),
        ),
        Column(
          children: List<Widget>.generate(
              categories.length,
              (index) => StatefulBuilder(
                    builder: (context, _setState) => CheckboxListTile(
                      value: Provider.of<Options>(context, listen: true)
                          .categories
                          .contains(categories[index]),
                      onChanged: (bool val) {
                        _setState(() => val
                            ? Provider.of<Options>(context, listen: false)
                                .categories
                                .add(categories[index])
                            : Provider.of<Options>(context, listen: false)
                                .categories
                                .remove(categories[index]));
                      },
                      title: Text(categories[index]),
                    ),
                  )),
        ),
        Divider(),
        Text("Blacklist", style: TextStyle(fontSize: 25)),
        Column(
          children: List<Widget>.generate(
              flags.length,
              (index) => StatefulBuilder(
                    builder: (context, _setState) => CheckboxListTile(
                      value: Provider.of<Options>(context, listen: true)
                          .blacklist
                          .contains(flags[index]),
                      onChanged: (bool val) {
                        _setState(() => val
                            ? Provider.of<Options>(context, listen: false)
                                .blacklist
                                .add(flags[index])
                            : Provider.of<Options>(context, listen: false)
                                .blacklist
                                .remove(flags[index]));
                      },
                      title: Text(flags[index]),
                    ),
                  )),
        ),
      ]);
}

class Options {
  List<String> categories;
  List<String> blacklist;
  List<String> favorites;
  Options()
      : categories = List<String>.empty(growable: true),
        blacklist = List<String>.empty(growable: true),
        favorites = List<String>.empty(growable: true);
}
