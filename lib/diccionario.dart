import 'dart:convert';
import 'package:descktop/app_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Diccionario extends StatefulWidget {
  final List<Map<String, String>> initialPalabras;

  Diccionario({Key? key, required this.initialPalabras}) : super(key: key);
  @override
  _DiccionarioState createState() => _DiccionarioState();
}

class _DiccionarioState extends State<Diccionario> {
  String idiomaSeleccionado = 'Catalán';
  List<Map<String, String>> palabras = [];

  int currentPage = 1;
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
    final appData = Provider.of<AppData>(context, listen: false);

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
                  'Catalán',
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
                                Text('Palabra: ${palabras[index]['palabra']}'),
                                Text('Idioma: ${palabras[index]['idioma']}'),
                                Text('Uso: ${palabras[index]['uso']}'),
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
                    onPressed: () async {
                      setState(() => currentPage--);
                      try {
                        setState(() {
                          isLoading = true;
                        });
                        String? jsonString2 = await appData.recibirDiccionario(
                            "a", currentPage, idiomaSeleccionado);

                        if (jsonString2 != null) {
                          modificarJsonPalabras(jsonString2);
                        } else {
                          print("No se recibieron datos del servidor.");
                        }
                      } catch (e) {
                        print("Error al cargar datos: $e");
                      }
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                  Text('Página $currentPage'),
                  IconButton(
                    onPressed: () async {
                      setState(() {
                        currentPage++;
                      });
                      try {
                        setState(() {
                          isLoading = true;
                        });
                        String? jsonString2 = await appData.recibirDiccionario(
                            "a", currentPage, idiomaSeleccionado);

                        if (jsonString2 != null) {
                          modificarJsonPalabras(jsonString2);
                        } else {
                          print("No se recibieron datos del servidor.");
                        }
                      } catch (e) {
                        print("Error al cargar datos: $e");
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
    // Inicializa con la lista pasada al widget
    palabras = widget.initialPalabras;
    print(palabras);
    // Carga los datos de la página inicial al iniciar
    cargarDatos(devolverJsonPalabras(), currentPage);
  }
}
