import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

Future<Lyrics> fetchLetras(Controller_Artist,Controller_Song) async {
  //Link del api: https://api.lyrics.ovh/v1/artist/title
  var hola = 'https://api.lyrics.ovh/v1/'+Controller_Artist+'/'+Controller_Song;
  final response = await http.get('https://api.lyrics.ovh/v1/'+Controller_Artist+'/'+Controller_Song);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Lyrics.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception("$hola");
  }
}

class Lyrics {
  final String lyrics;

  Lyrics({this.lyrics});

  factory Lyrics.fromJson(Map<String, dynamic> json) {
    return Lyrics(
      lyrics: json['lyrics'],
    );
  }
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lyrics Search',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Search the lyrics of songs'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Controller_Artist = TextEditingController();
  final Controller_Song = TextEditingController();
  Future<Lyrics> futureLetras;

  @override
  void initState() {
    super.initState();
    futureLetras = fetchLetras(Controller_Artist.text,Controller_Song.text);
  }

  void _Buscar_Letra(){
    futureLetras = fetchLetras(Controller_Artist.text,Controller_Song.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: Text(widget.title),
    ),
      body: ListView(
          children: <Widget>[
            TextField(
              controller: Controller_Artist,
            ),
            TextField(
              controller: Controller_Song,
            ),
            RaisedButton(
              onPressed: (){_Buscar_Letra();},
            ),
            FutureBuilder<Lyrics>(
              future: futureLetras,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(

                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                // By default, show a loading spinner.
                return CircularProgressIndicator();
              },
            )
            ,
          ],
        )
      ,
    );
  }
}



