import 'package:pie_chart/pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../provider.dart';

class NewPieChart extends StatelessWidget {
  const NewPieChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var temp = Provider.of<TempProvider>(context, listen: true);

    Map<String, double> dataMap = {
      "Completed": temp.cmp,
      "In Progress": temp.inp,
      "Not Started": temp.nst,
    };

    return (temp.mainDBList.isNotEmpty)
        ? SizedBox(
            child: Column(
              children: [
                const Text("Current Status:"),
                const Divider(
                  thickness: 3,
                ),
                const SizedBox(
                  height: 10,
                ),
                PieChart(dataMap: dataMap),
              ],
            ),
          )
        : const SizedBox();
  }
}
