import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'model/sentiment_model_with_emoji.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _controller;
  late List<Widget> _children;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  int positiveResponse = 0;
  int negativeResponse = 0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _children = [];
    _children.add(Container());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Write your feedback'),
      ),
      body: Container(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: <Widget>[
            Expanded(
                child: ListView.builder(
                  itemCount: _children.length,
                  itemBuilder: (_, index) {
                    return _children[index];
                  },
                )),
            Container(
              padding: const EdgeInsets.all(8),
              decoration:
              BoxDecoration(border: Border.all(color: Colors.orangeAccent)),
              child: Row(children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration:
                    const InputDecoration(hintText: 'Write some text here'),
                    controller: _controller,
                  ),
                ),
                TextButton(
                  child: const Text('Classify'),
                  onPressed: () {
                    final text = _controller.text;
                    final prediction =
                    SentimentAnalysisEmoji().analysis(text, emoji: true);
                    if (kDebugMode) {
                      print('PREDICTION $prediction');
                    }
                    setState(() {
                      if (prediction['score'] > 0) {
                        setState(() {
                          positiveResponse += 1;
                        });
                      } else {
                        setState(() {
                          negativeResponse += 1;
                        });
                      }
                      _children.add(Dismissible(
                        key: GlobalKey(),
                        onDismissed: (direction) {},
                        child: Card(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            color: prediction['score'] > 0
                                ? Colors.lightGreen
                                : Colors.redAccent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  text,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ));
                      _controller.clear();
                    });
                  },
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}