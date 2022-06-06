import 'dart:developer';

import 'package:RentMyStay_user/home_module/view/dashboard_page.dart';
import 'package:RentMyStay_user/home_module/view/refer_earn_page.dart';
import 'package:RentMyStay_user/home_module/viewModel/home_viewModel.dart';
import 'package:RentMyStay_user/language_module/view/language_screen.dart';
import 'package:RentMyStay_user/language_module/viewModel/language_viewModel.dart';
import 'package:RentMyStay_user/login_module/view/login_page.dart';
import 'package:RentMyStay_user/login_module/view/firebase_registration_page.dart';
import 'package:RentMyStay_user/login_module/view/payment_status_page.dart';
import 'package:RentMyStay_user/login_module/viewModel/login_viewModel.dart';
import 'package:RentMyStay_user/my_stays/model/ticket_response_model.dart';
import 'package:RentMyStay_user/my_stays/view/generate_ticket_page.dart';
import 'package:RentMyStay_user/my_stays/view/refund_splitup_view_page.dart';
import 'package:RentMyStay_user/my_stays/view/ticket_details_page.dart';
import 'package:RentMyStay_user/my_stays/view/ticket_list_page.dart';
import 'package:RentMyStay_user/my_stays/viewmodel/mystay_viewmodel.dart';
import 'package:RentMyStay_user/owner_property_module/view/property_description_page.dart';
import 'package:RentMyStay_user/owner_property_module/view/property_photos_page.dart';
import 'package:RentMyStay_user/owner_property_module/view/property_host_page.dart';
import 'package:RentMyStay_user/owner_property_module/view/owner_property_listing_page.dart';
import 'package:RentMyStay_user/owner_property_module/view/property_amenities_page.dart';
import 'package:RentMyStay_user/owner_property_module/view/property_rent_page.dart';
import 'package:RentMyStay_user/owner_property_module/view/property_rooms_beds_page.dart';
import 'package:RentMyStay_user/payment_module/model/payment_request_model.dart';
import 'package:RentMyStay_user/payment_module/view/razorpay_payement_page.dart';
import 'package:RentMyStay_user/payment_module/viewModel/payment_viewModel.dart';
import 'package:RentMyStay_user/property_details_module/model/property_details_util_model.dart';
import 'package:RentMyStay_user/property_details_module/view/property_details_page.dart';
import 'package:RentMyStay_user/property_details_module/view/property_gallery_view_page.dart';
import 'package:RentMyStay_user/property_details_module/viewModel/property_details_viewModel.dart';
import 'package:RentMyStay_user/property_module/view/property_listing_page.dart';
import 'package:RentMyStay_user/property_module/view/wish_list_page.dart';
import 'package:RentMyStay_user/property_module/viewModel/property_viewModel.dart';
import 'package:RentMyStay_user/utils/service/picture_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../my_stays/view/update_Invoice_UTR.dart';
import '../../owner_property_module/view/add_property_page.dart';
import '../../owner_property_module/view/owner_property_details_page.dart';
import '../../owner_property_module/view/property_location_page.dart';
import '../../owner_property_module/view/property_rules_page.dart';
import '../../owner_property_module/viewModel/owner_property_viewModel.dart';
import '../../property_details_module/view/booking_view_page.dart';
import '../../home_module/view/home_page.dart';
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
        final data = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                  create: (_) => LoginViewModel(),
                  child: LoginPage(
                    fromExternalLink: data['fromExternalLink'],
                    onClick: data['onClick'],
                  ),
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
      case AppRoutes.languageScreen:
        final data = settings.arguments as Map<String,dynamic>;
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => LanguageViewModel(),
            child: LanguageScreen(language:data['lang'],fromDashboard: data['fromDashboard']),
          ),
        );
      case AppRoutes.registrationPage:
        final data = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                  create: (_) => LoginViewModel(),
                  child: RegistrationPage(
                      fromExternalLink: data['fromExternalLink'],
                      onClick: data['onClick']),
                ));
      case AppRoutes.pictureScreenPage:
        return MaterialPageRoute(
            builder: (_) =>
                PictureScreen(camera: settings.arguments as CameraDescription));

      case AppRoutes.otpVerifyPage:
        final data = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                  create: (_) => LoginViewModel(),
                  child: MobileOtpPage(
                      number: data['mobile'],
                      fromExternalLink: data['fromExternalLink'],
                      onClick: data['onClick']),
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
                      mobile: data['mobile'],
                      fromExternalLink: data['fromExternalLink'],
                      onClick: data['onClick']),
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
        final data = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                  create: (_) => MyStayViewModel(),
                  child: UpdateInvoiceUTRPage(
                    bookingId: data['bookingId'],
                    invoiceId: data['invoiceId'],
                    amount: data['amount'],
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
        final data = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
              create: (_) => PropertyDetailsViewModel(),
              child: PropertyDetailsPage(
                propId: data['propId'],
                fromExternalApi: data['fromExternalLink'],
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
      case AppRoutes.propertyGalleryPage:
        final data = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
              create: (_) => PropertyDetailsViewModel(),
              child: PropertyGalleryViewPage(
                imageList: data['imageList'],
                videoLink: data['videoLink'],
                fromVideo: data['fromVideo'],
              )),
        );
      case AppRoutes.ownerPropertyListingPage:
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
              create: (_) => OwnerPropertyViewModel(),
              child: const OwnerPropertyListingPage()),
        );
      case AppRoutes.ownerPropertyDetailsPage:
        final data = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
              create: (_) => OwnerPropertyViewModel(),
              child: OwnerPropertyDetailsPage(
                propId: data,
              )),
        );
      case AppRoutes.hostPropertyPage:
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
              create: (_) => OwnerPropertyViewModel(),
              child: const HostPropertyPage()),
        );
      case AppRoutes.addPropertyPage:
        final data = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
              create: (_) => OwnerPropertyViewModel(),
              child: AddPropertyPage(
                fromPropertyDetails: data['fromPropertyDetails'],
                propId: data['propId'],
                title: data['title'],
                propertyType: data['propertyType'],
              )),
        );
      case AppRoutes.propertyRentPage:
        final data = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => OwnerPropertyViewModel(),
            child: PropertyRentPage(
              propId: data['propId'],
              fromPropertyDetails: data['fromPropertyDetails'],
              dailyRent: data['dailyRent'],
              monthlyRent: data['monthlyRent'],
              longTermDeposit: data['longTermDeposit'],
              longTermRent: data['longTermRent'],
            ),
          ),
        );
      case AppRoutes.propertyRoomsBedsPage:
        final data = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => OwnerPropertyViewModel(),
            child: PropertyRoomsBedsPage(
              propId: data['propId'],
              fromPropertyDetails: data['fromPropertyDetails'],
              guestCount: data['guestCount'],
              bathRoomsCount: data['bathRoomsCount'],
              bedRoomsCount: data['bedRoomsCount'],
            ),
          ),
        );
      case AppRoutes.editPropertyPhotosPage:
        final data = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => OwnerPropertyViewModel(),
            child: EditPropertyPhotosPage(
              propId: data['propId'],
              fromPropertyDetails: data['fromPropertyDetails'],
              videoLink: data['videoLink'],
              photosList: data['photosList'],
            ),
          ),
        );
      case AppRoutes.amenitiesPage:
        final data = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => OwnerPropertyViewModel(),
            child: PropertyAmenitiesPage(
              propId: data['propId'],
              fromPropertyDetails: data['fromPropertyDetails'],
              amenitiesList: data['amenitiesList'],
            ),
          ),
        );
      case AppRoutes.propertyDescriptionPage:
        final data = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => OwnerPropertyViewModel(),
            child: PropertyDescriptionPage(
              propId: data['propId'],
              fromPropertyDetails: data['fromPropertyDetails'],
              description: data['description'],
            ),
          ),
        );
      case AppRoutes.propertyRulesPage:
        final data = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => OwnerPropertyViewModel(),
            child: PropertyRulesPage(
              propId: data['propId'],
              fromPropertyDetails: data['fromPropertyDetails'],
              houseRules: data['houseRules'],
            ),
          ),
        );
      case AppRoutes.propertyLocationPage:
        final data = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => OwnerPropertyViewModel(),
            child: PropertyLocationPage(
              propId: data['propId'],
              fromPropertyDetails: data['fromPropertyDetails'],
              propertyLocation: data['propertyLocation'],
              latitude: data['latitude'],
              longitude: data['longitude'],
            ),
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
  static const String languageScreen = 'languageScreen';
  static const String propertyGalleryPage = 'propertyGalleryPage';
  static const String ownerPropertyListingPage = 'ownerPropertyListingPage';
  static const String hostPropertyPage = 'hostPropertyPage';
  static const String ownerPropertyDetailsPage = 'ownerPropertyDetailsPage';
  static const String addPropertyPage = 'addPropertyPage';
  static const String propertyRentPage = 'propertyRentPage';
  static const String propertyRoomsBedsPage = 'propertyRoomsBedsPage';
  static const String editPropertyPhotosPage = 'editPropertyPhotosPage';
  static const String amenitiesPage = 'amenitiesPage';
  static const String propertyDescriptionPage = 'propertyDescriptionPage';
  static const String propertyRulesPage = 'propertyRulesPage';
  static const String propertyLocationPage = 'propertyLocationPage';
}
