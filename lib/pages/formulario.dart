import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class getEval2 extends StatefulWidget {
  const getEval2({super.key});

  @override
  State<getEval2> createState() => _getEval2State();
}

class _getEval2State extends State<getEval2> {

  final TextEditingController _nombreControllers = TextEditingController(text: "" );
  final TextEditingController _edadControllers = TextEditingController(text: "" );
  final TextEditingController _telefonoControllers = TextEditingController(text: "" );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar Nombre"),
      ),
      body: Padding(padding: const EdgeInsets.all(15.0)),
      child: Column(
        children: [
          const Text("DATOS DE CLIENTES",
          style: TextStyle(
            fontSize: 30,
            color: Colors.amber,
            fontWeight: FontWeight.bold
          ),
          ),
const SizedBox(height: 20,),
TextField(
  controller: _nombreControllers,
  keyboardType: TextInputType.text,
  decoration: const InputDecoration(
    border: OutlineInputBorder(),
    hintText: "Digite su nombre",
    prefixIcon: Icon(Icons.person,
    color: Colors.red,);
  ),
),
        ],
      );
    );
  }
}