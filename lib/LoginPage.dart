import 'dart:convert';

import 'package:descktop/app_data.dart';
import 'package:descktop/partida.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'diccionario.dart'; // Importa la nueva pantalla diccionario.dart

class LoginPage extends StatelessWidget {
  final TextEditingController _urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(''), // Título personalizado
        elevation: 0, // Sin elevación para un aspecto más limpio
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'WELCOME TO WORDQUEST',
              style: TextStyle(
                color: const Color.fromARGB(255, 51, 8, 8),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
                height: 20), // Espacio entre el título y los campos de entrada
            Text(
              'Iniciar Sesión',
              style: TextStyle(
                color: const Color.fromARGB(255, 51, 8, 8),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
                height: 20), // Espacio entre el título y los campos de entrada
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'URL del servidor',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(
                height: 20), // Espacio entre los campos de entrada y el botón
            ElevatedButton(
              child: Text('Ver Diccionarios'),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                appData.bienvenida();
                await prefs.setString('server_url', _urlController.text);
                String? jsonString2 =
                    await appData.recibirDiccionario("a", 1, 'Catalán');
                List<Map<String, dynamic>> nuevasPalabras =
                    List<Map<String, dynamic>>.from(jsonDecode(jsonString2!));
                // Navegar a la nueva pantalla "diccionario"
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Diccionario(
                            initialPalabras: nuevasPalabras
                                .map((palabra) =>
                                    Map<String, String>.from(palabra))
                                .toList(),
                          )),
                );

                // Borrar el texto en los campos de entrada
                _urlController.clear();

                // Mostrar un SnackBar si la sesión se inicia correctamente
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Has iniciado sesión correctamente.'),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Ver Partida'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Partida()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
