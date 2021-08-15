import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jokeapp/favorites.dart';
import 'package:jokeapp/homepage.dart';
import 'package:jokeapp/options.dart';

enum Pages { HOME, FAVORITES, OPTIONS }

class Frame extends StatelessWidget {
  final ValueNotifier<Pages> pageNotifier = ValueNotifier<Pages>(Pages.HOME);
  final List<Widget> pages;
  final List<String> titles = ["Home", "Favorites", "Options"];
  Frame() : pages = [HomePage(), FavoritesPage(), OptionsPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: ValueListenableBuilder(
            valueListenable: pageNotifier,
            builder: (BuildContext context, Pages val, Widget widg) =>
                Text(titles[val.index])),
      ),
      drawer: Drawer(
        child: ListView(
          children: List<Widget>.generate(
              3,
              (index) => ListTile(
                    title: Text(titles[index]),
                    onTap: () {
                      pageNotifier.value = Pages.values[index];
                      Navigator.pop(context);
                    },
                  )),
        ),
      ),
      body: Container(
        child: ValueListenableBuilder(
          valueListenable: pageNotifier,
          builder: (BuildContext context, Pages page, Widget wdg) =>
              pages[page.index],
        ),
      ),
    );
  }
}
