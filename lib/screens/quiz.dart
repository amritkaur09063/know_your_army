import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:know_your_army/constant.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import './quiz.dart';


class QuizScreen extends StatefulWidget {
  const QuizScreen({ Key? key }): super(key: key);
  @override
  State<StatefulWidget> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  static const kDarkColor = Color(0xffbdbdbd);
  static const double kDefaultBorderRadius = 15;
  static const double kDefaultPadding = 18;
  static const double kDefaultVerticalPadding = 10;
  static const double kDefaultMargin = 18;

  final PageController _controller = PageController(initialPage: 0);
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
  void initState() {
    // TODO: implement initState
    readJSONFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        elevation: 0,
        backgroundColor: Constant.bgColor,
      ),
      backgroundColor: Constant.bgColor,
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold
                ),
                children: [
                  const TextSpan(text: "Q "),
                  TextSpan(
                    text: "${_currentPageIndex + 1}",
                    style: const TextStyle(
                      color: Colors.amber
                    )
                  ),
                  const TextSpan(text: " / "),
                  TextSpan(
                      text: "${_quiz.length}"
                  ),
                ]
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: PageView.builder(
              controller: _controller,
              itemCount: _quiz.length,
              itemBuilder: (pageViewContext, index) {
                return Container(
                  margin: const EdgeInsets.all(kDefaultMargin),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
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
                          _quiz[index]['question'].trim(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Constant.bgColor,
                            fontSize: 16
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
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
                                        BorderSide(color: _quiz[index]['selectedAnswer'] == idx ? Colors.grey.shade400 : kDarkColor , width: 1)
                                    ),
                                    backgroundColor: MaterialStateProperty.all<Color>(
                                        _quiz[index]['selectedAnswer'] == idx ? Colors.grey.shade400 : Colors.white
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
                                        _quiz[index]['answers'][idx],
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: _quiz[index]['selectedAnswer'] != idx ? kDarkColor : Colors.white
                                        ),
                                      ),
                                    ),
                                    _quiz[index]['selectedAnswer'] == idx ? const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 4),
                                      child: Icon(Icons.check_circle, color: Colors.white, size: 22,),
                                    ) : Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4),
                                      child: Container(
                                        height: 22,
                                        width: 22,
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(50)),
                                            border: Border.all(color: kDarkColor, width: 1)
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(height: 10);
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 14
            ),
            child: SmoothPageIndicator(
              controller: _controller,
              count: _quiz.length,
              effect: const ScrollingDotsEffect(
                activeDotColor: Colors.amber,
                dotColor: Colors.white,
                // dotWidth: 18,
                // radius: 4,
                maxVisibleDots: 7,
              ),
            ),
          )
        ],
      )
    ); //Padding
    //MaterialApp
  }
}