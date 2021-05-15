import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  List names = [];
  List news_ids = [];
  List urls = [];
  var data;
  bool it = false;
  var url = Uri.https('hubblesite.org', '/api/v3/news', {'q': '{http}'});

  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => getData()(context));
  }

  getData() async {
    var response = await http.get(url);
    var jsonResponse = convert.jsonDecode(response.body);

    data = jsonResponse;

    setState(() {
      it = true;
    });

    for (var i = 0; i < data.length; i++) {
      var temp = data[i];
      names.add(temp['name']);
      news_ids.add(temp["news_id"]);
      urls.add(temp["url"]);
    }
  }

  Future<void> launch_url(String univer) async {
    if (univer.isNotEmpty) {
      await launch(univer);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber.shade900,
          title: Text("News"),
        ),
        body: it
            ? ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return MaterialButton(
                    onPressed: () {
                      if (urls[index] != null) {
                        launch_url(urls[index]);
                      } else {}
                    },
                    child: Card(
                      shadowColor: Colors.amber.shade900,
                      elevation: 10,
                      child: Container(
                        alignment: Alignment.center,
                        height: 100,
                        color: Colors.amber.shade200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              '''${news_ids[index]}''',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Text(
                              '''${names[index]}''',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              )
            : Center(
                child: Text(
                "Data is Comming......",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              )));
  }
}
