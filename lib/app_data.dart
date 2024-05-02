import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AppData extends ChangeNotifier {
  String _serverUrl = 'https://roscodrom3.ieti.site/api/events';
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

  Future<void> bienvenida() async {
    try {
      final response = await http.get(
        Uri.parse('https://roscodrom3.ieti.site/api/bienvenida'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Si el servidor devuelve una respuesta OK, parseamos el JSON
        var data = jsonDecode(response.body);
        print("Respuesta del servidor: $data");
      } else {
        // Si la respuesta no fue OK, lanzamos un error
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Exception caught: $e');
    }
  }

  Future<String?> recibirDiccionario(
      String inicial, int numero, String idioma) async {
    try {
      final String baseUrl = 'https://roscodrom3.ieti.site';
      String url = '$baseUrl/api/dictionary/browse';
      Map<String, dynamic> body = {
        'initial': inicial,
        'pageNumber':
            numero, // Corregido para usar el número de página correcto
        'language': idioma,
      };

      http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json'
        }, // Asegúrate de incluir el header correcto para JSON
        body: json.encode(body), // Codifica el cuerpo a JSON
      );
      if (response.statusCode == 200) {
        // La solicitud fue exitosa
        Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == 'OK') {
          // Datos obtenidos exitosamente
          List<dynamic> data = responseData['data'];

          // Formateando los datos para crear un JSON bien formado
          return jsonEncode(data
              .map((item) => {
                    'palabra': item['palabra'],
                    'idioma': item['idioma'],
                    'uso': item['uso'] ??
                        'null' // Asumiendo que 'uso' puede no estar presente
                  })
              .toList());
        } else {
          // Error en la respuesta del servidor
          print('Error: ${responseData['message']}');
          return null;
        }
      } else {
        // La solicitud falló
        print('Error en la solicitud: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error en la solicitud: $e');
      return null;
    }
  }
}
