import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wm_iae/constants.dart';
import 'package:wm_iae/screens/add_closed_list.dart';

import '../main.dart';
import '../models/maindb.dart';
import '../provider.dart';
import '../services/useful_methods.dart';
import 'alert_dialog.dart';
import 'cust_drawer.dart';
import 'widgets_collection.dart';

class DashBoardWidget extends StatefulWidget {
  const DashBoardWidget({Key? key}) : super(key: key);

  @override
  State<DashBoardWidget> createState() => _DashBoardWidgetState();
}

class _DashBoardWidgetState extends State<DashBoardWidget> {
  @override
  Widget build(BuildContext context) {
    var temp = Provider.of<TempProvider>(context, listen: true);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(appBarTitle),
          backgroundColor: accentColor,
          actions: [
            const SearchItem(),
            (temp.template == "closed")
                ? IconButton(
                    tooltip: "Add Closed List Values",
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const AddWords();
                          });
                    },
                    icon: const Icon(Icons.new_label_outlined))
                : const SizedBox()
          ],
        ),
        drawer: const CustDrawer(),
        body: ValueListenableBuilder(
          valueListenable: mainDB.listenable(),
          builder: (context, Box<MainDB> ls, _) {
            //print("Dashboard Screen");
            //print(ls.values.toList().length);
            return (mainDB.keys.isNotEmpty)
                ? Center(child: RowWidget(lst: ls.values.toList()))
                : const Center(child: NoFiles());
          },
        ),
      ),
    );
  }
}

class SearchItem extends StatefulWidget {
  const SearchItem({Key? key}) : super(key: key);

  @override
  State<SearchItem> createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  final TextEditingController _txt = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _txt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Row(
        children: [
          SizedBox(
            height: 32,
            width: 200,
            child: TextFormField(
              controller: _txt,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  border: OutlineInputBorder(
                    // width: 0.0 produces a thin "hairline" border
                    borderRadius: BorderRadius.all(Radius.circular(90.0)),
                    borderSide: BorderSide.none,
                  ),
                  hintStyle: TextStyle(
                      color: Colors.black,
                      fontFamily: "WorkSansLight",
                      fontSize: 14),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Search'),
            ),
          ),
          IconButton(
              onPressed: () async {
                List<dynamic> lstKeys = mainDB.keys.toList();
                int stCol = int.parse(configDB.get("stCol")!);
                var temp = Provider.of<TempProvider>(context, listen: false);

                if (lstKeys.contains(_txt.text)) {
                  if (temp.template == "closed") {
                    if (configDB.get("hiWrd") != null) {
                      var tm =
                          Provider.of<CustomTimerClass>(context, listen: false);
                      var prov = Provider.of<DBService>(context, listen: false);
                      await configDB.put("actID", _txt.text);

                      tm.startTimer();
                      prov.saveToDB(val: "In Progress", colNo: stCol);
                      prov.changers();
                      prov.changeErr("");
                      context.goNamed('item', params: {'itemid': _txt.text});
                      _txt.clear();
                    } else {
                      showAlertDialog(context, "No Closed List Values found",
                          "Please add closed list values");
                    }
                  } else if (temp.template == "open") {
                    var tm =
                        Provider.of<CustomTimerClass>(context, listen: false);
                    var prov = Provider.of<DBService>(context, listen: false);
                    await configDB.put("actID", _txt.text);

                    tm.startTimer();
                    prov.saveToDB(val: "In Progress", colNo: stCol);
                    prov.changers();
                    prov.changeErr("");
                    context.goNamed('item', params: {'itemid': _txt.text});
                    _txt.clear();
                  }
                } else {
                  showAlertDialog(context, "Item Not Found!",
                      "Please recheck the item ID. Item ID not found");
                }
              },
              icon: const Icon(Icons.search)),
          const SizedBox(
            width: 28,
          )
        ],
      ),
    );
  }
}

class NoFiles extends StatelessWidget {
  const NoFiles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Image.asset("assets/images/Upload.gif")),
        const SizedBox(height: 16),
        const Text("No Files found. Kindly upload today's workfiles"),
        const SizedBox(height: 16),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
            ),
            onPressed: () async {
              var picked = await FilePicker.platform.pickFiles();
              if (picked != null) {
                const snackBar = SnackBar(
                  content: Text('Data loading....Please wait'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                configDB.put("fName", picked.names[0]!);

                var bytes = picked.files.single.bytes;

                Excel excel = await compute(parseExcelFile, bytes!);

                //var excel = Excel.decodeBytes(bytes!);

                excel.tables["Sheet1"]!
                    .cell(CellIndex.indexByColumnRow(
                        rowIndex: 0,
                        columnIndex: excel.tables["Sheet1"]!.maxCols))
                    .value = "Status";
                var snackBar1 = SnackBar(
                  content: Text(
                      ' ${excel.tables["Sheet1"]!.rows.length - 1} items loaded successfully'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar1);
                var _loading = Provider.of<DBProvider>(context, listen: false);
                try {
                  await _loading.addtoBox(excel.tables["Sheet1"]!.rows);
                } catch (e) {
                  showAlertDialog(context, "Error!",
                      "$e - Please check the column Names and the template selected");
                }

                //ScaffoldMessenger.of(context).showSnackBar(snackBar1);
              }
            },
            child: const Text("Upload Files"))
      ],
    );
  }
}
