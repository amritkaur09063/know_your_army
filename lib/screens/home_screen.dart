import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:know_your_army/models/intro.dart';
import 'package:know_your_army/screens/army_chief_screen.dart';
import 'package:know_your_army/screens/gallery_screen.dart';
import 'package:know_your_army/screens/quiz.dart';

import '../constant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Intro> _items = [];

  Future<void> readJSONFile() async {
    final String response = await rootBundle.loadString("assets/json/Introduction_of_App_2.json");
    final data = await json.decode(response);
    List.from(data["introduction"]).forEach((json) => {
      _items.add(Intro.fromJson(json))
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
        title: Text(widget.title),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: Constant.padding,
          vertical: 10
        ),
        children: <Widget>[
          GridView(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.4
            ),
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const ArmyChiefScreen(
                      title: "Chief of Army Staff",
                      filePath: "assets/json/COAS_1.json",
                      jsonKey: "chiefOfArmyStaff")
                    )
                  );
                },
                child: imageCard("Army Chiefs", Icons.person),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const ArmyChiefScreen(
                      title: "PVC",
                      filePath: "assets/json/heros.json",
                      jsonKey: "heroes_of_the_nation")
                    )
                  );
                },
                child: imageCard("PVC", Icons.settings)
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const QuizScreen())
                  );
                },
                child: imageCard("Quiz", Icons.quiz)
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const GalleryScreen(
                        title: "Images",
                        filePath: "assets/json/Images_for_Gallary_3.json",
                        jsonKey: "Images_for_gallery",
                      ),
                    )
                  );
                },
                child: imageCard("Gallery", Icons.collections),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const GalleryScreen(
                        title: "Gallantry Awards",
                        filePath: "assets/json/gallantry.json",
                        jsonKey: "gallantry_awards",
                      ),
                    )
                  );
                },
                child: imageCard("Gallantry Awards", Icons.military_tech),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const GalleryScreen(
                        title: "Non-Gallantry Awards",
                        filePath: "assets/json/non_gallantry.json",
                        jsonKey: "non_gallantry_awards",
                      ),
                    )
                  );
                },
                child: imageCard("Non Gal. Awards", Icons.military_tech),
              ),
            ],
          ),
          const SizedBox(height: Constant.height),
          _items.isNotEmpty ? ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _items.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(Constant.padding),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Constant.radius)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _items[index].title.trim(),
                      style: GoogleFonts.openSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                    const SizedBox(height: Constant.height),
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _items[index].paragraph.length,
                      itemBuilder: (context, paraIdx) => Text(
                        _items[index].paragraph[paraIdx],
                        style: GoogleFonts.openSans(
                            fontSize: 16,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w600
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      separatorBuilder: (context, index) => const SizedBox(height: 10)
                    )
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 10,),
          ) : const Center(
            child: CircularProgressIndicator(
                color: Colors.white
            ),
          )
        ],
      ),
    );
  }

  Widget imageCard(String name, IconData icon) {
    return Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Constant.radius)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              size: 24,
              color: Colors.grey.shade700,
            ),
            const SizedBox(height: 2),
            Text(
              name,
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                // fontSize: 1,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey
              ),
            )
          ],
        )
    );
  }
}