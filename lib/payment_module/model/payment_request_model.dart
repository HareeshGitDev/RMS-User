import 'package:RentMyStay_user/utils/constants/enum_consts.dart';

class PaymentRequestModel {
  final PaymentMode paymentMode;
  final String razorPayKey;
  final String amount;
  final String name;
  final String email;
  final String color;
  final String description;
  final String orderId;
  final String image;
  final String redirectApi;
  final String contactNumber;
  String? extraInfo;

  PaymentRequestModel({
    required this.paymentMode,
    required this.razorPayKey,
    required this.description,
    required this.image,
    required this.email,
    required this.name,
    required this.color,
    required this.amount,
    required this.orderId,
    required this.contactNumber,
    required this.redirectApi,
    this.extraInfo
  });

}