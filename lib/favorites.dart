import 'package:flutter/material.dart';
import 'package:jokeapp/joke.dart';
import 'package:provider/provider.dart';
import 'options.dart';
import 'package:http/http.dart';
import 'dart:convert';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) => ListView.builder(
      itemCount: Provider.of<Options>(context).favorites.length,
      itemBuilder: (context, index) => FavoriteTile(
          Provider.of<Options>(context).favorites[index], index, this));
  void rebuild() => setState(() {});
}

class FavoriteTile extends StatelessWidget {
  final String id;
  final int index;
  final _FavoritesPageState container;
  FavoriteTile(this.id, this.index, this.container) : super();
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: FutureBuilder(
          future: get(Uri(
              scheme: "https",
              host: "v2.jokeapi.dev",
              path: "/joke/Any",
              query: "idRange=$id")),
          builder: (BuildContext context, AsyncSnapshot<Response> rp) =>
              rp.hasData
                  ? Text(
                      jsonDecode(rp.data.body)["type"] == "single"
                          ? jsonDecode(rp.data.body)["joke"]
                          : jsonDecode(rp.data.body)["setup"],
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                    )
                  : LinearProgressIndicator()),
      trailing: FavStar(id, Provider.of<Options>(context, listen: false)),
      onTap: () async {
        Options _options = Provider.of<Options>(context, listen: false);
        String res = await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => FavJoke(id, index, _options)));
        while (res != null) {
          _options = Provider.of<Options>(context, listen: false);
          res = await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  FavJoke(res, _options.favorites.indexOf(res), _options)));
        }
        container.rebuild();
      },
    );
  }
}

class FavJoke extends StatelessWidget {
  final String id, previd, nextid;
  final int index, maxindex;
  final Options _options;
  FavJoke(this.id, this.index, this._options)
      : maxindex = _options.favorites.length - 1,
        previd = index != 0 ? _options.favorites[index - 1] : null,
        nextid = index != _options.favorites.length - 1
            ? _options.favorites[index + 1]
            : null,
        super();
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop<String>(null),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              FutureBuilder(
                  future: get(Uri(
                      scheme: "https",
                      host: "v2.jokeapi.dev",
                      path: "/joke/Any",
                      query: "idRange=$id")),
                  builder: (BuildContext context, AsyncSnapshot<Response> rp) =>
                      rp.hasData
                          ? Joke(
                              jsonDecode(rp.data.body)["type"] == "single"
                                  ? jsonDecode(rp.data.body)["joke"]
                                  : "${jsonDecode(rp.data.body)["setup"]}\n\n${jsonDecode(rp.data.body)["delivery"]}",
                            )
                          : CircularProgressIndicator()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                      onPressed: () {
                        if (index != 0) {
                          Navigator.of(context).pop<String>(previd);
                        }
                      },
                      icon: Icon(Icons.arrow_back_ios_outlined),
                      label: Text("Previous favorite")),
                  FavStar(id, _options),
                  TextButton(
                      onPressed: () {
                        if (index != maxindex) {
                          Navigator.of(context).pop<String>(nextid);
                        }
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 8,
                          ),
                          Text("Next favorite"),
                          SizedBox(
                            width: 8,
                          ),
                          Icon(Icons.arrow_forward_ios_outlined),
                          SizedBox(
                            width: 8,
                          )
                        ],
                      )),
                ],
              )
            ],
          ),
        ),
      );
}

class FavStar extends StatelessWidget {
  final String id;
  final Options _options;
  FavStar(this.id, this._options) : super();
  @override
  Widget build(BuildContext context) => StatefulBuilder(
        builder: (context, _setState) => IconButton(
            icon: Icon(
              _options.favorites.contains(id) ? Icons.star : Icons.star_border,
              color: Colors.red,
            ),
            onPressed: () => _setState(() => _options.favorites.contains(id)
                ? _options.favorites.remove(id)
                : _options.favorites.add(id))),
      );
}
