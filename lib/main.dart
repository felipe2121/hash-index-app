import 'package:flutter/material.dart';
import 'package:hash_indice/configuration_model.dart';
import 'package:hash_indice/model/info_model.dart';
import 'package:hash_indice/model/result_model.dart';
import 'package:hash_indice/service.dart';
import 'package:hash_indice/table_model.dart';

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
  final textControllerPagina = TextEditingController();
  final textControllerBucket = TextEditingController();
  final textControllerChave = TextEditingController();
  final Service service = Service();
  ResultModel model = ResultModel(
      access: null,
      colisions: null,
      overflow: null,
      countRegistro: null,
      buckets: null,
      bucketLimit: null,
      size: null
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Indice Hash App'),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: textControllerPagina,
                decoration: const InputDecoration(
                  label: Text("Tamanho da pagina"), // page_size
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                  controller: textControllerBucket,
                  decoration: const InputDecoration(
                    label: Text("Tamanho do bucket"), // limit
                    border: OutlineInputBorder(),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                  controller: textControllerChave,
                  decoration: const InputDecoration(
                    label: Text("Chave de busca"),
                    border: OutlineInputBorder(),
                  )),
            ),
            ElevatedButton(
              onPressed: () async {
                await service.getInfo(InfoModel(
                    limit: double.parse(textControllerBucket.text),
                    page_size: double.parse(textControllerPagina.text),
                    value: textControllerChave.text
                )).then((value) {
                  setState(() {
                    print(value);
                    model = value;
                  });
                });
              },
              child: const Text("Confirmar"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                children: [
                  Card(
                    elevation: 8,
                    child: Container(
                      height: 100,
                      width: 100,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Tamanho da pagina"),
                          ),
                          const Spacer(),
                          Center(
                            child: Text(
                            model.size.toString(),
                            style: const TextStyle(fontSize: 64),
                          )),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 8,
                    child: Container(
                      height: 100,
                      width: 100,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Tamanho do bucket"),
                          ),
                          const Spacer(),
                          Text(
                            model.bucketLimit.toString() ,
                            style: const TextStyle(fontSize: 64),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 8,
                    child: Container(
                      height: 100,
                      width: 100,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: const Text("Numero de colisões"),
                          ),
                          const Spacer(),
                          Text(
                            model.colisions.toString(),
                            style: const TextStyle(fontSize: 64),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 8,
                    child: Container(
                      height: 100,
                      width: 100,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Numero de overflows"),
                          ),
                          const Spacer(),
                          Text(
                            model.overflow.toString(),
                            style: const TextStyle(fontSize: 64),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 8,
                    child: Container(
                      height: 100,
                      width: 100,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: const Text("Quantidade de registros"),
                          ),
                          const Spacer(),
                          Text(
                            model.countRegistro.toString(),
                            style: const TextStyle(fontSize: 64),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 8,
                    child: Container(
                      height: 100,
                      width: 100,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: const Text("Custo de leitura"),
                          ),
                          const Spacer(),
                          Text(
                            model.access.toString(),
                            style: const TextStyle(fontSize: 64),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 8,
                    child: Container(
                      height: 100,
                      width: 100,
                      child: Column(
                        children: [
                          const Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: const Text("Quantidade de buckets"),
                          ),
                          const Spacer(),
                          Text(
                            model.buckets.toString(),
                            style: const TextStyle(fontSize: 64),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ]),
        ));
  }
}
