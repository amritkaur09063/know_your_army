import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:know_your_army/constant.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LinkScreen extends StatefulWidget {
  const LinkScreen({Key? key}) : super(key: key);

  @override
  _LinkScreenState createState() => _LinkScreenState();
}

class _LinkScreenState extends State<LinkScreen> {

  final List<Map<String, dynamic>> _links = [];

  Future<void> readJSONFile() async {
    final String response = await rootBundle.loadString("assets/json/important_links.json");
    final data = await json.decode(response);
    List.from(data["important_links"]).forEach((json) => {
      _links.add(json)
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
        elevation: 0,
        backgroundColor: Constant.bgColor,
        title: const Text("Links"),
      ),
      backgroundColor: Constant.bgColor,
      body: ListView.separated(
        padding: const EdgeInsets.all(Constant.padding),
        physics: const BouncingScrollPhysics(),
        itemCount: _links.length,
        itemBuilder: (context, index) {
          return Container(
            // height: 100
            padding: EdgeInsets.all(Constant.padding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constant.radius)
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _links[index]["title"],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                      Text(
                        _links[index]["link"],
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12
                        ),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => WebViewScreen(link: _links[index]["link"]))
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(Constant.padding),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade600,
                      borderRadius: BorderRadius.circular(Constant.radius)
                    ),
                    child: const Text(
                      "Open Link",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 10),
      ),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({Key? key, required this.link}) : super(key: key);
  final String? link;

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Constant.bgColor,
      ),
      backgroundColor: Constant.bgColor,
      body: WebView(
        initialUrl: widget.link
      ),
    );
  }
}
