import 'dart:convert';
import 'package:flutter/material.dart';

class Partida extends StatefulWidget {
  @override
  _PartidaState createState() => _PartidaState();
}

class _PartidaState extends State<Partida> {
  late List<dynamic> jugadores;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    String jsonData = '''
    {
      "jugadores": [
        {
          "nombre": "Alice",
          "puntos": 15,
          "palabras": ["casa", "perro", "árbol"]
        },
        {
          "nombre": "Bob",
          "puntos": 20,
          "palabras": ["libro", "gato", "cielo"]
        }
      ]
    }
    ''';
    setState(() {
      jugadores = jsonDecode(jsonData)['jugadores'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Partida'),
      ),
      body: ListView.builder(
        itemCount: jugadores.length,
        itemBuilder: (context, index) {
          var jugador = jugadores[index];
          return Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text(
                    jugador['nombre'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    "${jugador['puntos']} pts",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey),
                  ),
                ),
                Container(
                  height:
                      100, // altura fija para el área de desplazamiento de las palabras
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: jugador['palabras'].map<Widget>((palabra) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Chip(
                          label: Text(palabra),
                          backgroundColor: Colors.lightBlue.shade100,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
