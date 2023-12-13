import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class DisplayPictureScreen extends StatelessWidget {
  final Uint8List imagePath;
  const DisplayPictureScreen(
      {super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Stack(
        children: [
          SizedBox(
            child: Image.memory(imagePath),
          ),
        ],
      ),
    );
  }
}
