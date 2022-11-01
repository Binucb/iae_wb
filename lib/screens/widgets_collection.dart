import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wm_iae/constants.dart';
import 'package:wm_iae/main.dart';
import 'package:wm_iae/screens/alert_dialog.dart';

import '../models/maindb.dart';
import '../provider.dart';

//dropdown with list of dropdown values
//searchBox with close list values and field
//Free textBox comments (free text)

class CustomDropdown extends StatelessWidget {
  final String? initialValue;
  final String? header;
  final List<String> dropDownValues;
  final Function(String?)? changeValue;
  const CustomDropdown(
      {Key? key,
      required this.initialValue,
      required this.dropDownValues,
      required this.header,
      required this.changeValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: 263,
      child: DropdownButtonFormField(
        itemHeight: null,
        decoration: InputDecoration(
          // contentPadding:
          //     const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
          labelText: header,
          border: const OutlineInputBorder(),
        ),
        value: initialValue,
        items: dropDownValues.map((String items) {
          return DropdownMenuItem(
            value: items,
            child: Text(
              items,
              style: const TextStyle(fontSize: 14),
            ),
          );
        }).toList(),
        onChanged: changeValue,
      ),
    );
  }
}

class CustomDropdown1 extends StatelessWidget {
  final String? initialValue;
  final String? header;
  final List<String> dropDownValues;
  final int colNo;
  const CustomDropdown1(
      {Key? key,
      required this.initialValue,
      required this.dropDownValues,
      required this.header,
      required this.colNo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: DropdownButtonFormField(
        itemHeight: null,
        decoration: InputDecoration(
          labelText: header,
          border: const OutlineInputBorder(),
        ),
        value: initialValue,
        items: dropDownValues.map((String items) {
          return DropdownMenuItem(
            value: items,
            child: Text(
              items,
              style: const TextStyle(fontSize: 14),
            ),
          );
        }).toList(),
        onChanged: (value) {
          var db = Provider.of<DBService>(context, listen: false);
          db.saveToDB(val: value.toString(), colNo: colNo);
        },
      ),
    );
  }
}

class CustomHeaderText extends StatelessWidget {
  final String? header;
  const CustomHeaderText({Key? key, required this.header}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      header!,
      style: const TextStyle(
          color: Colors.black54, fontSize: 14, fontWeight: FontWeight.bold),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String? header;
  final String? initialValue;
  final int colNo;
  final int maxLines;
  const CustomTextField(
      {Key? key,
      required this.header,
      required this.initialValue,
      required this.maxLines,
      required this.colNo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _txt = TextEditingController();
    _txt.text = initialValue!;
    return Focus(
      onFocusChange: (value) {
        if (value == false) {
          var db = Provider.of<DBService>(context, listen: false);
          db.saveToDB(val: _txt.text.toString(), colNo: colNo);
        }
      },
      child: TextField(
        controller: _txt,
        maxLines: maxLines,
        // onEditingComplete: () {
        //   var db = Provider.of<DBService>(context, listen: false);
        //   db.saveToDB(val: _txt.value.toString(), colNo: colNo);
        // },
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: accentColor, width: 1.0),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
          labelText: header,
        ),
      ),
    );
  }
}

class CustomSearch extends StatelessWidget {
  final int colNum;
  const CustomSearch({Key? key, required this.colNum}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 3,
      runSpacing: 3,
      children: lstClosedListChips(context, colNum),
    );
  }
}

List<Widget> lstClosedListChips(BuildContext context, int colNum) {
  var db = Provider.of<DBService>(context, listen: false);
  List<String> rs = db.getmc(colNum);
  //print("$rs from lstCllsedList Chips");

  List<Widget> chips = [];
  List<String> lstClosed = (db.srchString != "")
      ? configDB
          .get("hiWrd")!
          .split("|")
          .where((element) => element.toLowerCase().contains(db.srchString))
          .toList()
      : configDB.get("hiWrd")!.split("|");

  for (var element in lstClosed) {
    if (element != "") {
      chips.add(ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            primary: (rs.contains(element)) ? Colors.black54 : accentColor,
          ),
          onPressed: () {
            db.addtors(element, colNum);
          },
          child: Text(element)));
    }
  }

  return chips;
}

class ResultField extends StatelessWidget {
  final int colNum;
  const ResultField({Key? key, required this.colNum}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> chips = [];

    return Wrap(
      spacing: 3,
      runSpacing: 3,
      children: lstResultChips(context, colNum),
    );
  }
}

List<Widget> lstResultChips(BuildContext context, int colNum) {
  var db = Provider.of<DBService>(context, listen: false);
  List<String> rs = db.getmc(colNum);
  //print("$rs from lstCllsedList Chips");

  List<Widget> chips = [];
  List<String> lstClosed = configDB.get("hiWrd")!.split("|");

  for (var element in rs) {
    chips.add(ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          primary: Colors.green,
        ),
        onPressed: () {
          db.remfromrs(element, colNum);
        },
        child: Text(element)));
  }

  return chips;
}

Widget custDrawer(BuildContext context, IconData drIcon,
    VoidCallback runFunciton, String lable) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 6, 2, 8),
    child: Row(
      children: [
        Icon(
          drIcon,
          color: Colors.green,
        ),
        TextButton(
            onPressed: runFunciton,
            child: Text(
              lable,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ))
      ],
    ),
  );
}

TextStyle tableHeader = const TextStyle(fontWeight: FontWeight.bold);

class RowWidget extends StatefulWidget {
  final List<MainDB> lst;
  const RowWidget({Key? key, required this.lst}) : super(key: key);

  @override
  State<RowWidget> createState() => _RowWidgetState();
}

class _RowWidgetState extends State<RowWidget> {
  late List<MainDB> items;
  int? sortColIndex;
  bool? isAscending = true;
  int idCol = int.parse(configDB.get("idCol")!);
  int ptCol = int.parse(configDB.get("ptCol")!);
  int anCol = int.parse(configDB.get("anCol")!);
  int stCol = int.parse(configDB.get("stCol")!);
  int ahtCol = int.parse(configDB.get("ahtCol")!);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    items = widget.lst.where((element) {
      return element.itemDetails![idCol].toString() != "Item_id";
    }).toList();

    print(items.length);
  }

  @override
  void didUpdateWidget(covariant RowWidget oldWidget) {
    // TODO: implement didUpdateWidget

    items = widget.lst.where((element) {
      return element.itemDetails![idCol].toString() != "Item_id";
    }).toList();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<DBService>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: buildDataTable(context, items),
        // DataTable(
        //   sortAscending: true,
        //   sortColumnIndex: sortColIndex,
        //   //headingRowColor: MaterialStateProperty.all(Colors.green),
        //   columns: <DataColumn>[
        //     DataColumn(
        //         label: Text(
        //       "Item ID",
        //       style: tableHeader,
        //     )),
        //     DataColumn(
        //         label: Text(
        //       "Product Type",
        //       style: tableHeader,
        //     )),
        //     DataColumn(label: Text("Attribute Name", style: tableHeader)),
        //     DataColumn(label: Text("Status", style: tableHeader)),
        //     DataColumn(label: Text("AHT", style: tableHeader)),
        //   ],
        //   dividerThickness: 2,
        //   rows: prov.getDB(widget.lst, context),
        //   // dataRowColor: MaterialStateProperty.all(Colors.green),
        // ),
      ),
    );
  }

  void onSort(int columnIndex, bool ascending) {
    // int ptCol = int.parse(configDB.get("ptCol")!);
    //int stCol = int.parse(configDB.get("stCol")!);
    if (columnIndex == 1) {
      items.sort((a, b) => compareString(
          ascending, a.itemDetails![ptCol]!, b.itemDetails![ptCol]!));
      //users.sort((user1, user2) =>
      // compareString(ascending, user1.lastName, user2.lastName));
    } else if (columnIndex == 3) {
      //users.sort((user1, user2) =>
      // compareString(ascending, '${user1.age}', '${user2.age}'));
      items.sort((a, b) => compareString(
          ascending, a.itemDetails![stCol]!, b.itemDetails![stCol]!));
    }

    setState(() {
      if (columnIndex == 1 || columnIndex == 3) {
        sortColIndex = columnIndex;
        isAscending = ascending;
      }
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

  Widget buildDataTable(BuildContext context, List<MainDB> lst) {
    var prov = Provider.of<DBService>(context);
    final columns = [
      "Item ID",
      "Product Type",
      "Attribute Name",
      "Status",
      "AHT"
    ];
    return DataTable(
        sortColumnIndex: sortColIndex,
        sortAscending: isAscending!,
        columns: getColumns(columns),
        rows: getRows(items));
    //prov.getDB(lst, context));
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map(
        (String column) => DataColumn(
          onSort: onSort,
          label: Text(
            column,
            style: tableHeader,
          ),
        ),
      )
      .toList();
  List<DataRow> getRows(List<MainDB> items) {
    return items.map((MainDB newLst) {
      final cells = [
        newLst.itemDetails![idCol],
        newLst.itemDetails![ptCol],
        newLst.itemDetails![anCol],
        newLst.itemDetails![stCol],
        newLst.itemDetails![ahtCol]
      ];

      return DataRow(
          cells: getCells(cells),
          color: (cells[3] == "Completed")
              ? MaterialStateProperty.all(Colors.green[50])
              : MaterialStateProperty.all(Colors.white10));
    }).toList();
  }

  List<DataCell> getCells(List<dynamic> cells) {
    return cells.map((data) {
      return DataCell(
        SelectableText('$data'),
        onTap: () async {
          try {
            var temp = Provider.of<TempProvider>(context, listen: false);

            if (temp.template == "closed") {
              if (configDB.get("hiWrd") != null) {
                var tm = Provider.of<CustomTimerClass>(context, listen: false);
                var prov = Provider.of<DBService>(context, listen: false);
                await configDB.put("actID", cells[0]);

                tm.startTimer();
                prov.saveToDB(val: "In Progress", colNo: stCol);
                prov.changers();
                prov.changeErr("");

                // String path = 'item/:' + item.itemDetails![idCol];

                context.goNamed('item', params: {'itemid': cells[0]});
              } else {
                showAlertDialog(context, "No Closed List Values found",
                    "Please add closed list values");
              }
            } else if (temp.template == "open") {
              var tm = Provider.of<CustomTimerClass>(context, listen: false);
              var prov = Provider.of<DBService>(context, listen: false);
              await configDB.put("actID", cells[0]);

              tm.startTimer();
              prov.saveToDB(val: "In Progress", colNo: stCol);
              prov.changers();
              prov.changeErr("");

              // String path = 'item/:' + item.itemDetails![idCol];
              print(cells[0]);

              context.goNamed('item', params: {'itemid': cells[0]});
            }
          } catch (e) {
            showAlertDialog(context, "Error!",
                "$e - Please check the column Names and the template selected");
          }
        },
      );
    }).toList();
  }
}

class CustomTimer extends StatelessWidget {
  const CustomTimer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //var tm = Provider.of<CustomTimerClass>(context, listen: true);
    return Consumer<CustomTimerClass>(builder: ((context, value, child) {
      return Text(
          "${twoDigits(value.hour).toString()}:${twoDigits(value.minute).toString()}:${twoDigits(value.sec).toString()}");
    }));
  }
}

class SearcFeature extends StatefulWidget {
  const SearcFeature({Key? key}) : super(key: key);

  @override
  State<SearcFeature> createState() => _SearcFeatureState();
}

class _SearcFeatureState extends State<SearcFeature> {
  final TextEditingController _searchText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<DBService>(context, listen: true);
    return SizedBox(
      height: 38,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: TextField(
            onChanged: (value) {
              prov.changeVal(value);
            },
            style: TextStyle(
              fontSize: 12.0,
              color: accentColor,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 2),
              prefixIcon: const Icon(Icons.search),
              hintText: "Search",
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: accentColor, width: 32.0),
                  borderRadius: BorderRadius.circular(5.0)),
              // focusedBorder: OutlineInputBorder(
              //     borderSide:
              //         const BorderSide(color: Colors.white, width: 32.0),
              //     borderRadius: BorderRadius.circular(25.0))
            )),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchText.dispose();
  }
}

class TemplateSelection extends StatefulWidget {
  final BuildContext ctx;
  const TemplateSelection({Key? key, required this.ctx}) : super(key: key);

  @override
  State<TemplateSelection> createState() => _TemplateSelectionState();
}

class _TemplateSelectionState extends State<TemplateSelection> {
  String erMsg = "";
  var categories = [
    "",
    "Text - Open List - Template",
    "Text - Closed List - Template",
    "Image - Closed List - Template"
  ];
  var ptgLst = ["Choose PTG"];

  String? initialValue = "";
  void changeValue(String? newString) {
    setState(() {
      initialValue = newString;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: ScrollController(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          (erMsg != "")
              ? Text(
                  erMsg,
                  style: const TextStyle(fontSize: 14, color: Colors.red),
                )
              : const SizedBox(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomDropdown(
                dropDownValues: categories,
                initialValue: initialValue,
                changeValue: changeValue,
                header: "Select Template",
              ),
              const SizedBox(
                width: 8,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  onPressed: () async {
                    mainDB.clear();
                    var temp =
                        Provider.of<TempProvider>(context, listen: false);

                    if (initialValue == "") {
                      setState(() {
                        erMsg = "Please select the template";
                      });
                    } else if (initialValue == "Text - Open List - Template") {
                      temp.changeTemplate("open");
                      temp.changeType("text");
                      Navigator.pop(widget.ctx);
                    } else if (initialValue ==
                        "Text - Closed List - Template") {
                      temp.changeTemplate("closed");
                      temp.changeType("text");
                      Navigator.pop(widget.ctx);
                    } else if (initialValue == "Image - Open List - Template") {
                      temp.changeTemplate("open");
                      temp.changeType("image");
                      Navigator.pop(widget.ctx);
                    } else if (initialValue ==
                        "Image - Closed List - Template") {
                      temp.changeTemplate("closed");
                      temp.changeType("image");
                      Navigator.pop(widget.ctx);
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: Text(
                      "Change",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
