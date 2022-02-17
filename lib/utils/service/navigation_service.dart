import 'package:RentMyStay_user/home_module/viewModel/home_viewModel.dart';

import 'package:RentMyStay_user/login_module/view/login_page.dart';
import 'package:RentMyStay_user/login_module/view/success_page.dart';
import 'package:RentMyStay_user/login_module/viewModel/login_viewModel.dart';
import 'package:RentMyStay_user/property_module/view/property_listing_page.dart';
import 'package:RentMyStay_user/property_module/viewModel/property_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../home_module/view/home_page.dart';
import '../../login_module/view/mob_otp.dart';
import '../../login_module/view/mob_register_login.dart';
import '../../login_module/view/registration_page.dart';

class NavigationService {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.loginPage:
        return MaterialPageRoute(
          builder: (context) => LoginPage(),
        );
      case AppRoutes.homePage:
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => HomeViewModel(),
            child: HomePage(),
          ),
        );
      case AppRoutes.registrationPage:
        return MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                  create: (_) => LoginViewModel(),
                  child: RegistrationPage(),
                ));
      case AppRoutes.forgotPassword:
        return MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                  create: (_) => LoginViewModel(),
                  child: ForgotPasswordPage(),
                ));

      case AppRoutes.mob_register_login:
        return MaterialPageRoute(builder: (context) => mob_register_login());
      case AppRoutes.mob_register_login_otp:
        final data = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => MobileOtpPage(number: data['mobile']));

      case AppRoutes.successPage:
        return MaterialPageRoute(builder: (context) => SuccessPage());
      case AppRoutes.propertyListingPage:
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => PropertyViewModel(),
            child: PropertyListingPage(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Text('Hii'),
          ),
        );
    }
  }
}

class AppRoutes {
  static const String loginPage = 'loginPage';
  static const String homePage = 'homePage';
  static const String registrationPage = 'registrationPage';
  static const String propertyListingPage = 'propertyListingPage';
  static const String forgotPassword = 'forgotPassword';
  static const String successPage = 'successPage';
  static const String mob_register_login = 'mob_register_login';
  static const String mob_register_login_otp = 'mob_register_login_otp';
}
