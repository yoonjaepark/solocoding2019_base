import 'package:flutter/material.dart';
import 'package:solocoding2019_base/BLOCS/DatabaseBloc.dart';

import 'package:solocoding2019_base/models/memo.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // data for testing
  List<Memo> list = [];
  final bloc = MemosBloc();
  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  Widget appBarTitle = new Text(
    "메모",
    style: new TextStyle(color: Colors.white),
  );
  final TextEditingController _searchQuery = new TextEditingController();
  bool _IsSearching;
  String _searchText = "";

  bool _isFab = false;

  _HomeState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _IsSearching = false;
          _searchText = "";
        });
      } else {
        bloc.search(_searchQuery.text);
        setState(() {
          _IsSearching = true;
          _searchText = _searchQuery.text;
        });
      }
    });
  }

  @override
  void dispose() {
    print("####dispose");

    bloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print("####init");
    _IsSearching = false;
    _isFab = false;
  }

  Future onTitlePressed(Memo item) async {
    Navigator.pushNamed(
      context,
      "/detail",
      arguments: (item),
    ).then((value) {
      setState(() {
        _searchText = "";
        _IsSearching = false;
        _isFab = false;
      });
      this._handleSearchEnd();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: appBarTitle, actions: <Widget>[
          new IconButton(
              icon: actionIcon,
              onPressed: () {
                setState(() {
                  if (this.actionIcon.icon == Icons.search) {
                    this.actionIcon = new Icon(
                      Icons.close,
                      color: Colors.white,
                    );
                    this.appBarTitle = new TextField(
                      controller: _searchQuery,
                      style: new TextStyle(
                        color: Colors.white,
                      ),
                      decoration: new InputDecoration(
                          prefixIcon:
                              new Icon(Icons.search, color: Colors.white),
                          hintText: "검색...",
                          hintStyle: new TextStyle(color: Colors.white)),
                    );
                    _handleSearchStart();
                  } else {
                    _handleSearchEnd();
                  }
                });
              })
        ]),
        body: StreamBuilder<List<Memo>>(
            stream: bloc.memos,
            builder:
                (BuildContext context, AsyncSnapshot<List<Memo>> snapshot) {
              return uiBuilder(snapshot);
            }),
        floatingActionButton: _getFAB());
  }

  uiBuilder(AsyncSnapshot<List<Memo>> snapshot) {
    final resultState = snapshot.data;
    return ListView.builder(
        itemCount: resultState == null ? 0 : resultState.length,
        itemBuilder: (BuildContext context, int index) {
          Memo item = resultState[index];
          var updatedAt = DateTime.parse(item.updatedAt);
          var year = updatedAt.year.toString();
          var month = updatedAt.month.toString();
          var day = updatedAt.day.toString();

          if (snapshot.hasData && this._searchText == "") {
            return Dismissible(
              key: Key(item.id.toString()),
              background: Container(color: Colors.red),
              onDismissed: (direction) {
                bloc.delete(item.id);
              },
              child: new Column(
                children: <Widget>[
                  new Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[Text('$year년$month월')]),
                  ListTile(
                    title: Text(item.title),
                    subtitle: Text(item.content[0].content),
                    leading: Text('$day일'),
                    onTap: () {
                      this.onTitlePressed(item);
                    },
                  )
                ],
              ),
            );
          } else {
            return ListTile(
                title: Text(item.title),
                onTap: () {
                  this.onTitlePressed(item);
                });
          }
        });
  }

  Widget _getFAB() {
    return _isFab == false
        ? Padding(
            padding: new EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(
                child: Icon(Icons.more_vert),
                onPressed: () async {
                  // bloc.add(new Memo());
                  setState(() {
                    _isFab = true;
                  });
                }))
        : Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: new EdgeInsets.only(bottom: 10),
                child: FloatingActionButton(
                  heroTag: "title",
                  child: Icon(
                    Icons.sort_by_alpha,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    bloc.setSort("title");
                  },
                ),
              ),
              Padding(
                  padding: new EdgeInsets.only(bottom: 10),
                  child: FloatingActionButton(
                    heroTag: "date",
                    child: Icon(
                      Icons.date_range,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      bloc.setSort("date");
                    },
                  )),
              Padding(
                  padding: new EdgeInsets.only(bottom: 10),
                  child: FloatingActionButton(
                    heroTag: "new",
                    child: Icon(
                      Icons.create,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      bloc.add(new Memo());
                      setState(() {
                        _isFab = false;
                      });
                    },
                  )),
              Padding(
                  padding: new EdgeInsets.only(bottom: 10),
                  child: FloatingActionButton(
                    heroTag: "close",
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _isFab = false;
                      });
                    },
                  )),
            ],
          );
  }

  void _handleSearchStart() {
    setState(() {
      _IsSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        "검색하기",
        style: new TextStyle(color: Colors.white),
      );
      _IsSearching = false;
      bloc.getMemos();
      _searchQuery.clear();
    });
  }
}
