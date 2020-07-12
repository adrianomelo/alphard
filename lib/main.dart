import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:media_gallery/media_gallery.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:transparent_image/transparent_image.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Media> _media = [];
  final picker = ImagePicker();
  final media = MediaGallery();

  Future listCollection() async {
    List<MediaCollection> a =
        await MediaGallery.listMediaCollections(mediaTypes: [MediaType.image]);
    MediaCollection collection = a.first;
    MediaPage media =
        await collection.getMedias(mediaType: MediaType.image, take: 200000);

    setState(() {
      _media = media.items;
    });
  }

  Future init() async {
    final storagesStatus = await Permission.storage.request().isGranted;
    final photosStatus = await Permission.photos.request().isGranted;

    return listCollection();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: GridView.count(
        primary: false,
        //padding: const EdgeInsets.all(0),
        padding: EdgeInsets.only(top: 4),
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        crossAxisCount: 4,
        children: _media
            .map((m) => FadeInImage(
                fit: BoxFit.cover,
                width: 50,
                height: 50,
                placeholder: MemoryImage(kTransparentImage),
                image: MediaThumbnailProvider(media: m)))
//            .map((f) => FutureBuilder(
//                  future: f.getFile(),
//                  builder:
//                      (BuildContext context, AsyncSnapshot<File> snapshot) {
//                    if (snapshot.hasData) {
//                      return Image.file(snapshot.data, scale: 2);
//                    }
//                    return Text("wait..");
//                  },
//                ))
            .toList(),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: init,
        tooltip: 'Load',
        child: Icon(Icons.add_a_photo),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
