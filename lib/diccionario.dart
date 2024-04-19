import 'package:flutter/material.dart';

class Diccionario extends StatefulWidget {
  @override
  _DiccionarioState createState() => _DiccionarioState();
}

class _DiccionarioState extends State<Diccionario> {
  String idiomaSeleccionado = 'Todos';
  List<Map<String, String>> palabras = [
    {"id": "1", "palabra": "hello", "idioma": "inglés", "uso": "saludo"},
    {"id": "2", "palabra": "hola", "idioma": "español", "uso": "saludo"},
    {"id": "3", "palabra": "bonjour", "idioma": "francés", "uso": "saludo"},
    {"id": "4", "palabra": "ciao", "idioma": "italiano", "uso": "saludo"},
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> palabrasMostradas = idiomaSeleccionado == 'Todos'
        ? palabras
        : palabras
            .where((palabra) => palabra['idioma'] == idiomaSeleccionado)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Diccionario'),
      ),
      body: Column(
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
                'inglés',
                'español',
                'francés',
                'italiano'
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
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                itemCount: palabrasMostradas.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ID: ${palabrasMostradas[index]['id']}'),
                          Text(
                              'Palabra: ${palabrasMostradas[index]['palabra']}'),
                          Text('Idioma: ${palabrasMostradas[index]['idioma']}'),
                          Text('Usos: ${palabrasMostradas[index]['uso']}'),
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
          ),
        ],
      ),
    );
  }
}
