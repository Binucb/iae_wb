import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:protect/protect.dart';

import '../main.dart';
import '../models/maindb.dart';

Future<Excel> parseExcelFile(Uint8List? _bytes) async {
  List<int> bytes = List.from(_bytes!);

  return Excel.decodeBytes(bytes);
}

void download(BuildContext context) async {
  var excel = Excel.createExcel();
  Sheet sheetObject = excel['Sheet1'];
  int i = 1;
  print("from download method");
  print(i);
  //List<String> dataList = [];
  // mainDB.close();
  // mainDB = await Hive.openBox<MainDB>('mainDB');
  mainDB = await Hive.openBox<MainDB>('mainDB');

  MainDB? headers = mainDB.get("Item_id");
  print(headers!.itemDetails!.length);
  headers.itemDetails!.add("Emp ID");
  sheetObject.insertRowIterables(headers.itemDetails as List<String>, 0);



  int idCol = int.parse(configDB.get("idCol")!);
  int stCol = int.parse(configDB.get("stCol")!);
  String? fname = configDB.get("fName") ?? "output.xlsx";



  try {
  
    mainDB.values.toList().forEach((ele) {
      if (ele.itemDetails![idCol] != "Item_id" &&
          ele.itemDetails![stCol] == "Completed") {
        ele.itemDetails!.add(configDB.get("lStatus")!);
        sheetObject.insertRowIterables(ele.itemDetails as List<String>, i);
        i++;
      }
    });
  } catch (e) {
    print(e.toString());
  }


  excel.save(fileName: fname);
}
