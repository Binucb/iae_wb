import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  final List<String> urlList;

  const ImageScreen({Key? key, required this.urlList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(urlList);
    List<String> rs = ["Work In Progress", "Work In Progress"];
    return InteractiveViewer(
      maxScale: 2.5,
      minScale: 0.5,
      boundaryMargin: const EdgeInsets.all(100),
      scaleEnabled: true,
      panEnabled: false,
      child: ListView.builder(
          itemCount: urlList.length,
          itemBuilder: (context, index) {
            return Center(
              child: Image.network(
                urlList[index],
                height: MediaQuery.of(context).size.height * 0.7,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            );
          }),
    );
  }
}
