import 'dart:async';

import 'package:solocoding2019_base/Database.dart';
import 'package:solocoding2019_base/models/memo.dart';

class MemosBloc {
  final _memoController = StreamController<List<Memo>>.broadcast();

  get memos => _memoController.stream;

  List sortState = [false, false, "date"]; // 날짜 , 텍스트, 타입

  setSort(type) {
    print(type);
    print(sortState[2]);

    sortState[2] = type;
    var index = type == "date" ? 0 : 1;
    print(index);
    print(sortState[0]);
    print(sortState);
    sortState[index] = !sortState[index];
    getMemos();
  }

  dispose() {
    _memoController.close();
  }

  getMemos() async {
    _memoController.sink.add(await DBProvider.db.getAllMemos(sortState));
  }

  MemosBloc() {
    getMemos();
  }

  blockUnblock(Memo client) {
    DBProvider.db.blockOrUnblock(client);
    getMemos();
  }

  delete(int id) {
    DBProvider.db.deleteMemo(id);
    getMemos();
  }

  update(Memo memo) {
    DBProvider.db.updateMemo(memo);
    getMemos();
  }

  add(Memo memo) {
    DBProvider.db.newMemo(memo);
    getMemos();
  }

  search(String text) async {
    _memoController.sink.add(await DBProvider.db.searchMemo(text));
  }
}
