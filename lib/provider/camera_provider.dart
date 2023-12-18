import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

class CameraProvider extends ChangeNotifier {
  CameraController? controller;
  late List<CameraDescription> cameras;
  bool flashlight = false;
  ScreenshotController screenshotcontroller = ScreenshotController();
  Uint8List? recentImage;

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.high,
        imageFormatGroup: ImageFormatGroup.jpeg);
    controller!.initialize().then((_) {
      notifyListeners();
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
    notifyListeners();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  Future takePicture() async {
    if (!controller!.value.isInitialized) {
      return null;
    }
    if (controller!.value.isTakingPicture) {
      return null;
    }

    try {
      // await controller.setFlashMode(FlashMode.off);
      screenshotcontroller.capture().then((
        value,
      ) async {
        recentImage = value;
        notifyListeners();
        final String dir = (await getApplicationDocumentsDirectory()).path;
        final String fullPath = '$dir/${DateTime.now().millisecond}.jpg';
        File capturedFile = File(fullPath);
        await capturedFile.writeAsBytes(value!.buffer.asUint8List());
        await GallerySaver.saveImage(capturedFile.path).then((value) {});
      });
      notifyListeners();
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      notifyListeners();
      return null;
    }
  }
}
