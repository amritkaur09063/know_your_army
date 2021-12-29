import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './quiz.dart';


class QuizScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _QuizScreenState();
  }
}
class _QuizScreenState extends State<QuizScreen> {
  static const kPrimaryColor = Color(0xFFF9A826);
  static const kBaseColor = Colors.white;
  static const kDarkColor = Color(0xffbdbdbd);
  static const double kDefaultBorderRadius = 15;
  static const double kDefaultPadding = 18;
  static const double kDefaultVerticalPadding = 10;
  static const double kDefaultMargin = 18;

  PageController _controller = PageController(initialPage: 0);
  int _currentPageIndex = 0;
  int _selectedIndex = -1;

  final List<Map<String, dynamic>> _quiz = [];
  Future<void> readJSONFile() async {
    final String response = await rootBundle.loadString("assets/json/quiz.json");
    final data = await json.decode(response);
    List.from(data["questions"]).forEach((json) => {
      _quiz.add(json)
    });
    setState(() { });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
        backgroundColor: Color(0xFF00E676),
      ),
      body: PageView.builder(
        controller: _controller,
        itemCount: _quiz.length,
        itemBuilder: (pageViewContext, index) {
          return Container(
            margin: EdgeInsets.all(kDefaultMargin),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kDefaultBorderRadius),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(kDefaultBorderRadius),
                        topRight: Radius.circular(kDefaultBorderRadius)
                    ),
                  ),
                  padding: const EdgeInsets.only(
                      top: 15,
                      bottom: 10,
                      left: kDefaultPadding,
                      right: kDefaultPadding),
                  child: Text(
                    _quiz[index]['question'],
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                        fontSize: 16
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(kDefaultBorderRadius),
                            bottomLeft: Radius.circular(kDefaultBorderRadius)
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultVerticalPadding),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: _quiz[index]['answers'].length,
                        itemBuilder: (listViewContext, idx) {
                          return OutlinedButton(
                            style: ButtonStyle(
                                alignment: Alignment.centerLeft,
                                side: MaterialStateProperty.all<BorderSide>(
                                    BorderSide(color: _quiz[index]['selectedAnswer'] == idx ? kPrimaryColor : kDarkColor , width: 1)
                                ),
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    _quiz[index]['selectedAnswer'] == idx ? kPrimaryColor : Colors.white
                                ),
                                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                                    )
                                )
                            ),
                            onPressed: () {
                              _selectedIndex = idx;
                              // _controller.animateToPage(_currentPageIndex + 1, duration: Duration(milliseconds: 1000), curve: Curves.easeInOut);
                              _quiz[index]['selectedAnswer'] = _selectedIndex;
                              setState(() { });
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    _quiz[index]['qAnswer'][idx],
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: _quiz[index]['selectedAnswer'] != idx ? kDarkColor : Colors.white
                                    ),
                                  ),
                                ),
                                _quiz[index]['selectedAnswer'] == idx ? Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: const Icon(Icons.check_circle, color: kBaseColor, size: 22,),
                                ) : Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Container(
                                    height: 22,
                                    width: 22,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(50)),
                                        border: Border.all(color: kDarkColor, width: 1)
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 10,);
                        },
                      )
                  ),
                ),
              ],
            ),
          );
        },
        onPageChanged: (int value) {
          _currentPageIndex = value;
          setState(() { });
        },
      )
    ); //Padding
    //MaterialApp
  }
}