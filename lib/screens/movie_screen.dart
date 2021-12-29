import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:know_your_army/constant.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({Key? key}) : super(key: key);

  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {

  final List<Map<String, dynamic>> _movies = [];
  Future<void> readJSONFile() async {
    final String response = await rootBundle.loadString("assets/json/movies.json");
    final data = await json.decode(response);
    List.from(data["movies"]).forEach((json) => {
      _movies.add(json)
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
        title: const Text("Movies"),
      ),
      body: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(Constant.padding),
        itemCount: _movies.length,
        itemBuilder: (context, index) {
          List<String> genres = (_movies[index]["genres"] as String).split("|");
          List<String> actors = (_movies[index]["actors"] as String).split("|");
          return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constant.radius)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Constant.radius),
                  child: Image.network(
                    _movies[index]['poster_path'],
                    fit: BoxFit.contain,
                    width: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if(loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        "assets/images/error-img.png",
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10,),
                Text(
                  _movies[index]["original_title"],
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.w700
                  ),
                ),
                const SizedBox(height: 10,),
                buildTitle("Summary"),
                Text(
                  _movies[index]["summary"],
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 10,),
                buildTitle("Genre"),
                buildGrid(genres),
                const SizedBox(height: 10,),
                buildTitle("Actors"),
                buildGrid(actors),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 10,),
      ),
    );
  }

  Text buildTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey.shade600,
      ),
    );
  }

  GridView buildGrid(List<String> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 3.6
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(Constant.radius)),
          border: Border.all(color: Constant.bgColor, width: 1)
        ),
        child: Text(
          items[index].toUpperCase(),
          style: const TextStyle(
            color: Constant.bgColor,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
      ),
    );
  }
}
