import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Help extends StatelessWidget {
  const Help({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          title: const Text('Help'),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Lottie.network(
              'https://assets8.lottiefiles.com/packages/lf20_mn0yeqfs.json',
              height: 400,
              width: 400),
          Lottie.network(
            'https://assets4.lottiefiles.com/packages/lf20_o87tttfh.json',
            height: 270,
            width: 300,
          ),
          // titolo
          const Padding(padding: EdgeInsets.all(20.0)),
          const Text(
            "Commands:",
            style: TextStyle(
              fontSize: 40,
              color: Color.fromARGB(255, 18, 133, 199),
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "",
            style: TextStyle(
              fontSize: 20,
              color: Color.fromARGB(255, 18, 133, 199),
              fontWeight: FontWeight.bold,
            ),
          ),

          const Padding(padding: EdgeInsets.all(20.0)),
          const Text(
            "Take a photo",
            style: TextStyle(
              fontSize: 25,
              color: Color.fromARGB(255, 18, 133, 199),
              fontWeight: FontWeight.bold,
            ),
          ),
          const Padding(padding: EdgeInsets.all(10.0)),
          Lottie.network(
            'https://assets1.lottiefiles.com/packages/lf20_jhlaooj5.json',
            height: 270,
            width: 300,
          ),

          // scatta foto
          const Text(
            "\n TAKE_PHOTO [1/2] [Password]",
            style: TextStyle(
              fontSize: 15,
              color: Color.fromARGB(255, 18, 133, 199),
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "\nTo take a photo, just send an SMS with the command TAKE_PHOTO followed by 1 (front camera) or 2 (rear camera) and the password. ",
            style: TextStyle(
              fontSize: 12,
              color: Color.fromARGB(255, 18, 133, 199),
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "\n Example: TAKE_PHOTO 1 P@ssword123",
            style: TextStyle(
              fontSize: 15,
              color: Color.fromARGB(255, 0, 0, 0),
              backgroundColor: Color.fromARGB(207, 75, 71, 75),
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "\nIf the recipient's phone number (this phone) has an active plan that allows sending SMS, you should be able to receive a reply SMS with the path where the photo is saved. ",
            style: TextStyle(
              fontSize: 12,
              color: Color.fromARGB(255, 18, 133, 199),
              fontWeight: FontWeight.bold,
            ),
          ),

          // invia foto
          const Padding(padding: EdgeInsets.all(20.0)),
          const Text(
            "Send a photo",
            style: TextStyle(
              fontSize: 25,
              color: Color.fromARGB(255, 18, 133, 199),
              fontWeight: FontWeight.bold,
            ),
          ),
          const Padding(padding: EdgeInsets.all(10.0)),
          Lottie.network(
            'https://assets10.lottiefiles.com/packages/lf20_gMQp3a.json',
            height: 270,
            width: 300,
          ),
          const Text(
            "\n SND_PHOTO [path] [Password]",
            style: TextStyle(
              fontSize: 15,
              color: Color.fromARGB(255, 18, 133, 199),
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "\nTo send a photo, just send an SMS with the command SND_PHOTO followed by the path of the photo and the password. ",
            style: TextStyle(
              fontSize: 12,
              color: Color.fromARGB(255, 18, 133, 199),
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "\nExample: \nSND_PHOTO /storage/emulated/0/Pictures/CAP8057884688771743115.jpg P@ssword123",
            style: TextStyle(
              fontSize: 15,
              color: Color.fromARGB(255, 0, 0, 0),
              backgroundColor: Color.fromARGB(207, 75, 71, 75),
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "\nIf the recipient's phone number (this phone) has an active plan that allows sending SMS, you should be able to receive a reply SMS with an imgur link to the photo. ",
            style: TextStyle(
              fontSize: 12,
              color: Color.fromARGB(255, 18, 133, 199),
              fontWeight: FontWeight.bold,
            ),
          ),
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text:
                      "Note: \nby default, the SND_PHOTO command is disabled. \nYou can enable it with a tap on this (",
                  style: TextStyle(
                    color: Color.fromARGB(255, 199, 120, 18),
                  ),
                ),
                WidgetSpan(
                  child: Icon(Icons.send),
                ),
                TextSpan(
                  text: ") icon that you can find in the speed dial menu. (",
                  style: TextStyle(color: Color.fromARGB(255, 199, 120, 18)),
                ),
                WidgetSpan(
                  child: Icon(Icons.settings),
                ),
                TextSpan(
                  text: ")",
                  style: TextStyle(color: Color.fromARGB(255, 199, 120, 18)),
                ),
              ],
            ),
          ),

          // Registra audio
          const Padding(padding: EdgeInsets.all(20.0)),
          const Text(
            "Audio record",
            style: TextStyle(
              fontSize: 25,
              color: Color.fromARGB(255, 18, 133, 199),
              fontWeight: FontWeight.bold,
            ),
          ),
          const Padding(padding: EdgeInsets.all(10.0)),
          Lottie.network(
            'https://assets9.lottiefiles.com/packages/lf20_fksm3n4x.json',
            height: 270,
            width: 300,
          ),
          const Text(
            "\n START_REC [Password]\n  STOP_REC [Password]\n",
            style: TextStyle(
              fontSize: 15,
              color: Color.fromARGB(255, 18, 133, 199),
              fontWeight: FontWeight.bold,
            ),
          ),

          const Text(
            "\nTo start microphone recording, just send an SMS with the command START_REC followed by the password to the recipient's phone number (linked to this device). \n You can stop recording at any time by sending the command STOP_REC followed by the password. ",
            style: TextStyle(
              fontSize: 12,
              color: Color.fromARGB(255, 18, 133, 199),
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "\nExample: \nSTART_REC P@ssword123 \n STOP_REC P@ssword123",
            style: TextStyle(
              fontSize: 15,
              color: Color.fromARGB(255, 0, 0, 0),
              backgroundColor: Color.fromARGB(207, 75, 71, 75),
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "\nIf the recipient's phone number (this phone) has an active plan that allows sending SMS, you should be able to receive a reply SMS as confirmation that registration has started, and another one when the recording is over with the path where the audio is saved. \nYou can also view what are the common paths used by this application to save files at the end of this help page.",
            style: TextStyle(
              fontSize: 12,
              color: Color.fromARGB(255, 18, 133, 199),
              fontWeight: FontWeight.bold,
            ),
          ),
          // invia foto
          const Padding(padding: EdgeInsets.all(20.0)),
          const Text(
            "Play an audio",
            style: TextStyle(
              fontSize: 25,
              color: Color.fromARGB(255, 18, 133, 199),
              fontWeight: FontWeight.bold,
            ),
          ),
          const Padding(padding: EdgeInsets.all(10.0)),
          Lottie.network(
            'https://assets7.lottiefiles.com/private_files/lf30_jeq5jw5i.json',
            height: 270,
            width: 300,
          ),
          const Text(
            "\n PLAY [url/path] [Password]\n   STOP_PLAY [Password]",
            style: TextStyle(
              fontSize: 15,
              color: Color.fromARGB(255, 18, 133, 199),
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "\nTo play an audio file, just send an SMS with the command PLAY followed by the path of the audio file and the password. \nTo stop playing, send the command STOP_PLAY followed by the password. ",
            style: TextStyle(
              fontSize: 12,
              color: Color.fromARGB(255, 18, 133, 199),
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "\nExample: \nPLAY https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3 P@ssword123\n\nSTOP_PLAY P@ssword123",
            style: TextStyle(
              fontSize: 15,
              color: Color.fromARGB(255, 0, 0, 0),
              backgroundColor: Color.fromARGB(207, 75, 71, 75),
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "\nIf the recipient's phone number (this phone) has an active plan that allows sending SMS, you should be able to receive text messages that the commands have been executed.",
            style: TextStyle(
              fontSize: 12,
              color: Color.fromARGB(255, 18, 133, 199),
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "\n\nCommon directories:",
            style: TextStyle(
              fontSize: 40,
              color: Color.fromARGB(255, 18, 133, 199),
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "\nPictures: \"/storage/emulated/0/Pictures/\" \nAudio: \"/storage/emulated/0/Android/data/com.lorissimonetti.sms_camera/files/\"",
            style: TextStyle(
              fontSize: 17,
              color: Color.fromARGB(255, 56, 102, 19),
              backgroundColor: Color.fromARGB(50, 56, 102, 19),
              fontWeight: FontWeight.bold,
            ),
          ),
        ])));
  }
}


// Note: by default, the SND_PHOTO command is disabled. You can enable it with a tap on this ("") icon that you can find in the speed dial menu. () 