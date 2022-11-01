import 'dart:async';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;

import 'constants.dart';
import 'main.dart';
import 'models/maindb.dart';
import 'screens/alert_dialog.dart';

class TempProvider with ChangeNotifier {
  //open or closed
  String get template => configDB.get("temp")!;
  List<MainDB> get mainDBList {
    return mainDB.values.toList();
  }

  double get cmp => retCount(mainDBList, "Completed");
  double get inp => retCount(mainDBList, "In Progress");
  double get nst => retCount(mainDBList, "Not Started");

  double retCount(List<MainDB> sam, String st) {
    double _cnt = 0.0;
    if (sam.isNotEmpty) {
      int stCol = int.parse(configDB.get("stCol")!);

      sam.forEach((element) {
        if (element.itemDetails![stCol] == st) {
          _cnt++;
        }
      });
    }

    return _cnt;
  }

  //text or image

  String get type => configDB.get("type")!;

  changeTemplate(String template) async {
    await configDB.put("temp", template);
    notifyListeners();
  }

  changeType(String type) async {
    await configDB.put("type", type);
    notifyListeners();
  }
}

class DBProvider with ChangeNotifier {
  addtoBox(List<List<Data?>> frmExcel) async {
    //print("I am called from line 255 - addtoBox method - provider file");
    String? itemID;
    var temp = TempProvider();
    //clear the existing db
    mainDB.clear();

    int i = 1;
    var hdrList = [];
    for (var ele in frmExcel[0]) {
      if (ele != null) {
        hdrList.add(ele.value.toLowerCase().toString());
      } else {
        hdrList.add("");
      }
    }

    int idCol = hdrList.indexOf("item_id");
    int ahtCol = hdrList.indexOf("aht");
    int stCol = hdrList.indexOf("status");
    int ptCol = hdrList.indexOf("product_type");
    int anCol = hdrList.indexOf("attribute name");

    configDB.put("anCol", anCol.toString());

    configDB.put("actID", frmExcel[1][idCol]!.value.toString());
    configDB.put("pt", frmExcel[1][ptCol]!.value.toString());
    configDB.put("idCol", idCol.toString());
    configDB.put("ptCol", ptCol.toString());
    configDB.put("ahtCol", ahtCol.toString());
    configDB.put("stCol", stCol.toString());

    if (temp.type == "text") {
      int pidCol = 100;
      int nonComCol = 100;

      int titCol = hdrList.indexOf("title");
      int sdCol = hdrList.indexOf("short_description");
      int ldCol = hdrList.indexOf("long_description");
      int pvCol = hdrList.indexOf("product valid?(yes/no)");
      int mcCol = hdrList.indexOf("manual curation");
      int scCol = hdrList.indexOf("standard comments");
      int acCol = hdrList.indexOf("additional comments");
      //int ptCol = hdrList.indexOf("product_type");

      int tmCol = hdrList.indexOf("team");

      if (temp.template == "open") {
        pidCol = hdrList.indexOf("product id");
        nonComCol = hdrList.indexOf("manual curation_non normalised comments");
      }

      //print(idCol);

      configDB.put("titCol", titCol.toString());
      configDB.put("sdCol", sdCol.toString());
      configDB.put("ldCol", ldCol.toString());
      configDB.put("pvCol", pvCol.toString());
      configDB.put("mcCol", mcCol.toString());
      configDB.put("scCol", scCol.toString());
      configDB.put("acCol", acCol.toString());

      configDB.put("tmCol", tmCol.toString());

      if (temp.template == "open") {
        configDB.put("pidCol", pidCol.toString());
        configDB.put("nonComCol", nonComCol.toString());
      }
    }
    if (temp.type == "image") {
      int urlCol = hdrList.indexOf("url");
      int pidCol = hdrList.indexOf("product_id");
      int ptmCol = hdrList.indexOf("pt mismatch");
      int mcCol = hdrList.indexOf("manual curation");
      int scCol = hdrList.indexOf("standard comments");
      int acCol = hdrList.indexOf("additional comments");
      configDB.put("mcCol", mcCol.toString());
      configDB.put("scCol", scCol.toString());
      configDB.put("acCol", acCol.toString());

      configDB.put("pidCol", pidCol.toString());
      configDB.put("urlCol", urlCol.toString());
      configDB.put("ptmCol", ptmCol.toString());
    }

    for (var element in frmExcel) {
      MainDB ls = MainDB();
      ls.itemDetails = [];

      itemID = element[idCol]!.value.toString();
      for (var ele in element) {
        //print(itemID);
        if (ele == null) {
          ls.itemDetails!.add("");
          ls.rwNm = i;
        } else {
          ls.itemDetails!.add(ele.value.toString());
          ls.rwNm = i;
        }
      }
      if (ls.itemDetails![ahtCol] != "AHT") {
        ls.itemDetails![ahtCol] = "0:00:00";
      }

      if (ls.itemDetails![stCol] != "Status") {
        ls.itemDetails![stCol] = "Not Started";
      }

      await mainDB.put(itemID.toString(), ls);

      i++;
    }

    // await changedl(true);
    html.window.location.reload();
  }
}

class BackEndData with ChangeNotifier {
  int _clkInd = 0;
  List<String> _lstWrds = [];
  //List<String> _attrWrds = [];

  int get clkInd => _clkInd;
  List<String> get lstWrds {
    List<String> _lst;

    if (configDB.get("hiWrd") != null) {
      _lst = configDB.get("hiWrd")!.split("|");
    } else {
      _lst = [];
    }
    _lst.removeWhere((item) => item.isEmpty);
    //print(_lst);
    return _lst;
  }

  void addToLstWrds(str) {
    List<String>? dbList;
    if (configDB.get("hiWrd") != null) {
      dbList = configDB.get("hiWrd")!.split("|");
    } else {
      dbList = [];
    }
    if (str != "") {
      _lstWrds = dbList + str.split("\n");

      _lstWrds = _lstWrds.toSet().toList();
      configDB.put("hiWrd", _lstWrds.join("|"));
    }

    notifyListeners();
  }

  void removeFrmLst(str) {
    List<String>? dbList;
    if (configDB.get("hiWrd") != null) {
      dbList = configDB.get("hiWrd")!.split("|");
    } else {
      dbList = [];
    }
    _lstWrds = dbList;
    _lstWrds.remove(str);
    configDB.put("hiWrd", _lstWrds.join("|"));

    notifyListeners();
  }

  void remAllWrds() {
    if (configDB.get("hiWrd") != null) {
      configDB.delete("hiWrd");
    }
    notifyListeners();
  }

  void changeClk(str) {
    _clkInd = str;
    notifyListeners();
  }
}

class DBService with ChangeNotifier {
  String _srchString = "";
  String get srchString => _srchString;
  String _erMsg = "";
  String get erMsg => _erMsg;

  changeVal(String val) {
    _srchString = val;
    notifyListeners();
  }

  changeErr(String val) {
    _erMsg = val;
    notifyListeners();
  }

  List<String> _rs = [];
  List<String> getmc(int colNum) {
    String val = getCellValue(colNum);
    //print(val);
    if (val != "") {
      _rs = val.split("__").toSet().toList();
      return _rs;
    } else {
      return _rs.toSet().toList();
    }
  }

  changers() {
    _rs = [];
    notifyListeners();
  }

  addtors(String txt, int colNo) {
    _rs.add(txt);
    saveToDB(val: _rs.toSet().toList().join("__"), colNo: colNo);
    notifyListeners();
  }

  remfromrs(String txt, int colNo) {
    _rs.remove(txt);

    saveToDB(val: _rs.toSet().toList().join("__"), colNo: colNo);
    notifyListeners();
  }

  List<DataRow> getDB(List<MainDB> md, BuildContext context) {
    List<DataRow> rs = [];

    mainDB.toMap().forEach((key, value) {
      if (key != "Item_id") {
        rs.add(createDataRow(value, context));
      }
    });
    return rs;
  }

  saveToDB({required String val, required int colNo}) {
    String? activeId = configDB.get("actID");
    MainDB? item = mainDB.get(activeId);
    if (val != "") {
      item!.itemDetails![colNo] = val;
    } else {
      item!.itemDetails![colNo] = "";
    }

    mainDB.put(activeId, item);
    //print(val);
    notifyListeners();
  }

  String getCellValue(int colNo) {
    String? activeId = configDB.get("actID");
    if (activeId != "Item_id") {
      MainDB? item = mainDB.get(activeId);
      return item!.itemDetails![colNo]!;
    } else {
      return "";
    }
  }

  String getNext(BuildContext context) {
    _rs = [];
    _erMsg = "";
    int stCol = int.parse(configDB.get("stCol")!);
    String id = configDB.get("actID")!;
    // print("from getNext: $id");
    List<dynamic> itemIds = mainDB.keys.toList();
    //configDB.put("actID", itemIds[itemIds.indexOf(id) + 1]);
    //print(itemIds[itemIds.indexOf(id)]);
    if (itemIds.indexOf(id) + 1 < 0 ||
        itemIds[itemIds.indexOf(id) + 1] == "Item_id" ||
        itemIds[stCol] == "Completed") {
      return "-";
    } else {
      configDB.put("actID", itemIds[itemIds.indexOf(id) + 1]);
      saveToDB(val: "In Progress", colNo: stCol);

      return itemIds[itemIds.indexOf(id) + 1];
    }
  }

  DataRow createDataRow(MainDB item, BuildContext context) {
    int idCol = int.parse(configDB.get("idCol")!);
    int ptCol = int.parse(configDB.get("ptCol")!);
    int anCol = int.parse(configDB.get("anCol")!);
    int stCol = int.parse(configDB.get("stCol")!);
    int ahtCol = int.parse(configDB.get("ahtCol")!);

    DataRow rs = DataRow(
        cells: [
          DataCell(Text(item.itemDetails![idCol]!), onTap: () async {
            if (configDB.get("hiWrd") != null) {
              await configDB.put("actID", item.itemDetails![idCol]!);
              var tm = Provider.of<CustomTimerClass>(context, listen: false);
              tm.startTimer();
              saveToDB(val: "In Progress", colNo: stCol);
              _rs = [];
              _erMsg = "";

              // String path = 'item/:' + item.itemDetails![idCol];

              context.goNamed('item',
                  params: {'itemid': item.itemDetails![idCol]!});
            } else {
              showAlertDialog(context, "No Closed List Values found",
                  "Please add closed list values");
            }

            // context.pop();
          }),
          DataCell(Text(item.itemDetails![ptCol]!)),
          DataCell(Text(item.itemDetails![anCol]!)),
          DataCell(Text(item.itemDetails![stCol]!)),
          DataCell(Text(item.itemDetails![ahtCol]!)),
        ],
        color: (item.itemDetails![stCol] == "Completed")
            ? MaterialStateProperty.all(Colors.green[50])
            : MaterialStateProperty.all(Colors.white10));
    return rs;
  }
}

class CustomTimerClass extends ChangeNotifier {
  int colNo = int.parse(configDB.get("ahtCol")!);
  late Timer _timer;
  int _hour = 0;
  int _minute = 0;
  int _second = 0;

  int get hour => _hour;
  int get minute => _minute;
  int get sec => _second;

  void startTimer() {
    String? activeId = configDB.get("actID");
    List<String> item = mainDB.get(activeId)!.itemDetails![colNo]!.split(":");
    //print("from startTimer: $activeId");

    _hour = int.parse(item[0]);
    _minute = int.parse(item[1]);
    _second = int.parse(item[2]);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      //print(_second);
      if (_second < 59) {
        _second++;
      } else if (_second == 59) {
        _second = 0;
        if (_minute == 59) {
          _hour++;
          _minute = 0;
        } else {
          _minute++;
        }
      }
      notifyListeners();
    });
  }

  void stopTimer() {
    _timer.cancel();

    DBService db = DBService();
    db.saveToDB(
        val: "${twoDigits(_hour)}:${twoDigits(_minute)}:${twoDigits(_second)}",
        colNo: colNo);
    _hour = 0;
    _minute = 0;
    _second = 0;

    notifyListeners();
  }
}



//  configDB.put("idCol", idCol.toString());
//     configDB.put("titCol", titCol.toString());
//     configDB.put("sdCol", sdCol.toString());
//     configDB.put("ldCol", ldCol.toString());
//     configDB.put("pvCol", pvCol.toString());
//     configDB.put("mcCol", mcCol.toString());
//     configDB.put("scCol", scCol.toString());
//     configDB.put("acCol", acCol.toString());
//     configDB.put("ptCol", ptCol.toString());
//     configDB.put("ahtCol", ahtCol.toString());
//     configDB.put("anCol", anCol.toString());
//     configDB.put("tmCol", tmCol.toString());
//     configDB.put("stCol", stCol.toString());