import 'dart:io' show Platform;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



import 'login_module/view/splash_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp firebaseApp= await Firebase.initializeApp(
    name: 'rentmystay_user',
    options: Platform.isMacOS || Platform.isIOS ?
        const FirebaseOptions(appId: 'IOS KEY',
        apiKey: 'AIzaSyCE-KLe5oa_Gcou-WQHiTeqHpw1RV1-Ouo',
        projectId: 'rentmystay-new-1539065190327',
        messagingSenderId: '172037116875',
        databaseURL: 'https://rentmystay-new-1539065190327.firebaseio.com'
        )
        :
      const FirebaseOptions(appId: '1:172037116875:android:87e0896da0f7cb1434dc4e',
          apiKey: 'AIzaSyCE-KLe5oa_Gcou-WQHiTeqHpw1RV1-Ouo',
          projectId: 'rentmystay-new-1539065190327',
          messagingSenderId: '172037116875',
          databaseURL: 'https://rentmystay-new-1539065190327.firebaseio.com'
      )
  );
  var app;
  runApp(ProviderScope(child: MyApp(app: app)));
}

class MyApp extends StatelessWidget {
  FirebaseApp ?app;
  MyApp({this.app});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Design',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashPage(),
    );
  }
}