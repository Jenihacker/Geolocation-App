import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocation_app/main.dart';
import 'package:geolocation_app/permission_screen.dart';
import 'package:geolocation_app/provider/camera_provider.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isAllowed = false;

  @override
  void initState() {
    super.initState();
    checkAccess();
    if (isAllowed) {
      
    }
    Timer(const Duration(milliseconds: 2500), () {
      isAllowed ? Get.to(const HomeScreen()) : Get.to(const PermissionScreen());
    });
  }

  Future<void> checkAccess() async {
    if (await Permission.camera.isGranted &&
        await Permission.microphone.isGranted &&
        await Permission.location.isGranted) {
      isAllowed = true;
      print(true);
      // ignore: use_build_context_synchronously
      await Provider.of<CameraProvider>(context, listen: false).initializeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF242424),
      body: Center(
        child: Image.asset('assets/app logo.png'),
      ),
    );
  }
}
