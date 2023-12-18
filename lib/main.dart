import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_menu/expandable_menu.dart';
import 'package:flutter/services.dart';
import 'package:geolocation_app/provider/camera_provider.dart';
import 'package:geolocation_app/provider/location_provider.dart';
import 'package:get/get.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocation_app/api_keys.dart';
import 'package:geolocation_app/screens/splash_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

late LocationSettings locationSettings;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CameraProvider()),
        ChangeNotifierProvider(create: (context) => LocationProvider())
      ],
      child: GetMaterialApp(
        title: "Geolocation SJEC",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            iconTheme: const IconThemeData(color: Colors.white),
            textTheme: const TextTheme(
                bodySmall: TextStyle(color: Colors.white),
                bodyMedium: TextStyle(color: Colors.white))),
        home: const SplashScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool flashlight = false;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void launchGallery() async {
    const String url = 'photos-redirect://';
    if (Platform.isIOS) {
      if (!await launchUrl(Uri.parse(url))) {
        throw Exception("Couldn't Launch Url");
      }
    } else if (Platform.isAndroid) {
      const intent = AndroidIntent(
        action: 'action_view',
        type: 'image/*',
        flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      intent.launch();
    } else {
      throw Exception("Couldn't Launch Url");
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Consumer<CameraProvider>(
              builder: (context, cameraProvider, child) {
            return Consumer<LocationProvider>(
                builder: (context, locationProvider, locChild) {
              return Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 50,
                      decoration: const BoxDecoration(color: Colors.black),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: SizedBox(
                                height: 40,
                                width: 40,
                                child: ExpandableMenu(
                                    height: 40,
                                    width: 40,
                                    items: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.flash_auto),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.flash_on),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.flashlight_on),
                                      )
                                    ]),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: GestureDetector(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Clicked Menu')));
                                },
                                child: const Icon(
                                  Icons.menu,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ]),
                    ),
                  ),
                  Positioned.fill(
                    top: 50,
                    //bottom: 0,
                    child: AspectRatio(
                      aspectRatio: (cameraProvider.controller == null)
                          ? 720 / 1280
                          : cameraProvider.controller!.value.aspectRatio,
                      child: Screenshot(
                        controller: cameraProvider.screenshotcontroller,
                        child: cameraProvider.controller != null
                            ? CameraPreview(cameraProvider.controller!,
                                child: FutureBuilder(
                                  future: locationProvider.determinePosition(),
                                  builder: (context, snapshot) {
                                    return Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Container(
                                            height: 100,
                                            color: Colors.black54,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  child: Container(
                                                    height: 90,
                                                    width: 90,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 1.0,
                                                            color:
                                                                Colors.white)),
                                                    child: CachedNetworkImage(
                                                      useOldImageOnUrlChange:
                                                          true,
                                                      imageUrl:
                                                          'https://www.mapquestapi.com/staticmap/v5/map?key=${(ApiKeys.keys..shuffle()).first}&center=${locationProvider.place.latitude},${locationProvider.place.longitude}&zoom=19&type=sat',
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 2,
                                                ),
                                                Expanded(
                                                  child: ListView(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0),
                                                    children: [
                                                      FutureBuilder(
                                                        future: locationProvider
                                                            .getAddress(
                                                                locationProvider
                                                                    .place
                                                                    .latitude,
                                                                locationProvider
                                                                    .place
                                                                    .longitude),
                                                        builder: (context,
                                                            snapshot1) {
                                                          return Text(
                                                              '${locationProvider.placemark.name ?? "Unknown"}, ${locationProvider.placemark.subLocality ?? ""}, ${locationProvider.placemark.locality ?? ""}, ${locationProvider.placemark.administrativeArea ?? ""}',
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .fade,
                                                              style: const TextStyle(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold));
                                                        },
                                                      ),
                                                      Text(
                                                          'Lat: ${locationProvider.place.latitude}',
                                                          style: const TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Text(
                                                          'Long: ${locationProvider.place.longitude}',
                                                          style: const TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Text(
                                                          'Accuracy: ${locationProvider.place.accuracy}',
                                                          style: const TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Text(
                                                          '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} ${DateFormat.jm().format(DateTime.now())} ${DateTime.now().timeZoneName}',
                                                          style: const TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )));
                                    // return Text(
                                    //     '${snapshot.data!.latitude} ${snapshot.data!.longitude} ${snapshot.data!.accuracy}');
                                  },
                                ))
                            : Container(
                                color: Colors.black,
                              ),
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.16,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // const SizedBox(
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //     children: [
                              //       Chip(
                              //         label: Text('Video',
                              //             style: TextStyle(
                              //                 fontWeight: FontWeight.bold)),
                              //       ),
                              //       Chip(
                              //         label: Text('Photo',
                              //             style: TextStyle(
                              //                 fontWeight: FontWeight.bold)),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              SizedBox(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: GestureDetector(
                                        onTap: () => launchGallery(),
                                        child: cameraProvider.recentImage !=
                                                null
                                            ? Transform.scale(
                                                scale: 1.2,
                                                child: Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                      border: Border.all(
                                                          width: 1.5,
                                                          color: Colors.white),
                                                      image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: MemoryImage(
                                                              cameraProvider
                                                                  .recentImage!))),
                                                ),
                                              )
                                            : const Icon(
                                                Icons.image_rounded,
                                                size: 40,
                                              ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        cameraProvider.takePicture();
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100.0),
                                              border: Border.all(
                                                  style: BorderStyle.solid,
                                                  width: 3,
                                                  color: Colors.white)),
                                          child: const Icon(
                                            Icons.circle,
                                            size: 70,
                                          )),
                                    ),
                                    Center(
                                      child: GestureDetector(
                                        onTap: () async {
                                          if (cameraProvider.controller!
                                                  .description.lensDirection ==
                                              CameraLensDirection.front) {
                                            await cameraProvider.controller!
                                                .setDescription(
                                                    cameraProvider.cameras[0]);
                                          } else {
                                            await cameraProvider.controller!
                                                .setDescription(
                                                    cameraProvider.cameras[1]);
                                          }
                                        },
                                        child: const Icon(
                                          Icons.flip_camera_ios_outlined,
                                          size: 40,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
                ],
              );
            });
          });
        },
      ),
    ));
    // return SafeArea(
    //   child: Scaffold(
    //     appBar: AppBar(
    //       elevation: 0,
    //       backgroundColor: Colors.black,
    //       leading: IconButton(
    //           splashRadius: 1,
    //           onPressed: () async {
    //             setState(() {
    //               flashlight = !flashlight;
    //               flashlight
    //                   ? controller.setFlashMode(FlashMode.always)
    //                   : controller.setFlashMode(FlashMode.off);
    //             });
    //           },
    //           icon: Icon(flashlight ? Icons.flash_on : Icons.flash_off)),
    //       actions: const [
    //         Padding(
    //           padding: EdgeInsets.all(8.0),
    //           child: Icon(Icons.menu, size: 30),
    //         )
    //       ],
    //     ),
    //     //drawer: const Drawer(),
    //     backgroundColor: Colors.black,
    //     body: Column(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       children: [
    //         AspectRatio(
    //           aspectRatio: controller.value.previewSize!.height *
    //               1.05 /
    //               controller.value.previewSize!.width *
    //               1.05,
    //           child: CameraPreview(
    //             controller,
    //           ),
    //         ),
    //         Container(
    //           decoration: const BoxDecoration(
    //               gradient: LinearGradient(
    //                   colors: [Colors.black, Colors.black38],
    //                   begin: Alignment.topLeft,
    //                   end: Alignment.bottomRight)),
    //           padding: EdgeInsets.symmetric(
    //               vertical: MediaQuery.of(context).size.height * 0.01),
    //           child: Row(
    //               mainAxisSize: MainAxisSize.max,
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               mainAxisAlignment: MainAxisAlignment.spaceAround,
    //               children: [
    //                 ElevatedButton(
    //                     onPressed: () {
    //                       launchGallery();
    //                     },
    //                     style: const ButtonStyle(
    //                         backgroundColor:
    //                             MaterialStatePropertyAll(Colors.black38),
    //                         shape: MaterialStatePropertyAll(CircleBorder()),
    //                         padding:
    //                             MaterialStatePropertyAll(EdgeInsets.all(12.0))),
    //                     child: const Icon(
    //                       Icons.image,
    //                       color: Colors.white,
    //                     )),
    //                 ElevatedButton(
    //                     onPressed: () async {
    //                       takePicture();
    //                     },
    //                     style: ButtonStyle(
    //                         iconSize: const MaterialStatePropertyAll(35.0),
    //                         padding: const MaterialStatePropertyAll(
    //                             EdgeInsets.all(18.0)),
    //                         shape:
    //                             const MaterialStatePropertyAll(CircleBorder()),
    //                         backgroundColor: MaterialStatePropertyAll(
    //                             isSaving ? Colors.white54 : Colors.white)),
    //                     child: isSaving
    //                         ? Container(
    //                             padding: const EdgeInsets.all(5.0),
    //                             decoration: const BoxDecoration(
    //                                 color: Colors.transparent,
    //                                 shape: BoxShape.circle),
    //                             height: 35,
    //                             width: 35,
    //                             child: const SpinKitPouringHourGlass(
    //                                 size: 35, color: Colors.black))
    //                         : const Icon(
    //                             Icons.camera,
    //                             color: Colors.black,
    //                           )),
    //                 ElevatedButton(
    //                     style: const ButtonStyle(
    //                         backgroundColor:
    //                             MaterialStatePropertyAll(Colors.black38),
    //                         shape: MaterialStatePropertyAll(CircleBorder()),
    //                         padding:
    //                             MaterialStatePropertyAll(EdgeInsets.all(12.0))),
    //                     onPressed: () async {
    //                       if (controller.description.lensDirection ==
    //                           CameraLensDirection.front) {
    //                         await controller.setDescription(cameras[0]);
    //                       } else {
    //                         await controller.setDescription(cameras[1]);
    //                       }
    //                     },
    //                     child: const Icon(Icons.cameraswitch)),
    //               ]),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
