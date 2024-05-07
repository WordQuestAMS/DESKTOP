import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Partida extends StatefulWidget {
  @override
  _PartidaState createState() => _PartidaState();
}

class _PartidaState extends State<Partida> {
  late IO.Socket socket;
  List<dynamic> jugadores = [];

  @override
  void initState() {
    super.initState();
    createSocketConnection();
  }

  void createSocketConnection() {
    socket = IO.io('https://roscodrom-docents.ieti.site', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.onConnect((_) {
      print('Connected');
    });

    socket.onDisconnect((_) {
      print('Disconnected');
    });

    socket.on('jugadores', (data) {
      setState(() {
        jugadores = data;
      });
    });

    socket.connect();
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
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }
}
