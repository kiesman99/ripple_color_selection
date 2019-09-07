import 'package:example/custom_tile_page.dart';
import 'package:example/full_page.dart';
import 'package:example/fully_custom_page.dart';
import 'package:flutter/material.dart';

import 'listen_on_selection_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  static List<Widget> pages = [
    FullPage(),
    CustomTilePage(),
    FullyCustomPage(),
    ColorSelectionPageWithListener()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: ListView.builder(
        itemCount: pages.length,
        itemBuilder: (_, position) {
          return ListTile(
            title: Text(pages.elementAt(position).toString()),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => pages.elementAt(position)));
            },
          );
        },
      )),
    );
  }
}
