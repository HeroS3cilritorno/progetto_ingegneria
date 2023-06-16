/* Questo file contiene variabili che devono essere condivise da più file .dart */

library sms_camera.globals;

import 'home.dart';

// attiva / disattiva messaggi di debug
bool kDebugMode = true;

var fun = FunctionManager();

// variabili che indicano lo stato dei permessi (true = permesso concesso, false = permesso negato)
bool smsPermissions = true;
bool recorderPermissions = true;
bool storagePermissions = true;
bool cameraPermissions = true;
String? recDirectory = null;
