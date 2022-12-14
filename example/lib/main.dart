// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:janus/janus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() async{
    setState(() {
      
      _counter++;
    });
    final Counter counter = Counter(number: _counter);
    final counterStorage = CounterStorage();
    await counterStorage.save(counter.toMap());

  }

  void getCounter()async{
    final counterStorage = CounterStorage();
    final counter = Counter.fromMap(await counterStorage.load());
    setState(() {
      _counter = counter.number;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCounter();
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
  
        title: Text(widget.title),
      ),
      body: Center(
       
        child: Column(
        
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), 
    );
  }
}

class Counter {
  final int number;
  const Counter({
    required this.number,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'number': number,
    };
  }

  factory Counter.fromMap(Map<String, dynamic> map) {
    return Counter(
      number: map['number'] ?? 0,
    );
  }
}

class CounterStorage extends Janus{
  CounterStorage() : super(cypher: true);
}
