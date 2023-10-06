import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Test {
  final String id;
  final String nombre;
  final String edad;
  final String telefono;

  Test({
    required this.id,
    required this.nombre,
    required this.edad,
    required this.telefono,
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EVALUACION 2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.red,
        ),
      ),
      home: const MyHomePage(title: 'EVALUACION 2'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final CollectionReference testCollection =
      FirebaseFirestore.instance.collection("tb_test");

  final TextEditingController idController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController edadController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();

  Future<void> addTest() async {
    String id = idController.text.trim();
    String nombre = nombreController.text.trim();
    String edad = edadController.text.trim();
    String telefono = telefonoController.text.trim();

    if (id.isNotEmpty &&
        nombre.isNotEmpty &&
        edad.isNotEmpty &&
        telefono.isNotEmpty) {
      await testCollection.doc(id).set({
        'nombre': nombre,
        'edad': edad,
        'telefono': telefono,
      });

      // Limpiar los controladores después de agregar un test
      idController.clear();
      nombreController.clear();
      edadController.clear();
      telefonoController.clear();

      _showSnackbar('Test agregado correctamente');
    } else {
      _showSnackbar('Por favor, completa todos los campos');
    }
  }

  Future<List<Test>> getTests() async {
    QuerySnapshot tests = await testCollection.get();
    List<Test> listaTests = [];
    if (tests.docs.length != 0) {
      for (var doc in tests.docs) {
        final data = doc.data() as Map<String, dynamic>;
        listaTests.add(Test(
          id: doc.id,
          nombre: data['nombre'] ?? '',
          edad: data['edad'] ?? '',
          telefono: data['telefono'] ?? '',
        ));
      }
    }
    return listaTests;
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: idController,
              decoration: InputDecoration(
                labelText: 'ID',
                icon: Icon(Icons.confirmation_number),
              ),
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre',
                icon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: edadController,
              decoration: InputDecoration(
                labelText: 'Edad',
                icon: Icon(Icons.cake),
              ),
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: telefonoController,
              decoration: InputDecoration(
                labelText: 'Teléfono',
                icon: Icon(Icons.phone),
              ),
            ),
            SizedBox(height: 4.0),
            ElevatedButton(
              onPressed: () {
                addTest();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
              child: Container(
                alignment: Alignment.center,
                constraints:
                    BoxConstraints(minWidth: 1, maxWidth: double.infinity),
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('Agregar'),
              ),
            ),
            SizedBox(height: 6.0),
            Expanded(
              child: FutureBuilder<List<Test>>(
                future: getTests(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error al cargar los datos'),
                    );
                  } else {
                    List<Test>? tests = snapshot.data;
                    return DataTable(
                      columns: [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Nombre')),
                        DataColumn(label: Text('Edad')),
                        DataColumn(label: Text('Teléfono')),
                      ],
                      rows: tests!.map((test) {
                        return DataRow(cells: [
                          DataCell(Text(test.id)),
                          DataCell(Text(test.nombre)),
                          DataCell(Text(test.edad)),
                          DataCell(Text(test.telefono)),
                        ]);
                      }).toList(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
