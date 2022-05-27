import 'dart:async';
import 'dart:developer';

import 'package:RentMyStay_user/payment_module/model/payment_request_model.dart';
import 'package:RentMyStay_user/payment_module/viewModel/payment_viewModel.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../theme/custom_theme.dart';
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
  late StreamSubscription<ConnectivityResult> _connectivitySubs;
  final Connectivity _connectivity = Connectivity();
  bool _connectionStatus = true;

  Future<void> initConnectionStatus() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      log(e.toString());
    }
    if (!mounted) {
      return null;
    }

    _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        setState(() => _connectionStatus = true);
        break;
      case ConnectivityResult.mobile:
        setState(() => _connectionStatus = true);
        break;
      case ConnectivityResult.none:
        setState(() => _connectionStatus = false);
        break;
      case ConnectivityResult.ethernet:
        setState(() => _connectionStatus = true);
        break;
      default:
        setState(() => _connectionStatus = false);
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    initConnectionStatus();
    _connectivitySubs =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

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
    _connectivitySubs.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _connectionStatus
        ? Scaffold(
            appBar: AppBar(
              title: Text('Payment Screen'),
              backgroundColor: CustomTheme.appTheme,
              titleSpacing: 0,
              centerTitle: false,
              leading: SizedBox(
                width: 15,
              ),
            ),
          )
        : RMSWidgets.networkErrorPage(context: context);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (response.orderId != null &&
        response.signature != null &&
        response.paymentId != null) {
      RMSWidgets.showLoaderDialog(
          context: context, message: 'Confirmation Pending...');
      int value = await _viewModel.submitPaymentResponse(
          paymentId: response.paymentId!,
          paymentSignature: response.signature!,
          redirectApi: widget.paymentRequestModel.redirectApi);

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
            const Duration(seconds: 4),
            () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.dashboardPage,
                  (route) => false,
                ));
      }
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Navigator.of(context)
        .popAndPushNamed(AppRoutes.paymentStatusPage, arguments: {
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
      // 'send_sms_hash': true,
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
