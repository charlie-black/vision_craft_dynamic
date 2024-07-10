import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsUtil {
  final _sharedPref = CommonSharedPref();
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  requestFirebasePermission() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    } catch (e) {
      AppLogger.appLogD(tag: "FIREBASE PERMISSIONS CHECK ERROR", message: e);
    }
  }

  getFirebaseToken() async {
    String? deviceFirebaseToken = await _sharedPref.getFirebaseToken();
    deviceFirebaseToken ??= await FirebaseMessaging.instance.getToken();
    AppLogger.appLogD(
        tag: "FIREBASE DEVICE TOKEN", message: deviceFirebaseToken);
    await _sharedPref.addFirebaseToken(deviceFirebaseToken);
  }

  late AndroidNotificationChannel channel;
  bool isFlutterLocalNotificationsInitialized = false;

  Future<void> setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.max,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    isFlutterLocalNotificationsInitialized = true;
  }

  void firebaseMessagingForegroundHandler() async {
    FirebaseMessaging.onMessage.listen(showFlutterNotificationOnApp);
  }

  void showFlutterNotificationOnApp(RemoteMessage message) {
    AppLogger.appLogD(tag: "firebase_util", message: message.data);
    RemoteNotification? notification = message.notification;
    String? image = message.data["image"];

    AndroidNotification? android = message.notification?.android;
    String? bigImage = message.data['bigimageurl'];
    // var image = loadImageFromUrl(bigImage ?? "");

    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            priority: Priority.high,
            playSound: true,
            icon: 'drawable/vision_logo',
            // largeIcon: image
          ),
        ),
      );
      if (notification.title != "" && notification.body != "") {}
    }
  }

  loadImageFromUrl(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      final Uint8List uint8List = response.bodyBytes;
      final img.Image? image = img.decodeImage(uint8List);

      return image;
    } else {
      throw Exception('Failed to load image from the URL');
    }
  }

  // saveNotificationToLocalDB(AppNotification appNotification) async {
  //   try {
  //     AppLogger.appLogD(
  //         tag: "saving notification", message: appNotification.body);
  //     await _notificationsRepo.insertNotification(appNotification);
  //     appNotifications.add(appNotification);
  //   } catch (e) {
  //     AppLogger.appLogD(tag: "firebase_util", message: e);
  //   }
  // }
}

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBiuRfZYOnBLz-bfj92u8Yv5L5OnnwrBXI',
    appId: '1:751692631542:android:a980018fea1c74b3f40bd7',
    messagingSenderId: '751692631542',
    projectId: 'tsedey-mobile-banking',
    storageBucket: 'tsedey-mobile-banking.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCJavTQ4990XVN99Bim0_opqG7HWPMClw4',
    appId: '1:891142291983:ios:1b1d264fa84440780e197a',
    messagingSenderId: '891142291983',
    projectId: 'visionfund-12b70',
    storageBucket: 'visionfund-12b70.appspot.com',
    iosBundleId: 'com.visionfundios.app',
  );
}
