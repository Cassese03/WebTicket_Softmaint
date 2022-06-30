// ignore_for_file: await_only_futures
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutterwhatsapp/models/login_data.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:camera/camera.dart';
import 'package:flutterwhatsapp/pages/open_chat_screen.dart';
//import 'package:flutterwhatsapp/whatsapp_home.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
//import 'package:flutter_session/flutter_session.dart';

List<CameraDescription> cameras;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(new LoginPage());
}

class LoginPage extends StatefulWidget {
  const LoginPage({key, this.title}) : super(key: key);
  final String title;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<List<LoginData>> fetchLogin(numero) async {
    var url = 'https://webticket.softmaint.it/api/login/' + numero;

    var response = await http.get(Uri.parse(url));

    // ignore: deprecated_member_use
    var notes = List<LoginData>();

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        notes.add(LoginData.fromJson(noteJson));
      }
    }
    return notes;
  }

  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var rememberValue = false;
  var numero;
  bool salvato;
  String numeroSalvato;

/*
  void initState() {
    // ciao();
    super.initState();
  }

  Future<void> ciao() async {
    print(await DatabaseHelper.instance.select());
  }*/

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/logo.png'),
                SizedBox(
                  height: 50,
                ),
                LoadingJumpingLine.circle()
              ],
            ),
          )
        : Center(
            child: FutureBuilder<String>(
                future: DatabaseHelper.instance.select(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (!snapshot.hasData) {
                    return Scaffold(
                      backgroundColor: Colors.white,
                      body: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.asset('assets/logo.png'),
                            const SizedBox(
                              height: 50.0,
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Container(
                                    width: 300.0,
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      validator: (value) => (value.length) == 10
                                          ? null
                                          : "Inserire un numero di Telefono valido",
                                      onChanged: (val) {
                                        if (val.length == 10) numero = val;
                                      },
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                        hintText: 'Scrivi qui il tuo numero',
                                        prefixIcon: const Icon(Icons.phone),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 300.0,
                                    child: CheckboxListTile(
                                      title: const Text("Ricorda Numero"),
                                      contentPadding: EdgeInsets.zero,
                                      value: rememberValue,
                                      activeColor:
                                          Theme.of(context).colorScheme.primary,
                                      onChanged: (newValue) {
                                        setState(() {
                                          rememberValue = newValue;
                                        });
                                      },
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      bool internet =
                                          await InternetConnectionChecker()
                                              .hasConnection;
                                      if (internet) {
                                        if (_formKey.currentState.validate()) {
                                          // ignore: deprecated_member_use
                                          List<LoginData> _session =
                                              // ignore: deprecated_member_use
                                              List<LoginData>();
                                          await fetchLogin(numero)
                                              .then((value) {
                                            _session.addAll(value);
                                          });
                                          if (_session.isNotEmpty) {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            if (rememberValue == true)
                                              await DatabaseHelper.instance
                                                  .addNumero(
                                                Grocery(
                                                    numero: int.parse(numero)),
                                              );
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      new ChatScreen23(
                                                          token: _session[0]
                                                              .token
                                                              .toString(),
                                                          contatto: _session[0]
                                                              .contatto
                                                              .toString())),
                                            );
                                            setState(() {
                                              isLoading = true;
                                            });
                                          } else {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12)),
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 24,
                                                          vertical: 30),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          const Text("Errore!",
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              )),
                                                          const Text(
                                                              "Non riusciamo ad associare il numero selezionato ad un nostro cliente.",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              )),
                                                          const SizedBox(
                                                            height: 16,
                                                          ),
                                                          MaterialButton(
                                                            onPressed:
                                                                () async {
                                                              setState(() {});
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                "Riprova"),
                                                            color:
                                                                Color.fromARGB(
                                                                    174,
                                                                    140,
                                                                    235,
                                                                    123),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                            minWidth:
                                                                double.infinity,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                });
                                            setState(() {
                                              isLoading = true;
                                            });
                                          }
                                        }
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12)),
                                                child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 24,
                                                      vertical: 30),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      const Text("Errore!",
                                                          textAlign:
                                                              TextAlign.right,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          )),
                                                      const Text(
                                                          "Non sei connesso ad Internet.",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          )),
                                                      const SizedBox(
                                                        height: 16,
                                                      ),
                                                      MaterialButton(
                                                        onPressed: () async {
                                                          setState(() {});
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            "Riprova"),
                                                        color: Color.fromARGB(
                                                            174, 140, 235, 123),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                        minWidth:
                                                            double.infinity,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.fromLTRB(
                                          40, 15, 40, 15),
                                    ),
                                    child: const Text(
                                      'Entra',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    TextEditingController controller = TextEditingController();
                    controller.text = snapshot.data.toString();
                    return Scaffold(
                      backgroundColor: Colors.white,
                      body: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Align(
                                alignment: Alignment.bottomCenter,
                                child: Image.asset(
                                  'assets/logo.png',
                                )),
                            const SizedBox(
                              height: 50.0,
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Container(
                                    width: 300.0,
                                    child: TextFormField(
                                      controller: controller,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      validator: (value) => (value.length) == 10
                                          ? null
                                          : "Inserire un numero di Telefono valido",
                                      onChanged: (val) {
                                        if (val.length == 10) numero = val;
                                      },
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                        hintText: 'Scrivi qui il tuo numero',
                                        prefixIcon: const Icon(Icons.phone),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 300.0,
                                    child: CheckboxListTile(
                                      title: const Text("Ricorda Numero"),
                                      contentPadding: EdgeInsets.zero,
                                      value: rememberValue,
                                      activeColor:
                                          Theme.of(context).colorScheme.primary,
                                      onChanged: (newValue) {
                                        setState(() {
                                          rememberValue = newValue;
                                        });
                                      },
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (numero == null)
                                        numero = controller.text;
                                      bool internet =
                                          await InternetConnectionChecker()
                                              .hasConnection;
                                      if (internet) {
                                        if (_formKey.currentState.validate()) {
                                          print(numero);
                                          // ignore: deprecated_member_use
                                          List<LoginData> _session =
                                              // ignore: deprecated_member_use
                                              List<LoginData>();
                                          await fetchLogin(numero)
                                              .then((value) {
                                            _session.addAll(value);
                                          });
                                          if (_session.isNotEmpty) {
                                            if (rememberValue == true)
                                              await DatabaseHelper.instance
                                                  .addNumero(
                                                Grocery(
                                                    numero: int.parse(numero)),
                                              );
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      new ChatScreen23(
                                                          token: _session[0]
                                                              .token
                                                              .toString(),
                                                          contatto: _session[0]
                                                              .contatto
                                                              .toString())),
                                            );
                                          } else {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12)),
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 24,
                                                          vertical: 30),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          const Text("Errore!",
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              )),
                                                          const Text(
                                                              "Non riusciamo ad associare il numero selezionato ad un nostro cliente.",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              )),
                                                          const SizedBox(
                                                            height: 16,
                                                          ),
                                                          MaterialButton(
                                                            onPressed:
                                                                () async {
                                                              setState(() {});
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                "Riprova"),
                                                            color:
                                                                Color.fromARGB(
                                                                    174,
                                                                    140,
                                                                    235,
                                                                    123),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                            minWidth:
                                                                double.infinity,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                });
                                          }
                                        }
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12)),
                                                child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 24,
                                                      vertical: 30),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      const Text("Errore!",
                                                          textAlign:
                                                              TextAlign.right,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          )),
                                                      const Text(
                                                          "Non sei connesso ad Internet.",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          )),
                                                      const SizedBox(
                                                        height: 16,
                                                      ),
                                                      MaterialButton(
                                                        onPressed: () async {
                                                          setState(() {});
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            "Riprova"),
                                                        color: Color.fromARGB(
                                                            174, 140, 235, 123),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                        minWidth:
                                                            double.infinity,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.fromLTRB(
                                          40, 15, 40, 15),
                                    ),
                                    child: const Text(
                                      'Entra',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                }),
          );
  }
}

class Grocery {
  final int numero;
  Grocery({this.numero});
  factory Grocery.fromMap(Map<String, dynamic> json) => new Grocery(
        numero: json['numero'],
      );

  Map<String, dynamic> toMap() {
    return {
      'numero': numero,
    };
  }
}

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, ' groceries.db ');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE groceries (
    id INTEGER PRIMARY KEY,
    numero varchar
    )
    ''');
  }

  Future<List<Grocery>> getGroceries() async {
    Database db = await instance.database;
    var groceries = await db.query('groceries');
    List<Grocery> groceryList = groceries.isNotEmpty
        ? groceries.map((c) => Grocery.fromMap(c)).toList()
        : [];
    return groceryList;
  }

  Future<int> addNumero(Grocery grocery) async {
    int numero = grocery.numero;
    Database db = await instance.database;
    await db.rawInsert('INSERT INTO groceries(numero) VALUES($numero)');
    return 1;
  }

  Future<String> select() async {
    Database db = await instance.database;
    List<Map> result =
        await db.rawQuery('SELECT numero FROM groceries ORDER BY id DESC');
    if (result.isEmpty)
      return '';
    else
      return result[0]["numero"];
  }
}
