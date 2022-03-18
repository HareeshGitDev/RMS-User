import 'package:RentMyStay_user/home_module/view/refer_earn_page.dart';
import 'package:RentMyStay_user/home_module/viewModel/home_viewModel.dart';

import 'package:RentMyStay_user/login_module/view/login_page.dart';
import 'package:RentMyStay_user/login_module/view/firebase_registration_page.dart';
import 'package:RentMyStay_user/login_module/view/success_page.dart';
import 'package:RentMyStay_user/login_module/viewModel/login_viewModel.dart';
import 'package:RentMyStay_user/my_stays/view/refund_splitup_view_page.dart';
import 'package:RentMyStay_user/my_stays/viewmodel/mystay_viewmodel.dart';
import 'package:RentMyStay_user/property_details_module/model/property_details_util_model.dart';
import 'package:RentMyStay_user/property_details_module/view/property_details_page.dart';
import 'package:RentMyStay_user/property_details_module/viewModel/property_details_viewModel.dart';
import 'package:RentMyStay_user/property_module/view/property_listing_page.dart';
import 'package:RentMyStay_user/property_module/view/wish_list_page.dart';
import 'package:RentMyStay_user/property_module/viewModel/property_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../booking_module/view/booking_view_page.dart';
import '../../home_module/view/home_page.dart';
import '../../login_module/view/forgot_password_page.dart';
import '../../login_module/view/mobile_otp_page.dart';
import '../../login_module/view/registration_page.dart';
import '../../my_stays/view/feedback_form_viewPage.dart';
import '../../my_stays/view/invoices_view_page.dart';
import '../../my_stays/view/mystay_details_page.dart';
import '../../my_stays/view/mystay_listing_page.dart';
import '../../profile_Module/view/Edit_profile.dart';
import '../../profile_Module/view/profile_page.dart';
import '../../profile_Module/viewmodel/profile_view_model.dart';
import '../../property_module/view/search_page.dart';

class NavigationService {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.loginPage:
        return MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                  create: (_) => LoginViewModel(),
                  child: LoginPage(),
                ));
      case AppRoutes.homePage:
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => HomeViewModel(),
            child: HomePage(),
          ),
        );

      case AppRoutes.referAndEarn:
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => HomeViewModel(),
            child: ReferAndEarn(),
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

      case AppRoutes.otpVerifyPage:
        final data = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                  create: (_) => LoginViewModel(),
                  child: MobileOtpPage(number: data['mobile']),
                ));

      case AppRoutes.firebaseRegistrationPage:
        final data = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                  create: (_) => LoginViewModel(),
                  child: FirebaseRegistrationPage(
                      googleData: data['gmailData'],
                      from: data['from'],
                      uid: data['uid'],
                      mobile: data['mobile']),
                ));

      case AppRoutes.paymentStatusPage:
        final data = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (context) => PaymentStatusPage(
          status: data['status'],
          title: data['title'],
          buildingName: data['buildingName'],
          amount: data['amount'],
          paymentId: data['paymentId'],

        ));

      case AppRoutes.myStayDetailsPage:
        return MaterialPageRoute(builder: (context) => MyStayPage());

      case AppRoutes.invoicePage:
        return MaterialPageRoute(builder: (context) => InvoicePage());

      case AppRoutes.refundSplitPage:
        return MaterialPageRoute(builder: (context) => RefundSplitPage());

      case AppRoutes.refundForm:
        return MaterialPageRoute(builder: (context) => FeedbackPage());

      case AppRoutes.bookingPage:
        final data = settings.arguments as PropertyDetailsUtilModel;
        return MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                  create: (_) => PropertyDetailsViewModel(),
                  child: BookingPage(
                    propertyDetailsUtilModel: data,
                  ),
                ));

      case AppRoutes.profilePage:
        return MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                  create: (_) => ProfileViewModel(),
                  child: Profile(),
                ));

      case AppRoutes.editProfilePage:
        return MaterialPageRoute(builder: (context) => EditProfile());

      case AppRoutes.myStayListPage:
        return MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                  create: (_) => MyStayViewModel(),
                  child: MyStayListPage(),
                ));

      case AppRoutes.propertyListingPage:
        final data = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => PropertyViewModel(),
            child: PropertyListingPage(
              locationName: data['location'],
              propertyType: data['propertyType'],
              property: data['property'],
              checkInDate: data['checkInDate'],
              checkOutDate: data['checkOutDate'],
            ),
          ),
        );

      case AppRoutes.wishListPage:
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
              create: (_) => PropertyViewModel(), child: WishListPage()),
        );
      case AppRoutes.propertyDetailsPage:
        String propId = settings.arguments as String;

        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
              create: (_) => PropertyDetailsViewModel(),
              child: PropertyDetailsPage(
                propId: propId,
              )),
        );
      case AppRoutes.searchPage:
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
              create: (_) => PropertyViewModel(), child: SearchPage()),
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
  static const String profilePage = 'profile';
  static const String editProfilePage = 'editProfilePage';
  static const String referAndEarn = 'referAndEarnPage';
  static const String registrationPage = 'registrationPage';
  static const String propertyListingPage = 'propertyListingPage';
  static const String forgotPassword = 'forgotPassword';
  static const String paymentStatusPage = 'paymentStatusPage';
  static const String bookingPage = 'bookingPage';
  static const String otpVerifyPage = 'otpVerifyPage';
  static const String firebaseRegistrationPage = 'firebaseRegistrationPage';
  static const String wishListPage = 'wishListPage';
  static const String propertyDetailsPage = 'propertyDetailsPage';
  static const String myStayListPage = 'myStayListPage';
  static const String searchPage = 'searchPage';
  static const String myStayDetailsPage = 'myStay_details_page';
  static const String invoicePage = 'Invoice_page';
  static const String refundSplitPage = 'refund_splitup_page';
  static const String refundForm = 'refund_form_page';
}
