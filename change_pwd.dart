/*
Questo file contiene tutte le funzione e l'UI dedicato alla modifica della password.


*/

// ignore: file_names
// controllare che la password rispecchi le caratteristiche di una passwordsicura
import 'dart:convert';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:lottie/lottie.dart';
import 'dart:io';
import 'package:sms_camera/globals.dart' as globals;

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  if (globals.kDebugMode) {
    // ignore: avoid_print
    print(path);
  }
  return File('$path/password.txt');
}

Future<File> storePWD(String password) async {
  final file = await _localFile;
  var key = utf8.encode(password);
  var hash = sha256.convert(key);

  if (globals.kDebugMode) {
    // ignore: avoid_print
    print("salvato l'hash: ${hash.toString()}");
  }
  // Write the file
  return file.writeAsString(hash.toString());
}

class ChangePWD extends StatefulWidget {
  const ChangePWD({Key? key}) : super(key: key);

  @override
  State<ChangePWD> createState() => _ChangePWDState();
}

class _ChangePWDState extends State<ChangePWD> {
  TextEditingController pwdController1 = TextEditingController();

  TextEditingController pwdController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800],
      appBar: AppBar(
        title: const Text('Change password'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Input your new password below:',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.all(4), // aggista il margine nel container
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 168, 214, 255),
                borderRadius: BorderRadius.circular(50),
              ),
              margin: const EdgeInsets.only(top: 20),
              child: TextField(
                controller: pwdController1,
                obscureText: true,
                decoration: const InputDecoration(
                  icon: Icon(Icons.lock),
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.all(4), // aggista il margine nel container
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 168, 214, 255),
                borderRadius: BorderRadius.circular(50),
              ),
              margin: const EdgeInsets.only(top: 20),
              child: TextField(
                controller: pwdController2,
                obscureText: true,
                decoration: const InputDecoration(
                  icon: Icon(Icons.lock),
                  labelText: 'Cornfirm new password',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (pwdController1.text.isEmpty ||
                    pwdController2.text.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: const Text('Please fill all the fields'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      });
                } else if (pwdController1.text != pwdController2.text) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: const Text('Passwords do not match'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      });
                  // controllo sicurezza password
                } else {
                  PasswordManager passwordManager = PasswordManager();
                  passwordManager.checksecure(pwdController1, context);
                }
              },
              child: const Text('Change',
                  style: TextStyle(
                    fontSize: 30,
                  )),
            ),
            Column(
              children: [
                Lottie.network(
                    'https://assets3.lottiefiles.com/packages/lf20_xf9ppc6p.json',
                    height: 300,
                    width: 300),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// classe per la gestione delle password: è utilizzata anche da main.dart per il set della prima password
class PasswordManager {
  // se la password rispetta le caratteristiche di una password sicura imposta la password, altrimenti torna false
  checksecure(var pwdController, var context) {
    bool secure = (pwdController.text.length < 8 ||
            !pwdController.text.contains(RegExp(r'[0-9]')) ||
            !pwdController.text.contains(RegExp(r'[a-z]')) ||
            !pwdController.text.contains(RegExp(r'[A-Z]')) ||
            !pwdController.text
                .contains(RegExp(r'[!@#$%^&*()_+\-=\[\]{};:"\\|,.<>\/?]')))
        ? false
        : true;

    if (pwdController.text.length < 8) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content:
                  const Text('Password must be at least 8 characters long'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
      secure = false;
    }
    if (!pwdController.text.contains(RegExp(r'[0-9]'))) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Password must contain at least one number'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
    if (!pwdController.text.contains(RegExp(r'[a-z]'))) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text(
                  'Password must contain at least one lowercase letter'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
    if (!pwdController.text.contains(RegExp(r'[A-Z]'))) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text(
                  'Password must contain at least one uppercase letter'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
    if (!pwdController.text
        .contains(RegExp(r'[!@#$%^&*()_+\-=\[\]{};:"\\|,.<>\/?]'))) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text(
                  'Password must contain at least one special character'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }

    if (secure == true) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Password set successfully'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });

      // la password è sicura, imposta la password
      storePWD(pwdController.text).then((File file) {
        //Navigator.of(context).pop();
        return true;
      });
    } else {
      return false;
    }
    return secure;
  }
}
