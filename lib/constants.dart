import 'package:flutter/material.dart';

String version = "Version - 1.0.6";
String appBarTitle = "Walmart IAE - WorkBench";

final Map<int, Color> color = {
  50: const Color.fromRGBO(2, 50, 160, .1),
  100: const Color.fromRGBO(2, 50, 160, .2),
  200: const Color.fromRGBO(2, 50, 160, .3),
  300: const Color.fromRGBO(2, 50, 160, .4),
  400: const Color.fromRGBO(2, 50, 160, .5),
  500: const Color.fromRGBO(2, 50, 160, .6),
  600: const Color.fromRGBO(2, 50, 160, .7),
  700: const Color.fromRGBO(2, 50, 160, .8),
  800: const Color.fromRGBO(2, 50, 160, .9),
  900: const Color.fromRGBO(2, 50, 160, 1),
};

final MaterialColor accentColor = MaterialColor(0xFF0232a0, color);

String ret(String tst) {
  String test = "";
  List<String> htmlTags = ["<p>", "<ul>", "</li>", "</ul>"];
  test = tst.replaceAll("</p>", "\n\n");
  test = test.replaceAll("<li>", "\n• ");

  for (String ele in htmlTags) {
    test = test.replaceAll(ele, "");
  }

  return removeAllHtmlTags(test);
}

String removeAllHtmlTags(String htmlText) {
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: false);

  return htmlText.replaceAll(exp, ' ');
}

const String addComm =
    "|Data has no value|Invalid Product|Invalid Record|Data Conflicting|Generic Statement|Insufficient/Incomplete data|Multi-Value|Data not clear|Agreed Normalization|Direct & Agreed Normalization|PT Normalization|Based on Title Prioritization|Based on Priority|Other";

const String imgComm =
    "|PT Mismatch|PT Mismatch - Invalid Product|Measurement Chart|Image not available|Zoomed Image|Small Image|Swatch Image|Invalid Product|Unable to Determin|BlurImage|Data has no value|Invalid Product|Invalid Record|Data Conflicting|Generic Statement|Insufficient/Incomplete data|Multi-Value|Data not clear|Agreed Normalization|Direct & Agreed Normalization|PT Normalization|Based on Title Prioritization|Based on Priority|Other";

String twoDigits(int n) => n >= 10 ? "$n" : "0$n";

List<String> fetchURL(String text) {
  List<String> urlList = [];

  RegExp exp = RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
  Iterable<RegExpMatch> matches = exp.allMatches(text);

  for (var match in matches) {
    urlList.add(text.substring(match.start, match.end));
  }
  //print(urlList);

  return urlList;
}
