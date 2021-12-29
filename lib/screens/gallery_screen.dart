import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constant.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key, this.title, this.filePath, this.jsonKey}) : super(key: key);
  final String? title;
  final String? filePath;
  final String? jsonKey;

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {

  final List<String> _images = [];
  Future<void> readJSONFile() async {
    final String response = await rootBundle.loadString(widget.filePath ?? "");
    final data = await json.decode(response);
    List.from(data[widget.jsonKey ?? ""]).forEach((json) => {
      _images.add(json)
    });
    setState(() { });
  }


  @override
  void initState() {
    readJSONFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Constant.bgColor,
        title: Text(widget.title ?? ""),
      ),
      body: GridView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(Constant.padding),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12
        ),
        itemCount: _images.length,
        itemBuilder: (context, index) => Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Constant.radius)
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Constant.radius),
            child: Image.network(
              _images[index],
              fit: BoxFit.fill,
              loadingBuilder: (context, child, loadingProgress) {
                if(loadingProgress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  "assets/images/error-img.png",
                  fit: BoxFit.fill,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
