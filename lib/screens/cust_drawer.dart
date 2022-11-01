import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';

import '../main.dart';
import '../services/useful_methods.dart';
import 'pie_chart_screen.dart';
import 'widgets_collection.dart';

class CustDrawer extends StatelessWidget {
  const CustDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18, 18, 4),
            child: Text(
              "Walmart IAE - WorkBench",
              style: TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Logged in : " +
                    configDB.get("lStatus")! +
                    " | " +
                    configDB.get("temp")!.toUpperCase() +
                    "-" +
                    configDB.get("type")!.toUpperCase() +
                    " Template",
                style: const TextStyle(fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 1),
          const Divider(
            thickness: 1,
            color: Colors.indigo,
          ),
          const SizedBox(
            height: 8,
          ),
          custDrawer(context, Icons.download, () async {
            Navigator.pop(context);
            download(context);
          }, "Download"),
          custDrawer(context, Icons.clear_all, () async {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (BuildContext ctx) {
                return AlertDialog(
                  title: const Text("Delete All items from Backend?"),
                  content: const Text(
                      " All the items loaded previously will be deleted."),
                  actions: [
                    TextButton(
                      child: const Text("Cancel"),
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                    ),
                    TextButton(
                      child: const Text("OK"),
                      onPressed: () {
                        mainDB.clear();

                        ctx.goNamed('home');
                        Navigator.pop(ctx);
                      },
                    ),
                  ],
                );
              },
            );
          }, "Clear Files"),
          custDrawer(context, Icons.description_outlined, () {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (BuildContext ctx) {
                return AlertDialog(
                  title: const Text("Have you downloaded the previous file?"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                          " All the items loaded previously will be deleted when we change the template."),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          height: 48,
                          width: 400,
                          child: TemplateSelection(
                            ctx: ctx,
                          )),
                    ],
                  ),
                  actions: [
                    TextButton(
                      child: const Text("Cancel"),
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                    ),
                  ],
                );
              },
            );
          }, "Change the template"),
          custDrawer(context, Icons.power_settings_new, () async {
            await configDB.delete("lStatus");
            context.goNamed('home');
          }, "Logout"),
          const Spacer(),
          const SizedBox(
            height: 10,
          ),
          const NewPieChart()
        ],
      ),
    );
  }
}
