import 'package:flutter/material.dart';
import 'package:solocoding2019_base/BLOCS/DatabaseBloc.dart';
import 'package:solocoding2019_base/models/memo.dart';

class Detail extends StatefulWidget {
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  final bloc = MemosBloc();
  Memo selectedMemo;
  int selectedLine;
  _DetailState() {}
  TextEditingController _contentController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  didChangeDependencies() {
    print(ModalRoute.of(context).settings.arguments);
    setState(() {
      selectedMemo = ModalRoute.of(context).settings.arguments;
    });
  }

  @override
  Widget build(BuildContext context) {
    // _contentController.text = this.selectedMemo.content[0].content;
    // _titleController.text = this.selectedMemo.title;
    return new Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: true,
            //`true` if you want Flutter to automatically add Back Button when needed,
            //or `false` if you want to force your own back button every where
            title: Text('작성하기'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => this.popPress(context, this.selectedMemo,
                  _titleController, _contentController),
            )),
        body: new Column(
            children: this._buildContent(this.selectedMemo.content)));
  }

  List<Widget> _buildContent(List<MemoContent> contents) {
    List<Widget> _contents = new List();
    _contents.add(GestureDetector(
        onTap: () => {
              setState(() => {selectedLine = -1})
            },
        child: selectedLine == -1
            ? TextField(
                style: new TextStyle(fontSize: 20),
                controller: _titleController,
                maxLines: null,
                maxLengthEnforced: false,
                decoration: new InputDecoration(
                    contentPadding: const EdgeInsets.all(0)),
                keyboardType: TextInputType.multiline,
                onChanged: (text) => this.updateTitleMemo(text))
            : Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    child: Text.rich(TextSpan(
                  style: new TextStyle(fontSize: 20),
                  text: this.selectedMemo.title,
                ))))));

    for (int i = 0; i < contents.length; i++) {
      _contents.add(GestureDetector(
          onTap: () => {
                setState(() => {selectedLine = i})
              },
          child: selectedLine == i
              ? TextField(
                  style: new TextStyle(fontSize: 20),
                  controller: _contentController,
                  maxLines: null,
                  maxLengthEnforced: false,
                  decoration: new InputDecoration(
                      contentPadding: const EdgeInsets.all(0)),
                  keyboardType: TextInputType.multiline,
                  onChanged: (text) => this.updateContnetMemo(text, i))
              : Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      child: Text.rich(TextSpan(
                    style: new TextStyle(fontSize: 20),
                    text: contents[i].content,
                  ))))));
    }
    if (selectedLine != -1 && selectedLine != null) {
      _contentController.text = contents[selectedLine].content;
    }
    _titleController.text = this.selectedMemo.title;
    return _contents;
  }

  updateTitleMemo(String text) {
    Memo tempMemo = this.selectedMemo;
    tempMemo.title = text;
    setState(() {
      selectedMemo = tempMemo;
    });
  }

  updateContnetMemo(String text, int index) async {
    Memo tempMemo = this.selectedMemo;
    tempMemo.content[index] = MemoContent(type: "text", content: text);
    setState(() {
      selectedMemo = tempMemo;
    });
  }

  popPress(context, Memo memo, _titleController, _contentController) async {
    Memo newMemo = new Memo(
        id: memo.id,
        title: _titleController.text,
        content: this.selectedMemo.content,
        updatedAt: memo.updatedAt);
    this.bloc.update(newMemo);
    Navigator.pop(context, false);
  }
}
