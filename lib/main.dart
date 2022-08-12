import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Hide the debug banner
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      title: 'ACS Lunch APP',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // The list that contains information about photos
  late List<dynamic> _loadedData = [];
  late String title = '';
  late bool loading = false;
  @override
  void initState() {
    super.initState();
    _fetchData;
  }

  // The function that fetches data from the API
  Future<void> get _fetchData async {
    setState(() {
      loading = true;
    });

    const apiUrl = 'https://pm.agilecyber.co.uk/report/api.php';

    final response = await http.get(Uri.parse(apiUrl));
    final data = json.decode(response.body);
    // timer
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      title = data['text'] as String;
      _loadedData = data['items'] as List<dynamic>;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              const Text('ACS Lunch App', style: TextStyle(letterSpacing: 1.5)),
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () async {
                  await _fetchData;
                }),
          ],
        ),
        body: Column(children: [
          //loading
          if (loading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          Container(
              padding: const EdgeInsets.all(20),
              child: Text(title,
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: Colors.black,
                      fontSize: 20,
                      height: 1.5,
                      fontWeight: FontWeight.bold))),
          Expanded(
              child: ListView.builder(
            itemCount: _loadedData.length,
            itemBuilder: (BuildContext ctx, index) {
              return Container(
                color: Colors.green,
                child: Material(
                    child: ListTile(
                  trailing: Text(
                      "${_loadedData[index]['count']} (${_loadedData[index]?['original_count'] ?? _loadedData[index]['count']})"),
                  title: Text(_loadedData[index]['name'] as String),
                  tileColor: Colors.white,
                )),
              );
            },
          )),
        ]));
  }
}
