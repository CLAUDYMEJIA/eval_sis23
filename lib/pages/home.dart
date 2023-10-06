import 'dart:html';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Clientes {
  final String id;
  final String nombre;
  final String edad;
  final String telefono;

  Clientes({
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
      title: 'Firestone a clientes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.pink,
        ),
      ),
      home: const MyHomePage(title: 'Clientes'),
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
  final CollectionReference productosCollection =
      FirebaseFirestore.instance.collection("tb_productos");

  final TextEditingController idController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController edadController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();

  Future<void> addProducto() async {
    String id = idController.text.trim();
    String nombre = nombreController.text.trim();
    String edad = edadController.text.trim();
    String telefono = telefonoController.text.trim();

    if (id.isNotEmpty &&
        nombre.isNotEmpty &&
        edad.isNotEmpty &&
        telefono.isNotEmpty) {
      await tb_testCollection.doc(id).set({
        'nombre': nombre,
        'edad': edad,
        'telefono': telefono,
      });
      idController.clear();
      nombreController.clear();
      edadController.clear();
      telefonoController.clear();

      _showSnackbar('Agregado correctamente');
    } else {
      _showSnackbar('Por favor, completa todos los campos');
    }
  }

  Future<List<Clientes>> _getClientes() async {
    QuerySnapshot Clientes = await tb_testCollection.get();
    List<Clientes> listaClientes = [];
    if (Clientes.docs.length != 0) {
      for (var doc in Clientes.docs) {
        final data = doc.data() as Map<String, dynamic>;
        listaClientes.add(Clientes(
          id: doc.id,
          nombre: data['nombre'] ?? '',
          edad: data['edad'] ?? '',
          telefono: data['telefono'] ?? '',
        ));
      }
    }
    return listaClientes;
  }

  Future<void> updateClientes(String id) async {
    await tb_testCollection.doc(id).update({
      'nombre': nombreController.text,
      'edad': edadController.text,
      'telefono': telefonoController.text,
    });

    // Limpiar los controladores después de actualizar un producto
    idController.clear();
    nombreController.clear();
    edadController.clear();
    telefonoController.clear();

    _showSnackbar('Datos de los Clientes actualizados correctamente');
  }

  Future<void> deleteClientes(String id) async {
    await tb_testCollection.doc(id).delete();

    _showSnackbar('Clientes eliminado correctamente');
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1),
      ),
    );
  }

  bool _showUpdateButton = false;
  Clientes? _selectedClientes;

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
              decoration: InputDecoration(labelText: 'ID del Cliente'),
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: nombreController,
              decoration: InputDecoration(labelText: 'Nombre del Cliente'),
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: edadController,
              decoration: InputDecoration(labelText: 'Edad del cliente'),
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: telefonoController,
              decoration: InputDecoration(labelText: 'telefono del cliente'),
            ),
            SizedBox(height: 4.0),
            ElevatedButton(
              onPressed: () {
                addClientes();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // Cambiar el color del botón
                padding: EdgeInsets.symmetric(
                    horizontal: 2, vertical: 0), // Tamaño personalizado
              ),
              child: Text('Agregar'),
            ),
            SizedBox(height: 8.0),
            if (_showUpdateButton)
              ElevatedButton(
                onPressed: () {
                  updateClientes(_selectedClientes!.id);
                  setState(() {
                    _showUpdateButton = false;
                  });
                },
                child: Text('Actualizar Clientes'),
              ),
            Expanded(
              child: FutureBuilder<List<Clientes>>(
                future: _getClientes(),
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
                    List<Clientes>? Clientes = snapshot.data;
                    return DataTable(
                      columns: [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Nombre')),
                        DataColumn(label: Text('Edad')),
                        DataColumn(label: Text('telefono')),
                      ],
                      rows: Clientes!.map((Clientes) {
                        return DataRow(
                          cells: [
                            DataCell(Text('${Clientes.id}')),
                            DataCell(Text('${Clientes.nombre}')),
                            DataCell(Text('${Clientes.edad}')),
                            DataCell(Text('${Clientes.telefono}')),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      // Puedes implementar la lógica de edición aquí
                                      print('Editar: ${Clientes.id}');
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      // Puedes implementar la lógica de eliminación aquí
                                      print('Eliminar: ${Clientes.id}');
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
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
