/*
FILE PRINCIPALE DEL PROGRAMMA

Contine le funzioni principali dell'applicazione:
  - Varie funzioni di supporto (lettura/scrittura/controllo password, gestione degli sms, etc)
  - Gestione della pagina principale (schermata di benvenuto)
  - il main()
  - Tutte le classi delle 4 funzioni svolte dall'applicazione
    + Camera
    + AudioRecorder
    + AudioPlayer
    + PhotoSender

*/

/* Librerie */

// ignore_for_file: import_of_legacy_library_into_null_safe
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sms_camera/change_pwd.dart';
import 'package:sms_camera/home.dart';
import 'package:path_provider/path_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
// ignore: depend_on_referenced_packages
import 'package:crypto/crypto.dart';
import 'dart:io';
import 'globals.dart';
import 'help.dart';
import 'package:telephony/telephony.dart';
import 'package:camera/camera.dart';
import 'package:background_sms/background_sms.dart';
// import 'package:imgur/imgur.dart' as imgur;
// ignore: depend_on_referenced_packages
import 'package:sms_camera/globals.dart' as globals;
import 'dart:async';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:file_picker/file_picker.dart';

// Necessario per utilizzare gli SMS
Telephony telephony = Telephony.instance;

//** Funzioni di supporto al programma */
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

// Funzione: Salva l'hash della password
// chiamata: nel caso in cui si voglia cambiare la password o la creazione di una nuova
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

// Funzione: restituisce la password precedentemente impostata
// chiamata: dalla funzione checkpwd(String password) per verificare la correttezza della password
Future<String> readPWD() async {
  try {
    if (globals.kDebugMode) {
      // ignore: avoid_print
      print("Lettura password");
    }

    final file = await _localFile;

    // Read the file
    final contents = await file.readAsString();
    if (globals.kDebugMode) {
      if (globals.kDebugMode) {
        // ignore: avoid_print
        print("password in memoria: $contents");
      }
    }
    return contents;
  } catch (e) {
    return "NOT_SET";
  }
}

// Funzione: verificare la correttezza della password
// chiamata: ogni qualvolta si riceve un SMS per eseguire una azione
Future<bool> checkpassword(String password) async {
  if (globals.kDebugMode) {
    // ignore: avoid_print
    print("controllo password");
  }
  String passwordHash = await readPWD();
  readPWD().then((value) {
    passwordHash = value;
    return value;
  });
  if (passwordHash == "NOT_SET") {
    // ignore: avoid_print
    print("non settatta");
    return false;
  } else {
    var key = utf8.encode(password);
    var hash = sha256.convert(key);
    if (hash.toString() == passwordHash) {
      if (globals.kDebugMode) {
        // ignore: avoid_print
        print("password corretta");
      }
      return true;
    } else {
      if (globals.kDebugMode) {
        // ignore: avoid_print
        print("password errata");
      }
      return false;
    }
  }
}

// Funzione: richiede i vari permessi necessari all'applicazione: CAMERA, STORAGE, SMS, MICROPHONE
// chiamata: nel main()
void requestPermissions(var context) async {
  if (await Permission.camera.isDenied) {
    await Permission.camera.request();
  } else {
    globals.cameraPermissions = true;
  }
  if (await Permission.storage.isDenied) {
    await Permission.storage.request();
  } else {
    globals.storagePermissions = true;
  }
  if (await Permission.sms.isDenied) {
    await Permission.sms.request();
  } else {
    globals.smsPermissions = true;
  }
  if (await Permission.microphone.isDenied) {
    await Permission.microphone.request();
  } else {
    globals.recorderPermissions = true;
  }

  // Controllo dei permessi => se non sono stati concessi, viene comunicato all'utente
  if (globals.cameraPermissions == false) {
    AlertDialog(
      title: const Text('Error'),
      content: const Text(
          'Permissions not granted you need to grant camera permission to make this application work correctly'),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
  if (globals.storagePermissions == false) {
    AlertDialog(
      title: const Text('Error'),
      content: const Text(
          'Permissions not granted you need to grant storage permission to make this application work correctly'),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
  if (globals.smsPermissions == false) {
    AlertDialog(
      title: const Text('Error'),
      content: const Text(
          'Permissions not granted you need to grant SMS permission to make this application work correctly'),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
  if (globals.recorderPermissions == false) {
    AlertDialog(
      title: const Text('Error'),
      content: const Text(
          'Permissions not granted you need to grant microphone permission to make this application work correctly'),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}

/* MAIN */
void main() async {
  // come da documentazione è necessario chiamare WidgetsFlutterBinding.ensureInitialized() prima di tutto (quando si usa la keyword async)
  WidgetsFlutterBinding.ensureInitialized();

  // Gestisce gli sms in arrivo: specifica che funzione deve essere eseguita quando viene ricevuto un sms
  telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        backgroundMessageHandler(message);
      },
      onBackgroundMessage:
          backgroundMessageHandler // funzione per gestire i messaggi in background
      );

  // In caso di primo avvio, crea una password => HomePage(title: 'Benvenuto, imposta la tua password!')
  Future<String> storedPWDFuture = readPWD();
  String storedPWD = await storedPWDFuture;

  if (storedPWD == "NOT_SET") {
    FlutterNativeSplash.remove();
    runApp(const SMSCamera()); // imposta la password
  } else {
    FlutterNativeSplash.remove();
    WidgetsFlutterBinding.ensureInitialized();
    runApp(const MaterialApp(
        home: MainPage())); // reindirizza alla pagina principale
  }
}

// Funzione: invia gli SMS
// Chiamata: ogni qualvolta si riceve un SMS ed un azione viene eseguita (invia un SMS con l'esito dell'azione)
// ignore: non_constant_identifier_names
void sending_SMS(String msg, String phoneNumber) async {
  BackgroundSms.sendMessage(phoneNumber: phoneNumber, message: msg);
}

// Classe principale
class SMSCamera extends StatelessWidget {
  const SMSCamera({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /* Permessi */
    requestPermissions(context);
    return MaterialApp(
      title: 'SMS Camera',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'Benvenuto, imposta la tua password!'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pwdController = TextEditingController();

  // Funzione: imposta la password esclusivamente se non è stata impostata una password precedentemente (NOT_SET)
  void _storePWD() {
    String password = pwdController.text;
    bool result = PasswordManager().checksecure(pwdController, context);
    if (globals.kDebugMode && result != false) {
      // ignore: avoid_print
      print("Hai impostato correttamente la password: $password");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    }
  }

  // Grafica della di benvenuto
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: <Widget>[
            const Row(children: [
              Text(
                'Hi, get ready!',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            ]),
            const Row(children: [
              Text(
                'set your password to start',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            ]),
            Container(
              padding:
                  const EdgeInsets.all(4), // aggiusta il margine nel container
              decoration: BoxDecoration(
                color: Colors.blue[600],
                borderRadius: BorderRadius.circular(50),
              ),
              margin: const EdgeInsets.only(top: 20),
              child: TextField(
                controller: pwdController,
                obscureText: true,
                decoration: const InputDecoration(
                  icon: Icon(Icons.lock),
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: ListTile(
                title: const Text(
                  'How does it work?',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Help()),
                  );
                },
              ),
            ),
            Column(children: [
              Image.asset(
                'assets/smartphonerobot.png',
              ),
              Lottie.network(
                  'https://assets4.lottiefiles.com/packages/lf20_bk87clix.json',
                  height: 100,
                  width: 100),
            ])
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _storePWD,
        tooltip: 'send',
        child: const Icon(Icons.send),
      ),
    );
  }
}

String photoPath = '';
String? address = '';

AudioPlayer_ audioPlayer =
    AudioPlayer_(); // crea un oggetto di tipo AudioPlayer_ per poter eseguire le funzioni di audio (qui perchè deve essere condiviso)
final recorder =
    AudioRecorder(); // crea un oggetto di tipo AudioRecorder per poter eseguire le funzioni di registrazione audio (qui perchè deve essere condiviso)

void initState() {
  recorder.init();
}

void dispose() {
  recorder.dispose();
}

// Funzione: gestisce la ricezione di un SMS "speciale", ovvero di quel SMS con una specifica sintassi che permette l'eseguimento di un comando
// Chiamata: a inizio del programma da telephony.listenIncomingSms()
backgroundMessageHandler(SmsMessage message) async {
  // ignore: non_constant_identifier_names
  NotificationManager Notifmanager = NotificationManager();
  if (globals.kDebugMode) {
    // ignore: avoid_print
    print("Messaggio ricevuto in background: ${message.body}");
  }
  switch (message.body?.split(' ')[0]) {
    case 'TAKE_PHOTO':
      if (globals.kDebugMode) {
        // ignore: avoid_print
        print("TAKE_PHOTO");
      }
      if (globals.fun.switchTakePhoto) {
        Camera().shot(
            message); // scatta la foto e invia un sms di conferma al richiedente
      }
      break;
    case "SND_PHOTO":
      if (globals.kDebugMode) {
        // ignore: avoid_print
        print("SND_PHOTO");
      }

      if (globals.fun.switchSendPhoto) {
        PhotoSender().send(message); // carica la foto
      }
      break;

    case "START_REC":
      if (globals.kDebugMode) {
        // ignore: avoid_print
        print("START_REC");
      }
      if (globals.fun.switchRec) {
        initState(); // inizializza il recorder
        var words = message.body?.split(' ');
        String password = words![1];
        bool result = await checkpassword(password);
        if (result) {
          recorder._record();
          if (globals.kDebugMode) {
            // ignore: avoid_print
            print("Recording started");
          }
          if (globals.fun.switchNotifications) {
            Notifmanager.notify("Recorder", "Recorder started");
          }
          sending_SMS("Recording started", message.address!);
        }
      }
      break;
    case "STOP_REC":
      // ignore: avoid_print
      print("STOP_REC");
      var words = message.body?.split(' ');
      String password = words![1];
      bool result = await checkpassword(password);
      if (result) {
        recorder._stop(message.address!);
        if (globals.kDebugMode) {
          // ignore: avoid_print
          print("Recording stopped");
        }
        dispose(); // disattiva (libera) il recorder
      }
      break;

    case "PLAY":
      if (globals.kDebugMode) {
        // ignore: avoid_print
        print("PLAY");
      }
      if (globals.fun.switchPlay) {
        var words = message.body?.split(' ');
        String fileName = words![1];
        String password = words[2];
        bool result = await checkpassword(password);
        if (result) {
          try {
            audioPlayer.playaudio(fileName);
            sending_SMS("Playing $fileName", message.address!);
          } catch (e) {
            sending_SMS("Having trouble playing $fileName", message.address!);
            if (globals.kDebugMode) {
              // ignore: avoid_print
              print(e);
            }
          }
        }
      }
      break;
    case "STOP_PLAY":
      if (globals.kDebugMode) {
        // ignore: avoid_print
        print("STOP_PLAY");
      }
      var words = message.body?.split(' ');
      String password = words![1];
      bool result = await checkpassword(password);
      if (result) {
        try {
          audioPlayer.stopaudio();
          sending_SMS("Playing stopped", message.address!);
        } catch (e) {
          sending_SMS("Having trouble stopping audio", message.address!);
          if (globals.kDebugMode) {
            // ignore: avoid_print
            print(e);
          }
        }
      }
      break;
    default:
      if (globals.kDebugMode) {
        // ignore: avoid_print
        print("Messaggio non gestito");
      }
      break;
  }
}

// ignore: camel_case_types
class AudioPlayer_ {
  static final audioPlayer = AudioPlayer();
  bool isplaying = false;
  Duration duration = Duration.zero; // durata del file audio
  Duration position =
      Duration.zero; // posizione (minuti trascorsi) del file audio

  // riproduce l'audio
  playaudio(String filePath) async {
    bool url = Uri.tryParse(filePath)?.hasAbsolutePath ?? false;
    if (!url) {
      var file = File(filePath);
      if (await file.exists()) {
        audioPlayer.play(filePath);

        if (globals.fun.switchNotifications) {
          NotificationManager().notify("Play", "Playing $filePath");
        }
      } else {
        if (globals.kDebugMode) {
          // ignore: avoid_print
          print("File not found");
        }
        NotificationManager().notify("Play", "File not found: $filePath");
      }
    } else {
      audioPlayer.play(filePath);
      if (globals.fun.switchNotifications) {
        NotificationManager().notify("Play", "Playing $filePath");
      }
    }
  }

  // stoppa l'audio
  stopaudio() async {
    var stop = audioPlayer.stop();
    if (await stop == 1) {
      if (globals.fun.switchNotifications) {
        NotificationManager().notify("Play", "Stopped playing");
      }
    }
  }
}

class NotificationManager {
  var fun = globals.fun;
  // ignore: non_constant_identifier_names
  static final NotificationManager _NotificationManager =
      NotificationManager._internal();

  factory NotificationManager() {
    return _NotificationManager;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationManager._internal();

  Future<void> initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(int i, String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('1', 'SMS Camera',
            channelDescription: 'body',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(i, title, body, platformChannelSpecifics, payload: 'item x');
  }

  int i = 0;
  notify(String title, String body) {
    initNotification();
    if (fun.switchNotifications) {
      i++;
      showNotification(i, title, body);
      if (globals.kDebugMode) {
        // ignore: avoid_print
        print("Notifica $title $body");
      }
    }
  }
}

class Camera {
  shot(var message) async {
    var words = message.body?.split(' ');
    String camerafb = words![1];
    String password = words[2];
    bool result = await checkpassword(password);
    if (globals.kDebugMode) {
      // ignore: avoid_print
      print("camera: $camerafb, password: $password");
    }
    CameraDescription camera;
    if (result) {
      if (camerafb == '1') {
        camera = (await availableCameras())[0];
      } else {
        camera = (await availableCameras())[1];
      }

      final controller = CameraController(camera, ResolutionPreset.medium);
      try {
        await controller.initialize();
        await controller.setFlashMode(FlashMode.off);

        final image = await controller.takePicture();
        var file = File(image.path);
        var newFile =
            '/storage/emulated/0/Pictures/${file.path.split('/').last}';
        if (await file.exists() == true) {
          file.copy(newFile);
        }
        controller.dispose();

        String path = image.path;
        if (globals.kDebugMode) {
          // ignore: avoid_print
          print(path);
        }
        if (globals.fun.switchNotifications) {
          NotificationManager().notify("Photo",
              "Photo taken: $newFile"); // notifica che la foto è stata scattata
        }
        sending_SMS("Here's the shot: $newFile", message.address!);
      } catch (e) {
        if (globals.kDebugMode) {
          // ignore: avoid_print
          print(e);
        }
        controller.dispose();
      }
    }
  }
}

class PhotoSender {
  late String link;
  Future<void> send(var message) async {
    var words = message.body?.split(' ');
    String photoPath = words[1]; // path della foto da inviare
    String password = words[2]; // password
    if (globals.kDebugMode) {
      // ignore: avoid_print
      print('entrato');
      // ignore: avoid_print
      print("password: $password");
    }
    bool result = await checkpassword(password);
    if (result) {
      if (globals.kDebugMode) {
        // ignore: avoid_print
        print("Caricamento foto: $photoPath");
      }
      final url = Uri.parse('https://api.imgur.com/3/image');
      final request = await HttpClient().postUrl(url);
      request.headers.set('Authorization', 'Client-ID fc6c5687f4f6e29');
      final bytes = File(photoPath).readAsBytesSync();
      request.add(bytes);
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      final jsonResponse = json.decode(responseBody);
      final imageUrl = jsonResponse['data']['link'];

      if (globals.kDebugMode) {
        print('Uploaded image to: $imageUrl');
        link = imageUrl;
      }

      if (globals.fun.switchNotifications) {
        NotificationManager()
            .notify("Photo", "Photo sent, uploaded image to: $imageUrl");
      }
      sending_SMS(imageUrl, message.address!);
    }
  }
/* VECCHIA IMPLEMENTAZIONE:
  send(var message) async {     
    var words = message.body?.split(' ');
    String authToken =
        'fc6c5687f4f6e29'; // token di autenticazione (client ID) di imgur
    String photoPath = words[1]; // path della foto da inviare
    String password = words[2]; // password
    if (globals.kDebugMode) {
      // ignore: avoid_print
      print('entrato');
      // ignore: avoid_print
      print("authToken: $authToken, password: $password");
    }
    bool result = await checkpassword(password);
    if (result) {
      final client = imgur.Imgur(imgur.Authentication.fromToken(authToken));
      if (globals.kDebugMode) {
        // ignore: avoid_print
        print("Caricamento foto: $photoPath");
      }
      await client.image
          .uploadImage(
              imagePath: photoPath, title: 'SMSCamera', description: '')
          .then((image) {
        if (globals.kDebugMode) {
          // ignore: avoid_print
          print('Uploaded image to: ${image.link}');
          link = image.link;
        }
        if (globals.fun.switchNotifications) {
          NotificationManager()
              .notify("Photo", "Photo sent, uploaded image to: ${image.link}");
        }
        sending_SMS(image.link, message.address!);
      });
    }
  }
  */
}

class AudioRecorder {
  FlutterSoundRecorder? _audioRecorder;
  bool _isRecordingInitialised = false;
  // ignore: prefer_typing_uninitialized_variables
  var filePath;

  Future init() async {
    _audioRecorder = FlutterSoundRecorder();
    await _audioRecorder!.openRecorder();
    _isRecordingInitialised = true;
  }

  void dispose() {
    if (!_isRecordingInitialised) return;
    _audioRecorder!.closeRecorder();
    _audioRecorder = null;
    _isRecordingInitialised = false;
  }

  Future _record() async {
    globals.recDirectory ??= await FilePicker.platform.getDirectoryPath();
    filePath =
        "$recDirectory/SMSCamera_${DateTime.now().millisecondsSinceEpoch}.aac";
    if (!_isRecordingInitialised) return;
    await _audioRecorder!.startRecorder(toFile: filePath);
  }

  Future _stop(String phoneNumber) async {
    if (!_isRecordingInitialised) return;
    await _audioRecorder!.stopRecorder().then((value) {
      if (globals.kDebugMode) {
        // ignore: avoid_print
        print('Recording stopped');
      }
      sending_SMS("Recording stopped, filePath: $filePath", phoneNumber);
    });
  }
}
