import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jokeapp/joke.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'options.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final JokeUpdaterCubit _jokeUpdaterCubit;
  HomePage() : _jokeUpdaterCubit = JokeUpdaterCubit();
  @override
  Widget build(BuildContext context) {
    _jokeUpdaterCubit.setOptions(Provider.of<Options>(context, listen: false));
    _jokeUpdaterCubit.updateJoke();
    return Column(
      children: [
        Spacer(
          flex: 1,
        ),
        Flexible(
          child: Row(
            children: [
              Spacer(),
              Flexible(
                child: Center(
                  child: BlocBuilder<JokeUpdaterCubit, String>(
                      bloc: _jokeUpdaterCubit,
                      builder: (context, state) => Joke(state)),
                ),
                flex: 4,
              ),
              Spacer()
            ],
          ),
          flex: 4,
        ),
        Flexible(
          flex: 2,
          child: Container(
            height: 200,
            child: StatefulBuilder(
              builder: (context, _setState) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    icon: Icon(Provider.of<Options>(context, listen: false)
                            .favorites
                            .contains(_jokeUpdaterCubit.getFavId())
                        ? Icons.star
                        : Icons.star_border),
                    onPressed: () {
                      _setState(() =>
                          Provider.of<Options>(context, listen: false)
                                  .favorites
                                  .contains(_jokeUpdaterCubit.getFavId())
                              ? Provider.of<Options>(context, listen: false)
                                  .favorites
                                  .remove(_jokeUpdaterCubit.getFavId())
                              : Provider.of<Options>(context, listen: false)
                                  .favorites
                                  .add(_jokeUpdaterCubit.getFavId()));
                    },
                    label: Text("Add to favs"),
                  ),
                  TextButton.icon(
                    icon: Icon(Icons.navigate_next),
                    onPressed: () {
                      _setState(() {
                        _jokeUpdaterCubit.updateJoke();
                      });
                    },
                    label: Text("Next joke"),
                  )
                ],
              ),
            ),
          ),
        ),
        Spacer(
          flex: 2,
        )
      ],
    );
  }
}

class JokeUpdaterCubit extends Cubit<String> {
  String _nextJoke = "Click on the button on the bottom right to get a joke!";
  String _currentId = "";
  String _nextId = "";
  List<String> categories;
  List<String> blacklist;
  JokeUpdaterCubit() : super("");

  void setOptions(Options options) {
    categories = options.categories.length != 0 ? options.categories : ["Any"];
    blacklist = options.blacklist;
  }

  void updateJoke() async {
    emit(_nextJoke);
    _currentId = _nextId;
    Response httprq = await get(Uri(
        scheme: "https",
        host: "v2.jokeapi.dev",
        path: "/joke/${categories.join(",")}",
        query: blacklist.join(",")));
    if (httprq.statusCode != 200) {
      _nextJoke = "Error getting joke. Try again later";
    }
    String response = httprq.body;
    Map<String, dynamic> responseJson = jsonDecode(response);
    _nextJoke = responseJson["type"] == "single"
        ? responseJson["joke"]
        : "${responseJson["setup"]}\n\n${responseJson["delivery"]}";
    _nextId = responseJson["id"].toString();
  }

  String getFavId() => _currentId;
}
