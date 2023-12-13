import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';

class CameraProvider extends ChangeNotifier {
  CameraController? controller;
  late List<CameraDescription> cameras;
  bool flashlight = false;
  late ScreenshotController screenshotcontroller;
  Uint8List? recentImage;
  
  Future<void> initializeCamera() async{
    cameras = await availableCameras();
    screenshotcontroller = ScreenshotController();
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
      screenshotcontroller.capture().then((value,) {
        ImageGallerySaver.saveImage(value!);
        recentImage = value;
      });
      notifyListeners();
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      notifyListeners();
      return null;
    }
  }
  
}