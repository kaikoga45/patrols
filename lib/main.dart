import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? cameraPermissionStatus;
  late CameraController controller;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    Future.wait([
      Permission.camera.status,
    ]).then((value) {
      setState(() {
        cameraPermissionStatus = value[0].toString();
      });
    });
    WidgetsFlutterBinding.ensureInitialized();
    cameraCheck();
  }

  void cameraCheck() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (description) => description.lensDirection == CameraLensDirection.front,
    );
    setState(() {});
    controller = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    _initializeControllerFuture = controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text('Camera permission status: $cameraPermissionStatus'),
            ),
            const SizedBox(height: 15),
            FutureBuilder(
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CameraPreview(controller),
                  );
                }
                return const CircularProgressIndicator();
              },
              future: _initializeControllerFuture,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('camera_permission_button'),
        onPressed: () async {},
        tooltip: 'Camera',
        child: const Icon(Icons.camera),
      ),
    );
  }
}
