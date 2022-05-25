import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:walloftexts/model/Note.dart';
import 'package:lottie/lottie.dart';

Future<List<Note>> fetchNote(String url) async {
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
    return parsed.map<Note>((json) => Note.fromMap(json)).toList();
  } else {
    throw Exception('Failed to load notes');
  }
}

Future<String?> postNote(String url) async {
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    print('Done!');
    return response.body;
  } else {
    throw Exception('Faild to post the note');
  }
}

Color parseColor(String color) {
  String hex = color.replaceAll("#", "");
  if (hex.isEmpty) hex = "ffffff";
  if (hex.length == 3) {
    hex =
        '${hex.substring(0, 1)}${hex.substring(0, 1)}${hex.substring(1, 2)}${hex.substring(1, 2)}${hex.substring(2, 3)}${hex.substring(2, 3)}';
  }
  Color col = Color(int.parse(hex, radix: 16)).withOpacity(1.0);
  return col;
}

MaterialColor buildMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

void main() => runApp(
      MaterialApp(
        theme: ThemeData(
          primaryColor: parseColor('#0c1a2f'),
        ),
        home: MyApp(),
      ),
    );

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Note>> futureNote;
  String sortBy = "time";
  int order = -1;
  String _sortValue = "Chronological";
  String _orderValue = "Descending";
  String fetchUrl = "https://dagmawibabi.com/wot/getNotes/time/-1";

  @override
  void initState() {
    super.initState();
    futureNote = fetchNote(fetchUrl);
    print(fetchUrl);
  }

  void _showMyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: parseColor('#0c1a2f'),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          title: Row(children: const [
            Text(
              'Words Of Strangers',
              style: TextStyle(color: Colors.grey),
            )
          ]),
          content: ListView(
            shrinkWrap: true,
            children: [
              TextField(
                style: TextStyle(color: parseColor('#68EEC9')),
                decoration: InputDecoration(
                  fillColor: parseColor('#68EEC9'),
                  filled: false,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: parseColor('#68EEC9')),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  hintText: 'Title of your note',
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                style: TextStyle(color: parseColor('#68EEC9')),
                decoration: InputDecoration(
                  fillColor: parseColor('#68EEC9'),
                  filled: false,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: parseColor('#68EEC9')),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  hintText: 'Title of your note',
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: const Size(88, 44),
                padding: const EdgeInsets.all(0),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "CANCLE",
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: const Size(88, 44),
                padding: const EdgeInsets.all(0),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "POST NOTE",
                style: TextStyle(color: parseColor('#68EEC9')),
              ),
            )
          ],
        );
      },
    );
  }

  void _showSettingsDialog(String selection) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: parseColor('#0c1a2f'),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          title: Row(children: const [
            Text(
              'Words Of Strangers',
              style: TextStyle(color: Colors.grey),
            )
          ]),
          content: ListView(
            shrinkWrap: true,
            children: [
              const Text('Sort List By', style: TextStyle(color: Colors.grey)),
              DropdownButton<String>(
                isExpanded: true,
                style: const TextStyle(color: Color(0xFFFFFFFF)),
                dropdownColor: parseColor('#0c1a2f'),
                value: _sortValue,
                items: <String>['Likes', 'Dislikes', 'Chronological']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (selectedItem) {
                  if (selectedItem == 'Chronological') {
                    setState(() {
                      _sortValue = selectedItem!;
                      sortBy = 'time';
                    });
                  } else {
                    setState(() {
                      _sortValue = selectedItem!;
                      sortBy = selectedItem.toLowerCase();
                      print(sortBy);
                    });
                  }
                },
              ),
              const SizedBox(height: 10),
              const Text('Sort Order', style: TextStyle(color: Colors.grey)),
              DropdownButton<String>(
                isExpanded: true,
                style: const TextStyle(color: Colors.white),
                dropdownColor: parseColor('#0c1a2f'),
                value: _orderValue,
                items: <String>['Descending', 'Ascending'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (selectedItem) {
                  setState(() {
                    if (selectedItem == 'Descending') {
                      _orderValue = selectedItem!;
                      order = -1;
                    } else if (selectedItem == 'Ascending') {
                      _orderValue = selectedItem!;
                      order = 1;
                    }
                    print(order);
                  });
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: const Size(88, 44),
                padding: const EdgeInsets.all(0),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "CANCLE",
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: const Size(88, 44),
                padding: const EdgeInsets.all(0),
              ),
              onPressed: () {
                setState(() {
                  fetchUrl =
                      "https://dagmawibabi.com/wot/getNotes/$sortBy/$order";
                });
                print(fetchUrl);
                Navigator.of(context).pop();
              },
              child: Text(
                "APPLY",
                style: TextStyle(color: parseColor('#68EEC9')),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wall of Strangers'),
        backgroundColor: parseColor('#0c1a2f'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Refresh List',
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            onSelected: _showSettingsDialog,
            color: parseColor('#0c1a2f'),
            itemBuilder: (BuildContext context) {
              return {'Display Settings'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(
                    choice,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      backgroundColor: parseColor('#0c1a2f'),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showMyDialog(context),
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Note>>(
        future: futureNote,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) => Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: parseColor('#68EEC9'),
                      width: 1.0,
                      style: BorderStyle.solid,
                    ),
                    right: BorderSide(
                      color: parseColor('#68EEC9'),
                      width: 1.0,
                      style: BorderStyle.solid,
                    ),
                    left: BorderSide(
                      color: parseColor('#68EEC9'),
                      width: 1.0,
                      style: BorderStyle.solid,
                    ),
                    bottom: BorderSide(
                      color: parseColor('#68EEC9'),
                      width: 1.0,
                      style: BorderStyle.solid,
                    ),
                  ),
                  color: parseColor('#0c1a2f'),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 3,
                          child: Text(
                            snapshot.data![index].title,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              backgroundColor: parseColor('#193761c3'),
                              padding: const EdgeInsets.all(0),
                            ),
                            onPressed: () {},
                            child: Text(
                              "💚 ${snapshot.data![index].likes}",
                              style: TextStyle(color: parseColor('#68EEC9')),
                            ),
                          ),
                        ),
                        const SizedBox(height: 0.0, width: 1.5),
                        Flexible(
                          flex: 1,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(0),
                              backgroundColor: parseColor('#193761c3'),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              "👎 ${snapshot.data![index].dislikes}",
                              style: TextStyle(color: parseColor('#68EEC9')),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        snapshot.data![index].content,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 15.0),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            //return const Center(child: CircularProgressIndicator());
            return Center(
                child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Lottie.asset('assets/empty-state.json'),
            ));
          }
        },
      ),
    );
  }
}
