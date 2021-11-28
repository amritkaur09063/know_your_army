import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:know_your_army/constant.dart';
import 'package:know_your_army/models/army_chief.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ArmyChiefScreen extends StatefulWidget {
  const ArmyChiefScreen({Key? key}) : super(key: key);

  @override
  _ArmyChiefScreenState createState() => _ArmyChiefScreenState();
}

class _ArmyChiefScreenState extends State<ArmyChiefScreen> {

  final PageController _controller = PageController();
  final List<ArmyChief> _chiefs = [];

  Future<void> readJSONFile() async {
    final String response = await rootBundle.loadString("assets/json/COAS_1.json");
    final data = await json.decode(response);
    List.from(data["chiefOfArmyStaff"]).forEach((json) => {
      _chiefs.add(ArmyChief.fromJson(json))
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
        title: const Text("Chief of Army Staff"),
      ),
      body: Column(
        children: [
          _chiefs.isNotEmpty ? Expanded(
            flex: 1,
            child: PageView.builder(
              physics: const BouncingScrollPhysics(),
              controller: _controller,
              itemCount: _chiefs.length,
              itemBuilder: (context, index) => Container(
                margin: const EdgeInsets.all(Constant.margin),
                padding: const EdgeInsets.all(Constant.padding),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Constant.radius)
                ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Constant.radius),
                        child: Image.network(
                          _chiefs[index].img,
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
                          fit: BoxFit.fill,
                        ),
                      )
                    ),
                    const SizedBox(height: 10,),
                    Text(
                      _chiefs[index].name,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                    Text(
                      _chiefs[index].tenure.trim(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600
                      ),
                    )
                  ],
                ),
              ),
            ),
          ) : const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 14
            ),
            child: SmoothPageIndicator(
              controller: _controller,
              count: _chiefs.length,
              effect: const ScrollingDotsEffect(
                activeDotColor: Constant.activeDotColor,
                dotColor: Colors.white,
                // dotWidth: 18,
                radius: 4,
                maxVisibleDots: 9
              ),
            ),
          )
        ],
      )
    );
  }
}
