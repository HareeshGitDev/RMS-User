import 'dart:async';
import 'dart:developer';

import 'package:RentMyStay_user/payment_module/model/payment_request_model.dart';
import 'package:RentMyStay_user/payment_module/viewModel/payment_viewModel.dart';
import 'package:RentMyStay_user/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../utils/service/navigation_service.dart';
import '../../utils/view/rms_widgets.dart';

class RazorpayPaymentPage extends StatefulWidget {
  final PaymentRequestModel paymentRequestModel;

  const RazorpayPaymentPage({Key? key, required this.paymentRequestModel})
      : super(key: key);

  @override
  _RazorpayPaymentPageState createState() => _RazorpayPaymentPageState();
}

class _RazorpayPaymentPageState extends State<RazorpayPaymentPage> {
  late Razorpay _razorpay;
  late PaymentViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();
    _viewModel = Provider.of<PaymentViewModel>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback(
        (_) => openCheckout(model: widget.paymentRequestModel));
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Screen'),
        backgroundColor: CustomTheme.appTheme,
        titleSpacing: 0,
        leading: SizedBox(
          width: 15,
        ),
      ),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (response.orderId != null &&
        response.signature != null &&
        response.paymentId != null) {
      RMSWidgets.showLoaderDialog(
          context: context, message: 'Confirmation Pending...');
      await _viewModel
          .submitPaymentResponse(
              paymentId: response.paymentId!,
              paymentSignature: response.signature!,
              redirectApi: widget.paymentRequestModel.redirectApi)
          .then((value) {
        Navigator.of(context).pop();
        if (value == 200) {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.paymentStatusPage, (route) => false,
              arguments: {
                'status': 'success',
                'paymentId': response.paymentId,
                'amount': widget.paymentRequestModel.amount,
                'title': widget.paymentRequestModel.description,
              });
        } else {
          RMSWidgets.showSnackbar(
              context: context,
              message: 'Payment Failed.Money will be refund if Deducted',
              color: CustomTheme.errorColor);
          Timer(
              const Duration(seconds: 2),
              () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.dashboardPage,
                    (route) => false,
                  ));
        }
      }).catchError(
        (error) {
          Navigator.of(context).pop();
          log('Error :: ${error.toString()}');
        },
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.paymentStatusPage, (route) => false,
        arguments: {
          'status': 'failed',
          'amount': widget.paymentRequestModel.amount,
          'title': widget.paymentRequestModel.description,
        });
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}

  Future<void> openCheckout({required PaymentRequestModel model}) async {
    var options = {
      'key': model.razorPayKey,
      'amount': model.amount,
      'order_id': model.orderId,
      'image': model.image,
      'name': model.name,
      'description': model.description,
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      "theme": {
        "color": model.color,
      },
      'prefill': {'contact': model.contactNumber, 'email': model.email},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      log('Error :: ' + e.toString());
    }
  }
}
