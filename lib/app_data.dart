import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AppData extends ChangeNotifier {
  String _serverUrl = '';
  String _username = '';
  String _password = '';
  String get serverUrl => _serverUrl;

  AppData() {
    _loadUrlFromStorage(); // Llama a _loadUrlFromStorage() al iniciar
  }

  Future<void> _loadUrlFromStorage() async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/url.txt');
      if (await file.exists()) {
        final String url = await file.readAsString();
        _serverUrl = url;
        notifyListeners(); // Notificar a los listeners sobre el cambio en la URL
      }
    } catch (e) {
      print('Error reading URL: $e');
    }
  }

  Future<void> saveData(String url) async {
    try {
      _serverUrl = url;
      notifyListeners(); // Notificar a los listeners sobre el cambio en la URL

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('server_url', url); // Guardar en SharedPreferences

      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/url.txt');
      await file.writeAsString(url); // Guardar en el archivo
      await _login();
    } catch (e) {
      print('Error saving URL: $e');
    }
  }

  Future<void> _login() async {
    try {
      if (_serverUrl.isNotEmpty) {
        String url = '$_serverUrl/api/user/login';
        Map<String, String> body = {
          'username':
              _username, // Reemplaza _username con la variable que contiene el nombre de usuario
          'password':
              _password, // Reemplaza _password con la variable que contiene la contraseña
        };
        http.Response response = await http.post(Uri.parse(url), body: body);
        if (response.statusCode == 200) {
          // La solicitud fue exitosa
          print(response.body);
        } else {
          // La solicitud falló
          print('Error en la solicitud: ${response.statusCode}');
        }
      } else {
        print('URL del servidor vacía');
      }
    } catch (e) {
      print('Error en la solicitud: $e');
    }
  }
}
