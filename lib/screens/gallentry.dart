import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constant.dart';

class GallentryScreen extends StatefulWidget {
  const GallentryScreen({Key? key}) : super(key: key);

  @override
  _GallantryScreenState createState() => _GallentryScreenState();
}

class _GallantryScreenState extends State<GallentryScreen> {

  final List<String> _images = [];
  Future<void> readJSONFile() async {
    final String response = await rootBundle.loadString("assets/json/gallentry.json");
    final data = await json.decode(response);
    List.from(data["Gallentry Awards"]).forEach((json) => {
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
        title: const Text("Gallentry Award"),
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