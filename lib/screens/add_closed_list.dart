import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider.dart';

class AddWords extends StatelessWidget {
  const AddWords({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    TextEditingController _addWrdsController = TextEditingController();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: MediaQuery.of(context).size.height * .7,
          width: 600,
          color: Colors.orange,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                        controller: _addWrdsController,
                        maxLines: 15,
                        decoration: const InputDecoration(
                          labelText: "Add Closed List Values",
                          border: OutlineInputBorder(),
                        )),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.red),
                          onPressed: () {
                            var of = Provider.of<BackEndData>(context,
                                listen: false);
                            of.remAllWrds();
                            _addWrdsController.text = "";
                          },
                          child: const Text("Remove Closed List Values")),
                      const SizedBox(
                        width: 16,
                      ),
                      ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.green),
                          onPressed: () {
                            var of = Provider.of<BackEndData>(context,
                                listen: false);
                            of.addToLstWrds(_addWrdsController.text);
                            _addWrdsController.text = "";
                          },
                          child: const Text("Add Closed List Values")),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text("Closed List Values Count: " +
                      context.watch<BackEndData>().lstWrds.length.toString()),
                  const SizedBox(height: 15),
                  //const AddHighlter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddHighlter extends StatelessWidget {
  const AddHighlter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Wrap(
            spacing: 6.0, runSpacing: 6.0, children: listChipsCustom(context)),
      ),
    );
  }
}

List<Widget> listChipsCustom(BuildContext context) {
  List<String> lst = context.watch<BackEndData>().lstWrds;

  return lst
      .map((txt) => GestureDetector(
          onTap: () {
            context.read<BackEndData>().removeFrmLst(txt);
          },
          child: Chip(
            label: Text(txt),
          )))
      .toList();
}
