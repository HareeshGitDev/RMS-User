import 'dart:developer';
import 'dart:io' show Platform;
import 'package:RentMyStay_user/theme/custom_theme.dart';
import 'package:RentMyStay_user/utils/service/bottom_navigation_provider.dart';
import 'package:RentMyStay_user/utils/service/deep_linking_service.dart';
import 'package:RentMyStay_user/utils/service/location_service.dart';
import 'package:RentMyStay_user/utils/service/locator_service.dart';
import 'package:RentMyStay_user/utils/service/navigation_service.dart';
import 'package:RentMyStay_user/utils/service/navigator_key_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'login_module/view/splash_page.dart';

import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;
//import 'firebase_options.dart';

Future<void> _onFirebaseMessage(RemoteMessage message) async {
  log('${message.data['name']}--FOREGROUND-- ${message.data['id']}');
}

Future<void> _onFirebaseBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('${message.data['name']}--BACKGROUND-- ${message.data['id']}');
}

Future<void> _onFirebaseOpenedMessage(RemoteMessage message) async {
  log('${message.data['name']}--OPENED-- ${message.data['id']}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp();
  lateInitializeServices();
  lazySingletonInstance<DeepLinkingService>().initDynamicLinks();
  configuration();
  runApp(MyApp());
}

void configuration() async {
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
  log('User granted permission: ${settings.authorizationStatus}');
  FirebaseMessaging.onMessage.listen(_onFirebaseMessage);

  FirebaseMessaging.onMessageOpenedApp.listen(_onFirebaseOpenedMessage);

  FirebaseMessaging.onBackgroundMessage(_onFirebaseBackgroundMessage);
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> initUniLinks() async {
    try {
      final String? initialLink = await getInitialLink();
      final Uri? uri = await getInitialUri();
      if (uri != null) {
        log('URI :: ${uri.host}');
      }
      if (initialLink != null) {
        log("LINK :: " + initialLink.toString());
        lazySingletonInstance<NavigatorKeyService>().navigateTo(
            routeName: AppRoutes.propertyDetailsPage, data: {

        });

      }
    } on PlatformException {
      log('Platform Exception Happened');
    }
  }

  @override
  void initState() {
    //   initUniLinks();
    terminatedMessage();
    super.initState();
  }

  Future<void> terminatedMessage() async {
    await Firebase.initializeApp();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    RemoteMessage? message = await messaging.getInitialMessage();
    if (message != null) {
      log('${message.data['name']}--FROM TERMINATED STATE-- ${message.data['id']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BottomNavigationProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'RentMyStay ',
        navigatorKey: lazySingletonInstance<NavigatorKeyService>().navigatorKey,
        theme: ThemeData(
          primarySwatch: customColor,
          fontFamily: 'hk-grotest',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashPage(),
        onGenerateRoute: NavigationService.generateRoute,
      ),
    );
  }
}

Map<int, Color> colorMap = const {
  50: Color.fromRGBO(51, 101, 138, .1),
  100: Color.fromRGBO(51, 101, 138, .2),
  200: Color.fromRGBO(51, 101, 138, .3),
  300: Color.fromRGBO(51, 101, 138, .4),
  400: Color.fromRGBO(51, 101, 138, .5),
  500: Color.fromRGBO(51, 101, 138, .6),
  600: Color.fromRGBO(51, 101, 138, .7),
  700: Color.fromRGBO(51, 101, 138, .8),
  800: Color.fromRGBO(51, 101, 138, .9),
  900: Color.fromRGBO(51, 101, 138, 1),
};
// Green color code: 93cd48 and first two characters (FF) are alpha values (transparency)
MaterialColor customColor = MaterialColor(0xff33658a, colorMap);

void _portraitModeOnly() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
