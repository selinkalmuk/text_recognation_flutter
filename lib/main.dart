import 'dart:io';
import 'package:flutter/material.dart';
import 'package:final_project_summer/myiconbuttons.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scan The Plate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Scan The Plate'),
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
  // Get image from the photo gallery or camera
  final ImagePicker picker = ImagePicker();
  bool textScanning = false;
  File? _image;
  String scannedText = "";

  //Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    //picked an image from gallery
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        textScanning = true;
        _image = File(pickedFile.path);
        getRecognizer(pickedFile);
      } else {
        scannedText = 'No image picked.';
      }
    });
  }

  Future getImageFromCamera() async {
    //picked an image from camera
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        textScanning = true;
        _image = File(pickedFile.path);
        getRecognizer(pickedFile);
      } else {
        scannedText = 'No image picked.';
      }
    });
  }

  Future<void> getRecognizer(XFile img) async {
    final inputImage = InputImage.fromFilePath(img.path);
    final textRecognizer = TextRecognizer();
    try {
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);
      setState(() {
        scannedText = recognizedText.text;
        textScanning = false;
      });
    } catch (e) {
      setState(() {
        scannedText = 'Failed to recognize text: $e';
        textScanning = false;
      });
    } finally {
      textRecognizer.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0, // Remove shadow under the app bar for a cleaner look
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:
              CrossAxisAlignment.center, // Center content horizontally
          children: <Widget>[
            if (textScanning)
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
              ),
            const SizedBox(height: 20),
            if (_image != null)
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal, width: 2),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _image!,
                    fit: BoxFit.cover, // Ensure the image covers the container
                  ),
                ),
              )
            else
              const Text(
                'No image selected',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            const SizedBox(height: 24), // Add some space before the buttons
            MyIconButton(
              buttonText: "Open Camera",
              buttonIcon: Icons.camera_alt_outlined,
              buttonTapped: () {
                getImageFromCamera();
              },
            ),
            const SizedBox(height: 16.0),
            MyIconButton(
              buttonText: "Open Gallery",
              buttonIcon: Icons.photo_library_outlined,
              buttonTapped: () {
                getImageFromGallery();
              },
            ),
            const SizedBox(height: 24.0),
            if (scannedText.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  scannedText,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
