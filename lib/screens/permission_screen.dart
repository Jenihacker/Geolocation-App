import 'dart:ui';
import 'package:geolocation_app/main.dart';
import 'package:geolocation_app/provider/camera_provider.dart';
import 'package:geolocation_app/provider/location_provider.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  bool isCameraGranted = false;
  bool isMicGranted = false;
  bool isLocationGranted = false;

  @override
  void initState() {
    super.initState();
    checkAccess();
  }

  Future<void> checkAccess() async {
    if (await Permission.camera.isGranted) {
      setState(() {
        isCameraGranted = true;
      });
    }
    if (await Permission.microphone.isGranted) {
      setState(() {
        isMicGranted = true;
      });
    }
    if (await Permission.location.isGranted) {
      setState(() {
        isLocationGranted = true;
      });
    }
  }

  Future<bool> allPermited() async {
    if (await Permission.camera.isGranted &&
        await Permission.microphone.isGranted &&
        await Permission.location.isGranted) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0XFF0f2027), Color(0XFF203a43), Color(0XFF2c5364)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              SizedBox(
                height: 380,
                child: LottieBuilder.asset(
                    'assets/lottie/Animation - 1699532912956.json'),
              ),
              const Text(
                'Important!',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Please allow the following permissions:',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Consumer<CameraProvider>(
                    builder: (context, cameraProvider, child) {
                  return Consumer<LocationProvider>(
                      builder: (context, locationProvider, locChild) {
                    return ListView(
                      children: [
                        ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.4),
                                    Colors.black.withOpacity(0.4),
                                  ],
                                  begin: AlignmentDirectional.topStart,
                                  end: AlignmentDirectional.bottomEnd,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                  width: 1,
                                  color: Colors.white,
                                ),
                              ),
                              child: ListTile(
                                leading: SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: LottieBuilder.asset(
                                      'assets/lottie/Animation - 1699529641518.json'),
                                ),
                                title: const Text(
                                  'Camera',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                subtitle: const Text(
                                  'App needs permission for accessing camera to capture photo',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                                trailing: CupertinoSwitch(
                                  value: isCameraGranted,
                                  onChanged: (value) async {
                                    if (await Permission.camera
                                        .request()
                                        .isGranted) {
                                      setState(() {
                                        isCameraGranted = true;
                                      });
                                      if (isCameraGranted && isMicGranted) {
                                        await cameraProvider.initializeCamera();
                                      }
                                    } else if (await Permission
                                            .camera.status.isDenied ||
                                        await Permission.camera.status
                                            .isPermanentlyDenied) {
                                      openAppSettings();
                                    }
                                    if (await allPermited()) {
                                      Get.off(() => const HomeScreen());
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.4),
                                    Colors.black.withOpacity(0.4),
                                  ],
                                  begin: AlignmentDirectional.topStart,
                                  end: AlignmentDirectional.bottomEnd,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                  width: 1,
                                  color: Colors.white,
                                ),
                              ),
                              child: ListTile(
                                leading: SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: Center(
                                    child: LottieBuilder.asset(
                                        'assets/lottie/Animation - 1699530313468.json'),
                                  ),
                                ),
                                title: const Text(
                                  'Microphone',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                subtitle: const Text(
                                  'App needs permission for accessing microphone to record audio',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                                trailing: CupertinoSwitch(
                                  value: isMicGranted,
                                  onChanged: (value) async {
                                    if (await Permission.microphone
                                        .request()
                                        .isGranted) {
                                      setState(() {
                                        isMicGranted = true;
                                      });
                                      if (isCameraGranted && isMicGranted) {
                                        await cameraProvider.initializeCamera();
                                      }
                                    } else if (await Permission
                                            .microphone.status.isDenied ||
                                        await Permission.microphone.status
                                            .isPermanentlyDenied) {
                                      openAppSettings();
                                    }
                                    if (await allPermited()) {
                                      Get.off(() => const HomeScreen());
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.4),
                                    Colors.black.withOpacity(0.4),
                                  ],
                                  begin: AlignmentDirectional.topStart,
                                  end: AlignmentDirectional.bottomEnd,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                  width: 1,
                                  color: Colors.white,
                                ),
                              ),
                              child: ListTile(
                                leading: SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: LottieBuilder.asset(
                                      'assets/lottie/Animation - 1699530484545.json'),
                                ),
                                title: const Text(
                                  'Location',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                subtitle: const Text(
                                  'App needs permission for accessing location to display map coordinates',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                                trailing: CupertinoSwitch(
                                  value: isLocationGranted,
                                  onChanged: (value) async {
                                    if (await Permission.location
                                        .request()
                                        .isGranted) {
                                      await locationProvider
                                          .initializeLocation();
                                      setState(() {
                                        isLocationGranted = true;
                                      });
                                    } else if (await Permission
                                            .location.status.isDenied ||
                                        await Permission.location.status
                                            .isPermanentlyDenied) {
                                      openAppSettings();
                                    }
                                    if (await allPermited()) {
                                      Get.off(() => const HomeScreen());
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  });
                }),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
