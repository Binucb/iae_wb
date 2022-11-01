import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:wm_iae/constants.dart';
import 'package:wm_iae/models/maindb.dart';

import '../main.dart';
import '../provider.dart';
import 'cust_drawer.dart';
import 'image_screen.dart';
import 'widgets_collection.dart';

class MyHomePage extends StatelessWidget {
  final MainDB item;
  const MyHomePage({Key? key, required this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    int idCol = int.parse(configDB.get("idCol")!);
    int ptCol = int.parse(configDB.get("ptCol")!);
    List<dynamic> lstKeys = mainDB.keys.toList();
    int ttlItems = lstKeys.length - 1;
    int indItem = lstKeys.indexOf(item.itemDetails![idCol]) + 1;

    return Scaffold(
        drawerEnableOpenDragGesture: false,
        drawer: const CustDrawer(),
        appBar: AppBar(
          backgroundColor: accentColor,
          title: Row(
            children: [
              Text(appBarTitle),
              const SizedBox(
                width: 15,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("ITEM ID : ",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    )),
              ),
              SelectableText(
                item.itemDetails![idCol]!,
                style: const TextStyle(fontSize: 14),
              ),
              const Icon(
                Icons.chevron_right,
                color: Colors.white70,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("PT : ",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    )),
              ),
              SelectableText(item.itemDetails![ptCol]!,
                  style: const TextStyle(fontSize: 14)),
              const SizedBox(
                width: 40,
              ),
              Text("< $indItem of $ttlItems >",
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  )),
            ],
          ),
          actions: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CustomTimer(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  onPressed: () {
                    context.read<CustomTimerClass>().stopTimer();
                    context.goNamed('home');
                  },
                  icon: const Icon(Icons.home),
                  label: const Text("Home")),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
          child: LayoutWidget(
            item: item,
          ),
        ));
  }
}

class LayoutWidget extends StatelessWidget {
  final MainDB item;
  const LayoutWidget({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var db = Provider.of<DBService>(context, listen: true);

    var temp = Provider.of<TempProvider>(context, listen: true);
    int? nonComCol;
    int? urlCol;
    int? ptmCol;
    int? sdCol;
    int? ldCol;
    int? pnCol;
    int? pvCol;

    if (temp.type == "text") {
      sdCol = int.parse(configDB.get("sdCol")!);
      ldCol = int.parse(configDB.get("ldCol")!);
      pnCol = int.parse(configDB.get("titCol")!);
      pvCol = int.parse(configDB.get("pvCol")!);
    }

    int stCol = int.parse(configDB.get("stCol")!);
    int ahtCol = int.parse(configDB.get("ahtCol")!);

    int scCol = int.parse(configDB.get("scCol")!);
    int acCol = int.parse(configDB.get("acCol")!);
    int mcCol = int.parse(configDB.get("mcCol")!);
    if (temp.template == "open") {
      nonComCol = int.parse(configDB.get("nonComCol")!);
    }
    if (temp.type == "image") {
      urlCol = int.parse(configDB.get("urlCol").toString());
      ptmCol = int.parse(configDB.get("ptmCol").toString());
    }

    //String? initialValue = "";
    // void changeValue(String? newString) {
    //   initialValue = newString;
    // }

    var ht = MediaQuery.of(context).size.height;
    var wd = MediaQuery.of(context).size.width;
    return Row(
      //mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (temp.type == "text")
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                    child: Card(
                      color: Colors.white,
                      child: SizedBox(
                        height: ht * 0.08,
                        width: wd * 0.65,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: SelectableText(
                            item.itemDetails![pnCol!]!,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
            const SizedBox(
              height: 10,
            ),
            (temp.type == "text")
                ? Row(
                    children: [
                      //sd
                      CustomColumnWidget(
                        ht: ht,
                        wd: wd,
                        header: "Product Short Description",
                        content: item.itemDetails![sdCol!]!,
                      ),
                      CustomColumnWidget(
                        ht: ht,
                        wd: wd,
                        header: "Product Long Description",
                        content: item.itemDetails![ldCol!]!,
                      ),
                      //ld
                    ],
                  )
                : SizedBox(
                    height: ht * 0.74,
                    width: wd * 0.644,
                    child: ImageScreen(
                      urlList: fetchURL(
                        db.getCellValue(urlCol!),
                      ),
                    ),
                  )
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
          child: Card(
            color: Colors.white,
            child: SizedBox(
              height: ht * 0.94,
              width: wd * 0.32,
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 6,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 0),
                      child: (temp.type == "text")
                          ? CustomDropdown1(
                              dropDownValues: const [
                                "",
                                "Yes",
                                "No",
                                "Query",
                                "Unable to determine"
                              ],
                              initialValue: db.getCellValue(pvCol!),
                              colNo: pvCol,
                              header: "Product Validation",
                            )
                          : CustomDropdown1(
                              dropDownValues: const [
                                "",
                                "Yes",
                                "No",
                                "Query",
                                "Unable to determine"
                              ],
                              initialValue: db.getCellValue(ptmCol!),
                              colNo: ptmCol,
                              header: "PT Mismatch",
                            ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    (temp.template == "open")
                        ? const SizedBox(
                            height: 4,
                          )
                        : const SizedBox(),
                    (temp.template == "closed")
                        ? const CustomHeaderText(
                            header: "Manual Curation",
                          )
                        : const SizedBox(),
                    (temp.template == "closed")
                        ? Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.width * 0.06,
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5.0)),
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SingleChildScrollView(
                                        controller: ScrollController(),
                                        child: ResultField(colNum: mcCol))),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 4, 8, 0),
                            child: CustomTextField(
                              header: "Manual Curation",
                              maxLines: 4,
                              initialValue: db.getCellValue(mcCol),
                              colNo: mcCol,
                            ),
                          ),
                    (temp.template == "open")
                        ? const SizedBox(
                            height: 3,
                          )
                        : const SizedBox(),
                    (temp.template == "closed")
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.30,
                              child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0)),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.2265,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: SingleChildScrollView(
                                              controller: ScrollController(),
                                              child:
                                                  CustomSearch(colNum: mcCol)),
                                        ),
                                      ),
                                      //const Spacer(),
                                      const SearcFeature()
                                    ],
                                  )),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 4, 8, 0),
                            child: CustomTextField(
                              header: "Manual Curation_Non Normalised Comments",
                              maxLines: 5,
                              initialValue: db.getCellValue(nonComCol!),
                              colNo: nonComCol,
                            ),
                          ),
                    (temp.template == "open")
                        ? const SizedBox(
                            height: 4,
                          )
                        : const SizedBox(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 4, 8, 0),
                      child: CustomDropdown1(
                        dropDownValues: (temp.type == "text")
                            ? addComm.split("|")
                            : imgComm.split("|"),
                        initialValue: db.getCellValue(scCol),
                        colNo: scCol,
                        header: "Standard Comments",
                      ),
                    ),
                    (temp.template == "open")
                        ? const SizedBox(
                            height: 4,
                          )
                        : const SizedBox(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 4, 8, 0),
                      child: CustomTextField(
                        header: "Additional Comments",
                        maxLines: 3,
                        initialValue: db.getCellValue(acCol),
                        colNo: acCol,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      db.erMsg,
                      style: const TextStyle(color: Colors.red, fontSize: 15),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton.icon(
                              icon: const Icon(
                                Icons.fast_forward,
                                color: Colors.green,
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.black87),
                              onPressed: () async {
                                var db = Provider.of<DBService>(context,
                                    listen: false);

                                if (temp.type == "text") {
                                  if (db.getCellValue(pvCol!) == "") {
                                    db.changeErr(
                                        "Product Validation cannot be blank.");
                                  } else if (db.getCellValue(mcCol) == "") {
                                    db.changeErr(
                                        "Manual Curation cannot be blank.");
                                  } else {
                                    db.saveToDB(val: "Completed", colNo: stCol);
                                    context
                                        .read<CustomTimerClass>()
                                        .stopTimer();

                                    String nextID = db.getNext(context);
                                    print("Next Id: $nextID");

                                    if (nextID != "-") {
                                      context
                                          .read<CustomTimerClass>()
                                          .startTimer();
                                      context.goNamed('item',
                                          params: {'itemid': nextID});
                                    } else {
                                      context.pop();
                                      context.goNamed('home');
                                    }

                                    //context.goNamed('home');
                                  }
                                } else if (temp.type == "image") {
                                  if (db.getCellValue(ptmCol!) == "") {
                                    db.changeErr(
                                        "Product Validation cannot be blank.");
                                  } else if (db.getCellValue(mcCol) == "") {
                                    db.changeErr(
                                        "Manual Curation cannot be blank.");
                                  }
                                  // else if (db.getCellValue(scCol) == "") {
                                  //   db.changeErr(
                                  //       "Standard Comments cannot be blank.");
                                  // }
                                  else {
                                    db.saveToDB(val: "Completed", colNo: stCol);
                                    context
                                        .read<CustomTimerClass>()
                                        .stopTimer();

                                    String nextID = db.getNext(context);
                                    print("Next Id: $nextID");

                                    if (nextID != "-") {
                                      context
                                          .read<CustomTimerClass>()
                                          .startTimer();
                                      context.goNamed('item',
                                          params: {'itemid': nextID});
                                    } else {
                                      context.pop();
                                      context.goNamed('home');
                                    }

                                    //context.goNamed('home');
                                  }
                                }
                              },
                              label: const Text(
                                "   Next Item  ",
                                style: TextStyle(fontSize: 14),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton.icon(
                              icon: const Icon(
                                Icons.close_outlined,
                                color: Colors.red,
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.black87),
                              onPressed: () async {
                                var db = Provider.of<DBService>(context,
                                    listen: false);

                                if (temp.type == "text") {
                                  if (db.getCellValue(pvCol!) == "") {
                                    db.changeErr(
                                        "Product Validation cannot be blank.");
                                  } else if (db.getCellValue(mcCol) == "") {
                                    db.changeErr(
                                        "Manual Curation cannot be blank.");
                                  }
                                  //  else if (db.getCellValue(scCol) == "") {
                                  //   db.changeErr(
                                  //       "Standard Comments cannot be blank.");
                                  // }
                                  else {
                                    db.saveToDB(val: "Completed", colNo: stCol);
                                    context
                                        .read<CustomTimerClass>()
                                        .stopTimer();

                                    // String nextID = db.getNext(context);
                                    //print("Next Id: $nextID");

                                    //context.pop();
                                    context.goNamed('home');

                                    //context.goNamed('home');
                                  }
                                } else if (temp.type == "image") {
                                  if (db.getCellValue(ptmCol!) == "") {
                                    db.changeErr(
                                        "Product Validation cannot be blank.");
                                  } else if (db.getCellValue(mcCol) == "") {
                                    db.changeErr(
                                        "Manual Curation cannot be blank.");
                                  }
                                  // else if (db.getCellValue(scCol) == "") {
                                  //   db.changeErr(
                                  //       "Standard Comments cannot be blank.");
                                  // }
                                  else {
                                    db.saveToDB(val: "Completed", colNo: stCol);
                                    context
                                        .read<CustomTimerClass>()
                                        .stopTimer();

                                    // String nextID = db.getNext(context);
                                    //print("Next Id: $nextID");

                                    //context.pop();
                                    context.goNamed('home');

                                    //context.goNamed('home');
                                  }
                                }
                              },
                              label: const Text(
                                "Save & Exit",
                                style: TextStyle(fontSize: 14),
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class CustomColumnWidget extends StatelessWidget {
  const CustomColumnWidget({
    Key? key,
    required this.ht,
    required this.wd,
    required this.header,
    required this.content,
  }) : super(key: key);

  final double ht;
  final double wd;
  final String header;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          color: Colors.white,
          child: SizedBox(
            height: ht * 0.37,
            width: wd * 0.322,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const SizedBox(
                  height: 15,
                ),
                Positioned(
                    left: 120,
                    top: -10,
                    child: Chip(
                      label: Text(
                        header,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      backgroundColor: Colors.black87.withOpacity(0.7),
                    )),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(8, 24.0, 8, 8),
                    child: EasyRichText(
                      content,
                      selectable: true,
                      caseSensitive: false,
                      // patternList: [
                      //   EasyRichTextPattern(
                      //       matchWordBoundaries: false,
                      //       targetString:
                      //           context.watch<BackEndData>().lstWrds,
                      //       style: const TextStyle(
                      //           color: Colors.white,
                      //           backgroundColor: Colors.blue)),
                      // ]
                    )
                    // SelectableText(
                    //   content,
                    //   style: const TextStyle(color: Colors.black),
                    // ),
                    ),
              ],
            ),
          ),
        ),
        Card(
          color: Colors.white,
          child: SizedBox(
            height: ht * 0.39,
            width: wd * 0.322,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 24.0, 8, 8),
                child: EasyRichText(
                  ret(content),
                  selectable: true,
                  caseSensitive: false,
                  // patternList: [
                  //   EasyRichTextPattern(
                  //       matchWordBoundaries: false,
                  //       targetString: context.watch<BackEndData>().lstWrds,
                  //       style: const TextStyle(
                  //           color: Colors.white,
                  //           backgroundColor: Colors.blue)),
                  // ]
                )
                // SelectableText(
                //   ret(content),
                //   style: const TextStyle(color: Colors.black),
                // ),
                ),
          ),
        ),
      ],
    );
  }
}
