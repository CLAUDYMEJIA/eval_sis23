import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @verride
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void getEval2() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("tb_test");
    QuerySnapshot mensajes = await collectionReference.get();
    if (mensajes.docs.length != 0) {
      for (var doc in mensajes.docs) {
        print(doc.data());
      }
    }
  }
}

@override
Widget buid(BuildContext context){

  return Scaffold(
    appBar: AppBar()
  )
}