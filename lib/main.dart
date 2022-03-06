import 'package:flutter/material.dart';
import 'package:hash_indice/configuration_model.dart';
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
  TableModel tableModel = TableModel();
  int costSize = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Indice Hash App'),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: textControllerPagina,
                decoration: InputDecoration(
                  label: Text("Tamanho da pagina"),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                  controller: textControllerBucket,
                  decoration: InputDecoration(
                    label: Text("Tamanho do bucket"),
                    border: OutlineInputBorder(),
                  )),
            ),
            ElevatedButton(
              onPressed: () async {
                await service.postConfiguration(ConfigurationModel(
                    pageSize: textControllerPagina.text,
                    bucketSize: textControllerBucket.text)).then((value) => print(value));
              },
              child: Text("Confirmar"),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                  controller: textControllerChave,
                  decoration: InputDecoration(
                    label: Text("Chave de busca"),
                    border: OutlineInputBorder(),
                  )),
            ),
            ElevatedButton(
              onPressed: () async {
                await service.getSearch(textControllerChave.text).then((value) {
                  print(value);
                  setState(() {
                    print(value);
                    costSize = value.cost!;
                  });
                });
                await service.getTable().then((value) {
                  print(value);
                  setState(() {
                    tableModel = value;
                  });
                });

              },
              child: Text("Procurar"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                physics: NeverScrollableScrollPhysics(),
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Tamanho da pagina"),
                          ),
                          Spacer(),
                          Center(
                              child: Text(
                            tableModel.pageSize.toString(),
                            style: TextStyle(fontSize: 128),
                          )),
                          Spacer(),
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Tamanho do bucket"),
                          ),
                          Spacer(),
                          Text(
                            tableModel.bucketSize.toString() ,
                            style: TextStyle(fontSize: 128),
                          ),
                          Spacer(),
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Numero de colisões"),
                          ),
                          Spacer(),
                          Text(
                            tableModel.colisionCount.toString(),
                            style: TextStyle(fontSize: 128),
                          ),
                          Spacer(),
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Numero de overflows"),
                          ),
                          Spacer(),
                          Text(
                            tableModel.overflowCount.toString(),
                            style: TextStyle(fontSize: 128),
                          ),
                          Spacer(),
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Quantidade de registros"),
                          ),
                          Spacer(),
                          Text(
                            tableModel.readSize.toString(),
                            style: TextStyle(fontSize: 128),
                          ),
                          Spacer(),
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Custo de leitura"),
                          ),
                          Spacer(),
                          Text(
                            costSize.toString(),
                            style: TextStyle(fontSize: 128),
                          ),
                          Spacer(),
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Quantidade de buckets"),
                          ),
                          Spacer(),
                          Text(
                            tableModel.bucketNumber.toString(),
                            style: TextStyle(fontSize: 128),
                          ),
                          Spacer(),
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
