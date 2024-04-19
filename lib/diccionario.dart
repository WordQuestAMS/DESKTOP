import 'dart:convert';
import 'package:flutter/material.dart';

class Diccionario extends StatefulWidget {
  @override
  _DiccionarioState createState() => _DiccionarioState();
}

class _DiccionarioState extends State<Diccionario> {
  String idiomaSeleccionado = 'Todos';
  List<Map<String, String>> palabras = [
    {"id": "1", "palabra": "house", "idioma": "inglés", "uso": "casa"},
    {"id": "2", "palabra": "car", "idioma": "inglés", "uso": "coche"},
    {"id": "3", "palabra": "tree", "idioma": "inglés", "uso": "árbol"},
    {"id": "4", "palabra": "cat", "idioma": "inglés", "uso": "gato"}
  ];
  int currentPage = 0;
  bool isLoading = false;

  // Método para modificar el JSON de palabras
  void modificarJsonPalabras(String newJsonString) {
    cargarDatos(newJsonString, currentPage);
  }

  // Método para devolver el JSON de palabras
  String devolverJsonPalabras() {
    return jsonEncode(palabras);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diccionario'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButtonFormField<String>(
                value: idiomaSeleccionado,
                onChanged: (String? newValue) {
                  setState(() {
                    idiomaSeleccionado = newValue!;
                  });
                },
                items: <String>[
                  'Todos',
                  'Catalan',
                  'Español',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Selecciona un idioma',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            isLoading
                ? Container(
                    height: MediaQuery.of(context)
                        .size
                        .height, // Ocupa toda la altura disponible
                    width: MediaQuery.of(context)
                        .size
                        .width, // Ocupa toda la anchura disponible
                    // Color de fondo semitransparente
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: palabras.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 2.0,
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ID: ${palabras[index]['id']}'),
                                Text('Palabra: ${palabras[index]['palabra']}'),
                                Text('Idioma: ${palabras[index]['idioma']}'),
                                Text('Usos: ${palabras[index]['uso']}'),
                              ],
                            ),
                            onTap: () {
                              // Aquí puedes agregar la lógica que desees al hacer clic en una palabra
                            },
                          ),
                        );
                      },
                    ),
                  ),
            SizedBox(height: 20),
            Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      if (currentPage > 0) {
                        setState(() {
                          currentPage--;
                          String jsonString;

                          // Selecciona el JSON de palabras según la página

                          jsonString = '''
      [
        
  {"id": "1", "palabra": "cristian", "idioma": "inglés", "uso": "casa"},
  {"id": "2", "palabra": "cristian", "idioma": "inglés", "uso": "coche"},
  {"id": "3", "palabra": "cristian", "idioma": "inglés", "uso": "árbol"},
  {"id": "4", "palabra": "cristian", "idioma": "inglés", "uso": "gato"}


      ]
      ''';

                          modificarJsonPalabras(jsonString);
                        });
                      }
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                  Text('Página ${currentPage + 1}'),
                  IconButton(
                    onPressed: () {
                      if (currentPage < 4) {
                        setState(() {
                          currentPage++;
                          String jsonString;

                          // Selecciona el JSON de palabras según la página

                          jsonString = '''
      [
        
  {"id": "1", "palabra": "SUSI", "idioma": "inglés", "uso": "casa"},
  {"id": "2", "palabra": "SUSI", "idioma": "inglés", "uso": "coche"},
  {"id": "3", "palabra": "SUSI", "idioma": "inglés", "uso": "árbol"},
  {"id": "4", "palabra": "SUSI", "idioma": "inglés", "uso": "gato"}


      ]
      ''';

                          modificarJsonPalabras(jsonString);
                        });
                      }
                    },
                    icon: Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void actualizarPalabras(List<Map<String, String>> nuevasPalabras) {
    setState(() {
      palabras = nuevasPalabras;
    });
  }

  void cargarDatos(String jsonString, int pageNumber) async {
    setState(() {
      isLoading = true;
    });
    print(jsonString);

    // Simulamos una carga de datos
    await Future.delayed(Duration(seconds: 2));

    // Decodificamos el JSON y lo convertimos a List<Map<String, dynamic>>
    List<Map<String, dynamic>> nuevasPalabras =
        List<Map<String, dynamic>>.from(jsonDecode(jsonString));

    actualizarPalabras(
      nuevasPalabras
          .map((palabra) => Map<String, String>.from(palabra))
          .toList(),
    );

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    cargarDatos(devolverJsonPalabras(),
        currentPage); // Carga los datos de la página inicial al iniciar
  }
}
