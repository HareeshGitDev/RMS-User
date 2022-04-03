import 'package:RentMyStay_user/home_module/view/dashboard_page.dart';
import 'package:RentMyStay_user/home_module/view/refer_earn_page.dart';
import 'package:RentMyStay_user/home_module/viewModel/home_viewModel.dart';

import 'package:RentMyStay_user/login_module/view/login_page.dart';
import 'package:RentMyStay_user/login_module/view/firebase_registration_page.dart';
import 'package:RentMyStay_user/login_module/view/success_page.dart';
import 'package:RentMyStay_user/login_module/viewModel/login_viewModel.dart';
import 'package:RentMyStay_user/my_stays/model/ticket_response_model.dart';
import 'package:RentMyStay_user/my_stays/view/generate_ticket_page.dart';
import 'package:RentMyStay_user/my_stays/view/refund_splitup_view_page.dart';
import 'package:RentMyStay_user/my_stays/view/ticket_details_page.dart';
import 'package:RentMyStay_user/my_stays/view/ticket_list_page.dart';
import 'package:RentMyStay_user/my_stays/viewmodel/mystay_viewmodel.dart';
import 'package:RentMyStay_user/payment_module/model/payment_request_model.dart';
import 'package:RentMyStay_user/payment_module/view/razorpay_payement_page.dart';
import 'package:RentMyStay_user/payment_module/viewModel/payment_viewModel.dart';
import 'package:RentMyStay_user/property_details_module/model/property_details_util_model.dart';
import 'package:RentMyStay_user/property_details_module/view/property_details_page.dart';
import 'package:RentMyStay_user/property_details_module/viewModel/property_details_viewModel.dart';
import 'package:RentMyStay_user/property_module/view/property_listing_page.dart';
import 'package:RentMyStay_user/property_module/view/wish_list_page.dart';
import 'package:RentMyStay_user/property_module/viewModel/property_viewModel.dart';
import 'package:RentMyStay_user/utils/service/picture_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../my_stays/view/update_Invoice_UTR.dart';
import '../../property_details_module/view/booking_view_page.dart';
import '../../home_module/view/home_page.dart';
import '../../login_module/view/forgot_password_page.dart';
import '../../login_module/view/mobile_otp_page.dart';
import '../../login_module/view/registration_page.dart';
import '../../my_stays/view/feedback_form_view_page.dart';
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
      case AppRoutes.pictureScreenPage:
        return MaterialPageRoute(
            builder: (_) =>
                PictureScreen(camera: settings.arguments as CameraDescription));
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
        return MaterialPageRoute(
            builder: (context) => PaymentStatusPage(
                  status: data['status'],
                  title: data['title'],
                  amount: data['amount'],
                  paymentId: data['paymentId'],
                ));

      case AppRoutes.myStayDetailsPage:
        String bookingId = settings.arguments as String;
        return MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                  create: (_) => MyStayViewModel(),
                  child: MyStayDetailsPage(bookingId: bookingId),
                ));
      case AppRoutes.generateTicketPage:
        final data = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                  create: (_) => MyStayViewModel(),
                  child: GenerateTicketPage(
                    bookingId: data['bookingId'],
                    propertyId: data['propertyId'],
                    address: data['address'],
                  ),
                ));

      case AppRoutes.ticketListPage:
        //String bookingId = settings.arguments as String;
        return MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                  create: (_) => MyStayViewModel(),
                  child: TicketListPage(),
                ));
      case AppRoutes.ticketDetailsPage:
        final data = settings.arguments as Data;
        return MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                  create: (_) => MyStayViewModel(),
                  child: TicketDetailsPage(ticketModel: data),
                ));

      case AppRoutes.invoicePage:
        final data = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                  create: (_) => MyStayViewModel(),
                  child: InvoicePage(
                    bookingId: data['bookingId'],
                    propertyId: data['propertyId'],
                    name: data['name'],
                    email: data['email'],
                    mobile: data['mobile'],
                    address: data['address'],
                  ),
                ));

      case AppRoutes.updateInvoiceUTRPage:
        final data = settings.arguments as Map<String,dynamic>;
        return MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                  create: (_) => MyStayViewModel(),
                  child: UpdateInvoiceUTRPage(
                    bookingId: data['bookingId'],
                    invoiceId:  data['invoiceId'],
                  ),
                ));

      case AppRoutes.refundSplitPage:
        final data = settings.arguments as String;
        return MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                  create: (_) => MyStayViewModel(),
                  child: RefundSplitPage(
                    bookingId: data,
                  ),
                ));

      case AppRoutes.refundFormPage:
        final data = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => MyStayViewModel(),
            child: FeedbackPage(
              bookingId: data['bookingId'],
              title: data['title'],
              email: data['email'],
              name: data['name'],
            ),
          ),
        );

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
        final data = settings.arguments as Map<String, dynamic>;
        bool fromBottom = data['fromBottom'];
        return MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                  create: (_) => ProfileViewModel(),
                  child: ProfilePage(fromBottom: fromBottom),
                ));

      case AppRoutes.editProfilePage:
        return MaterialPageRoute(builder: (context) => EditProfile());

      case AppRoutes.myStayListPage:
        final data = settings.arguments as Map<String, dynamic>;
        bool fromBottom = data['fromBottom'];
        return MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                  create: (_) => MyStayViewModel(),
                  child: MyStayListPage(fromBottom: fromBottom),
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
        final data = settings.arguments as Map<String, dynamic>;
        bool fromBottom = data['fromBottom'];
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
              create: (_) => PropertyViewModel(),
              child: WishListPage(
                fromBottom: fromBottom,
              )),
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
        final data = settings.arguments as Map<String, dynamic>;
        bool fromBottom = data['fromBottom'];
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
              create: (_) => PropertyViewModel(),
              child: SearchPage(
                fromBottom: fromBottom,
              )),
        );
      case AppRoutes.dashboardPage:
        return MaterialPageRoute(
          builder: (context) => const DashboardPage(),
        );
      case AppRoutes.razorpayPaymentPage:
        final data = settings.arguments as PaymentRequestModel;
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
              create: (_) => PaymentViewModel(),
              child: RazorpayPaymentPage(paymentRequestModel: data)),
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
  static const String myStayDetailsPage = 'myStayDetailsPage';
  static const String invoicePage = 'InvoicePage';
  static const String updateInvoiceUTRPage = 'UpdateInvoiceUTR';
  static const String refundSplitPage = 'refundSplitPage';
  static const String refundFormPage = 'refundForPage';
  static const String dashboardPage = 'dashboardPage';
  static const String pictureScreenPage = 'pictureScreenPage';
  static const String generateTicketPage = 'generateTicketPage';
  static const String ticketListPage = 'ticketListPage';
  static const String ticketDetailsPage = 'ticketDetailsPage';
  static const String razorpayPaymentPage = 'razorpayPaymentPage';
}
