// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocation_app/main.dart';
import 'package:geolocation_app/screens/permission_screen.dart';
import 'package:geolocation_app/provider/camera_provider.dart';
import 'package:geolocation_app/provider/location_provider.dart';
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
    Timer(const Duration(milliseconds: 1500), () {
      isAllowed ? Get.off(() => const HomeScreen()) : Get.off(() => const PermissionScreen());
    });
  }

  Future<void> checkAccess() async {
    if (await Permission.camera.isGranted &&
        await Permission.microphone.isGranted &&
        await Permission.location.isGranted) {
      isAllowed = true;
      await Provider.of<CameraProvider>(context, listen: false).initializeCamera();
      await Provider.of<LocationProvider>(context, listen: false).initializeLocation();
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
