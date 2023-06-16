/*
Questo file contine l'interfaccia grafica della home e la classe FunctionManager che contiene gli switch che contrassegnano l'accensione o lo spegnimento delle azioni.
*/

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'change_pwd.dart';
import 'package:lottie/lottie.dart';
import 'help.dart';
import 'package:sms_camera/globals.dart' as globals;
import 'package:file_picker/file_picker.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  Home createState() => Home();
}

@immutable
// ignore: must_be_immutable
class Home extends State<MainPage> {
  //Home({super.key});
  @override
  Widget build(BuildContext context) {
    if (globals.kDebugMode) {
      // ignore: avoid_print
      print('Home');
    }
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Sms Camera',
                style: TextStyle(fontSize: 40),
              ),
              const Text(
                'Version 1.0.1',
                style: TextStyle(fontSize: 20),
              ),
              Column(
                children: [
                  Lottie.network(
                      'https://assets10.lottiefiles.com/packages/lf20_6e0qqtpa.json',
                      height: 500,
                      width: 500),
                ],
              ),
              const Text(
                'Leave the app open',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const Text(
                'I\'ll think the rest of the way',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChangePWD()),
                    );
                  },
                  child: const Text('Change password'),
                ),
              ),
            ]),
      ),
      floatingActionButton: SpeedDial(
          icon: Icons.settings,
          backgroundColor: Colors.amber,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.help),
              label: 'Help',
              backgroundColor: Colors.amberAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Help()),
                );
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.photo_camera),
              label: 'Activate/Deactivate: Take Photo',
              backgroundColor: globals.fun.switchTakePhoto == true
                  ? const Color.fromARGB(255, 109, 255, 64)
                  : const Color.fromARGB(255, 255, 64, 64),
              onTap: () {
                globals.fun = globals.fun.copyWith(
                    switchBASETakePhoto: !globals.fun.switchTakePhoto);
                setState(() {});
                globals.fun.switchBASETakePhoto =
                    !globals.fun.switchBASETakePhoto;
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.send),
              label: 'Activate/Deactivate: Send Photo',
              backgroundColor: globals.fun.switchSendPhoto
                  ? const Color.fromARGB(255, 109, 255, 64)
                  : const Color.fromARGB(255, 255, 64, 64),
              onTap: () {
                globals.fun = globals.fun.copyWith(
                    switchBASESendPhoto: !globals.fun.switchSendPhoto);
                setState(() {});
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.record_voice_over),
              label: 'Activate/Deactivate: Record Audio',
              backgroundColor: globals.fun.switchRec
                  ? const Color.fromARGB(255, 109, 255, 64)
                  : const Color.fromARGB(255, 255, 64, 64),
              onTap: () {
                globals.fun =
                    globals.fun.copyWith(switchBASERec: !globals.fun.switchRec);
                setState(() {});
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.folder),
              label: 'Set recordings folder',
              backgroundColor: globals.fun.switchRec
                  ? const Color.fromARGB(255, 109, 255, 64)
                  : const Color.fromARGB(255, 255, 64, 64),
              onTap: () async {
                globals.recDirectory =
                    await FilePicker.platform.getDirectoryPath();
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.play_circle),
              label: 'Activate/Deactivate: Play Audio',
              backgroundColor: globals.fun.switchPlay
                  ? const Color.fromARGB(255, 109, 255, 64)
                  : const Color.fromARGB(255, 255, 64, 64),
              onTap: () {
                globals.fun = globals.fun
                    .copyWith(switchBASEPlay: !globals.fun.switchPlay);
                setState(() {});
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.notifications),
              label: 'Activate/Deactivate: Notifications',
              backgroundColor: globals.fun.switchNotifications
                  ? const Color.fromARGB(255, 109, 255, 64)
                  : const Color.fromARGB(255, 255, 64, 64),
              onTap: () {
                globals.fun = globals.fun.copyWith(
                    switchBASENotifications: !globals.fun.switchNotifications);
                setState(() {});
              },
            ),
          ]),
    );
  }
}

class FunctionManager {
  // cosi perchè con un array di bool non posso fare una copia
  var switchBASETakePhoto = true;
  var switchBASESendPhoto = true;
  var switchBASERec = true;
  var switchBASEPlay = true;
  var switchBASENotifications = true;
  final bool switchTakePhoto;
  final bool switchSendPhoto;
  final bool switchRec;
  final bool switchPlay;
  final bool switchNotifications;

  FunctionManager({
    this.switchTakePhoto = true,
    this.switchSendPhoto = false,
    this.switchRec = true,
    this.switchPlay = true,
    this.switchNotifications = true,
  });

  FunctionManager copyWith({
    bool? switchBASETakePhoto,
    bool? switchBASESendPhoto,
    bool? switchBASERec,
    bool? switchBASEPlay,
    bool? switchBASENotifications,
  }) {
    return FunctionManager(
      switchTakePhoto: switchBASETakePhoto ?? switchTakePhoto,
      switchSendPhoto: switchBASESendPhoto ?? switchSendPhoto,
      switchRec: switchBASERec ?? switchRec,
      switchPlay: switchBASEPlay ?? switchPlay,
      switchNotifications: switchBASENotifications ?? switchNotifications,
    );
  }
}
