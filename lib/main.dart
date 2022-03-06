import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String textFromFile = 'Empty';

  getData() async {
    String response;
    response = await rootBundle.loadString('assets/felipe.txt');
    setState(() {
      textFromFile = response;
    });
  }

  clear() {
    setState(() {
      textFromFile = 'Empty';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Indice Hash App'),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(textFromFile,),
            Padding(padding: const EdgeInsets.all(16), child: ElevatedButton(onPressed: () => getData(), child: const Text('Get Text'))),
            Padding(padding: const EdgeInsets.all(16), child: ElevatedButton(onPressed: () => clear(), child: const Text('Clear'))),
          ],
        ),
      ),
    );
  }
}

