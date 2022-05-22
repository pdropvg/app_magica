import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';


void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final statuses = [
        Permission.storage,
    ].request();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
    void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final PageController _controller = PageController(
    initialPage: 0,
  );

  Widget build(BuildContext context) {
  final pages = PageView(
    controller: _controller,
    children: [
      HomeWidget(),
      PhotoWidget(),
      ButtonWidget(),
    ],
  );
  return pages;
  }
}

class HomeWidget extends StatelessWidget {

  Widget build(BuildContext context) {
  final children = Scaffold(
    body: new Image.asset(
      "image/home1.jpg",
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
    ),
  );
  return new GestureDetector(
    onTapDown: _onTapDown,
    child: children,
  );
  }

  _onTapDown(TapDownDetails details) {

    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    // or user the local
    print(details.localPosition);

    int dx = (x / 80).floor();
    int dy = ((y - 180) / 100).floor();
    int posicao = dy * 5 + dx;
    print("results: x=$x y=$y $dx $dy $posicao");
    _save(posicao);
  }

  _save(int posicao) async {  /// Salva fotos aleatorias dentro da galeria.
    var appDocDir = await getTemporaryDirectory();
    String savePath = appDocDir.path + "/efeito-$posicao.jpg";
    print(savePath);
    var dio = Dio();
    await dio.download(
      'https://cataas.com/cat.jpeg', savePath);

    // await Dio.download(
    //   "https://github.com/guilhermesilveira/flutter-magic/raw/main/efeito-$posicao.jpg",
    //     savePath);*/
    print("saved!");
    final result = await ImageGallerySaver.saveFile(savePath);
    print(result);
  }
}

class PhotoWidget extends StatelessWidget {

  Widget build(BuildContext context) {
    final children = Scaffold(
      body: new Image.asset(
        "image/home2.jpg",
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,

      ),
    );
    return new GestureDetector(
      onTap: openGallery,
      child: children,
    );
  }

  void openGallery() {
    print("oppening");

     const intent = AndroidIntent(
        action: 'action_view',
        type: 'image/*',
        flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      intent.launch();

  }
}

class ButtonWidget extends StatelessWidget { /// MELHORARRRR

  Widget build(BuildContext context) {
    Widget body;
    if ( 1 == 1) {
      body = Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              onPressed: _createAlarm,
              child: const Text(
                  'Tap here to set an alarm\non weekdays at 9:30pm.'),
            ),
            ElevatedButton(
              onPressed: _createAlarm,
              child: const Text('Tap here to launch Intent with Chooser'),
            ),
            ElevatedButton(
              onPressed: _createAlarm,
              child: const Text('Tap here to send Intent as broadcast'),
            ),
            ElevatedButton(
              onPressed: _createAlarm,
              child: const Text('Tap here to test explicit intents.'),
            ),
          ],
        ),
      );
    } else {
      body = const Text('This plugin only works with Android');
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(child: body),
    );
  }
}

void _createAlarm() {

}
