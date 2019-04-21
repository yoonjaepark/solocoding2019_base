import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';

Memo memoFromJson(String str) {
  final jsonData = json.decode(str);
  return Memo.fromMap(jsonData);
}

String memoToJson(Memo data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Memo {
  int id;
  String title;
  List<MemoContent> content;
  String updatedAt;
  int isDeleted;

  Memo({this.id, this.title, this.content, this.updatedAt, this.isDeleted});

  factory Memo.fromMap(Map<String, dynamic> parsedJson) {
    List<MemoContent> products = new List<MemoContent>();
    List jsonParsed = json.decode(parsedJson['content']);
    for (int i = 0; i < jsonParsed.length; i++) {
      products.add(new MemoContent.fromJson(jsonParsed[i]));
    }
    return new Memo(
        id: parsedJson["id"],
        title: parsedJson["title"],
        content: products,
        // content: codec
        //     .decode((parsedJson['content']))
        //     .map((value) => new MemoContent.fromJson(value))
        //     .toList<MemoContent>(),
        updatedAt: parsedJson["updatedAt"],
        isDeleted: parsedJson["isDeleted"]);
  }

  Map<String, dynamic> toMap() {
    print("#######toMap");
    JsonCodec codec = new JsonCodec();
    // print(codec.encode(content));
    List createDoc = [];

    for (var i = 0; i < content.length; i++) {
      print(content[i].toMap());
      createDoc.add(content[i].toMap());
    }
    return {
      "id": id,
      "title": title,
      "content": codec.encode(createDoc),
      "updatedAt": updatedAt,
      "isDeleted": isDeleted == null ? 0 : isDeleted,
    };
  }
}

class MemoContent {
  String content;
  String type;
  MemoContent({this.content, this.type});

  factory MemoContent.fromJson(Map<String, dynamic> parsedJson) {
    return MemoContent(
      content: parsedJson['content'],
      type: parsedJson['type'],
    );
  }

  // factory MemoContent.fromMap(Map<String, dynamic> parsedJson) {
  //   print("MemoContent");

  //   print(parsedJson);
  //   print(parsedJson["content"]);
  //   return new MemoContent(
  //     content: parsedJson["content"].toString(),
  //     type: parsedJson["type"].toString(),
  //   );
  // }

  Map<String, dynamic> toMap() => {
        "content": content,
        "type": type,
      };
}
