import 'dart:developer';
import 'dart:io' show Platform;
import 'package:RentMyStay_user/theme/custom_theme.dart';
import 'package:RentMyStay_user/utils/service/bottom_navigation_provider.dart';
import 'package:RentMyStay_user/utils/service/location_service.dart';
import 'package:RentMyStay_user/utils/service/navigation_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'login_module/view/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp firebaseApp = await Firebase.initializeApp(
      name: 'rentmystay_user',
      options: Platform.isMacOS || Platform.isIOS
          ? const FirebaseOptions(
              appId: '1:172037116875:ios:742a1cb9248d4eb634dc4e',
              apiKey: 'AIzaSyCE-KLe5oa_Gcou-WQHiTeqHpw1RV1-Ouo',
              projectId: 'rentmystay-new-1539065190327',
              messagingSenderId: '172037116875',
              databaseURL:
                  'https://rentmystay-new-1539065190327.firebaseio.com')
          : const FirebaseOptions(
              appId: '1:172037116875:android:87e0896da0f7cb1434dc4e',
              apiKey: 'AIzaSyCE-KLe5oa_Gcou-WQHiTeqHpw1RV1-Ouo',
              projectId: 'rentmystay-new-1539065190327',
              messagingSenderId: '172037116875',
              databaseURL:
                  'https://rentmystay-new-1539065190327.firebaseio.com'));
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
    statusBarColor: CustomTheme.appTheme,
    statusBarIconBrightness: Brightness.dark

  ));

  runApp(MyApp());

}

class MyApp extends StatelessWidget {
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
        theme: ThemeData(
          primarySwatch: Colors.red,
          fontFamily: 'hk-grotest',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashPage(),
        onGenerateRoute: NavigationService.generateRoute,
      ),
    );
  }
}
