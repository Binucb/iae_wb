import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hashids2/hashids2.dart';
import 'package:provider/provider.dart';
import 'package:wm_iae/constants.dart';
import 'package:wm_iae/provider.dart';

import '../main.dart';
import 'alert_dialog.dart';
import 'widgets_collection.dart';

class LoginScreen extends StatefulWidget {
  static const String route = '/loginscreen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String erMsg = "";
  final TextEditingController _un = TextEditingController();
  final TextEditingController _pwd = TextEditingController();
  String dropdownvalue = "Choose Category";
  String dropdownvalue1 = "Choose PTG";

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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: Scaffold(
        body: Center(
          child: Card(
            elevation: 3,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 0.7,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset("assets/images/login_screen.gif"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      width: MediaQuery.of(context).size.width * 0.305,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                          Text(version),
                          const SizedBox(height: 20),
                          CustomText(
                            un: _un,
                            oText: false,
                            lbl: "Associate ID",
                          ),
                          CustomText(un: _pwd, oText: true, lbl: "Password"),
                          Text(
                            erMsg,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 20),
                          CustomDropdown(
                            dropDownValues: categories,
                            initialValue: initialValue,
                            changeValue: changeValue,
                            header: "Select Template",
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                              ),
                              onPressed: () async {
                                var temp = Provider.of<TempProvider>(context,
                                    listen: false);

                                if (initialValue == "") {
                                  setState(() {
                                    erMsg = "Please select the template";
                                  });
                                } else if (initialValue ==
                                    "Text - Open List - Template") {
                                  temp.changeTemplate("open");
                                  temp.changeType("text");
                                } else if (initialValue ==
                                    "Text - Closed List - Template") {
                                  temp.changeTemplate("closed");
                                  temp.changeType("text");
                                } else if (initialValue ==
                                    "Image - Open List - Template") {
                                  temp.changeTemplate("open");
                                  temp.changeType("image");
                                } else if (initialValue ==
                                    "Image - Closed List - Template") {
                                  temp.changeTemplate("closed");
                                  temp.changeType("image");
                                }

                                //  else if (initialValue ==
                                //         "Open List - Template" ||
                                //     initialValue == "Image - Template") {
                                //   showAlertDialog(context, "Work in Progress",
                                //       "This template is WIP. Please select other templates");
                                // }

                                if (_un.text == "" || _pwd.text == "") {
                                  setState(() {
                                    erMsg =
                                        "Please enter valid Username & Password";
                                  });
                                } else if (pswdChk(_un.text.toString(),
                                    _pwd.text.toString())) {
                                  configDB.put("lStatus", _un.text);
                                  //Navigator.of(context).pop();
                                  _un.text = "";
                                  _pwd.text = "";
                                  context.goNamed('home');
                                } else {
                                  setState(() {
                                    erMsg =
                                        "Incorrect Associate ID & Password combinantion ";
                                  });
                                }

                                // if (dropdownvalue != "Choose Category" &&
                                //     dropdownvalue1 != "Choose PTG") {
                              },
                              child: const Padding(
                                padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              )),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.network(
                                    "https://firebasestorage.googleapis.com/v0/b/wm-sd-ld.appspot.com/o/cgn.png?alt=media&token=837558c0-79f3-4886-a359-63eb995431a7",
                                    height: 50,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _un.dispose();
    _pwd.dispose();
    super.dispose();
  }
}

class CustomText extends StatelessWidget {
  const CustomText({
    Key? key,
    required TextEditingController un,
    required this.oText,
    required this.lbl,
  })  : _un = un,
        super(key: key);

  final TextEditingController _un;
  final bool oText;
  final String lbl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
          style: const TextStyle(color: Colors.black, fontSize: 14),
          controller: _un,
          obscureText: oText,
          maxLines: 1,
          decoration: InputDecoration(
              labelText: lbl,
              labelStyle: TextStyle(
                color: Colors.indigo.shade400,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(
                  color: Colors.indigo.shade400,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(
                  color: Colors.blueGrey,
                  width: 0.5,
                ),
              ))),
    );
  }
}

bool pswdChk(String str1, String str2) {
  if (str2 == retpsw(str1)) {
    return true;
  } else {
    return false;
  }
}

String retpsw(String dat) {
  final hashids = HashIds(
    salt: 'xed4567',
    minHashLength: 8,
    alphabet: 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890',
  );
  String id = dat;
  String res = id.split("").reversed.join("");
  final code = hashids.encode(int.parse(res));

  return code;
}
