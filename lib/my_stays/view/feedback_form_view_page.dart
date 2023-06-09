import 'dart:async';
import 'dart:developer';

import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../images.dart';
import '../../language_module/model/language_model.dart';
import '../../theme/custom_theme.dart';
import '../../utils/constants/sp_constants.dart';
import '../../utils/service/shared_prefrences_util.dart';
import '../viewmodel/mystay_viewmodel.dart';

class FeedbackPage extends StatefulWidget {
  final String name;
  final String title;
  final String email;
  final String bookingId;

  const FeedbackPage(
      {Key? key,
        required this.title,
        required this.bookingId,
        required this.email,
        required this.name})
      : super(key: key);

  @override
  _FeedbackState createState() => _FeedbackState();
}

class _FeedbackState extends State<FeedbackPage> {
  @override
  final _nameController = TextEditingController();
  final _banknameController = TextEditingController();
  final _banknumberController = TextEditingController();
  final _bankIfscController = TextEditingController();
  final _suggestionController = TextEditingController();
  final _nameScope = FocusNode();
  final _bankNameScope = FocusNode();
  final _accountNumberScope = FocusNode();
  final _ifscScope = FocusNode();
  var _mainHeight;
  var _mainWidth;
  static const String fontFamily = 'hk-grotest';
  late MyStayViewModel _viewModel;

  ValueNotifier<bool> isChecked = ValueNotifier(false);

  double rmsRating = 0.0;
  //double buildingRating = 0.0;
  var friendRecommendRating = 0.0;


  ValueNotifier<bool> shouldRecommendFriend = ValueNotifier(true);
  late SharedPreferenceUtil preferenceUtil = SharedPreferenceUtil();
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
  void dispose() {
    _connectivitySubs.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initConnectionStatus();
    _connectivitySubs =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _viewModel = Provider.of<MyStayViewModel>(context, listen: false);
    _viewModel.getMyBankDetails(bookingId: widget.bookingId,context: context);

    getLanguageData();
    dataAdd();
  }

  getLanguageData() async {
    await _viewModel.getLanguagesData(
        language: await preferenceUtil.getString(rms_language) ?? 'english',
        pageName: 'FeedbackForm');
  }
dataAdd(){
  _bankIfscController.text=(_viewModel.myBankDetailsModel.data?.ifscCode ?? "");
  _banknumberController.text=(_viewModel.myBankDetailsModel.data?.accNo ?? "");
  _banknameController.text=(_viewModel.myBankDetailsModel.data?.bankName ?? "");
  _nameController.text=(_viewModel.myBankDetailsModel.data?.accHolder ?? "");
}
  bool nullCheck({required List<LanguageModel> list}) =>
      list.isNotEmpty ? true : false;

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;

    return _connectionStatus?Scaffold(
      appBar: AppBar(
        title: Text(
            nullCheck(list: context.watch<MyStayViewModel>().feedBackLang)
                ? '${context.watch<MyStayViewModel>().feedBackLang[0].name}'
                : 'Feedback Form '),
        backgroundColor: CustomTheme.appTheme,
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: Consumer<MyStayViewModel>(
        builder: (BuildContext context, value, Widget? child) {


          return GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: Container(
              height: _mainHeight,
              color: Colors.white,
              width: _mainWidth,
              padding: EdgeInsets.only(
                  left: _mainWidth * 0.04,
                  right: _mainWidth * 0.04,
                  top: _mainHeight * 0.02),
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.name,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '  ( ${widget.email} )',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ), SizedBox(
                        height: _mainHeight * 0.02,
                      ),
                      Text(
                        ' Booking Id : ${widget.bookingId} ',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: _mainHeight * 0.02,
                      ),
                      Text(
                        widget.title,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: _mainWidth*0.75,
                            child: Text(
                              nullCheck(list: value.feedBackLang)
                                  ? '${value.feedBackLang[1].name} '
                                  :'Select CheckBox if No Deposit Paid',
                              maxLines: 2,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis
                              ),
                            ),
                          ),
                          ValueListenableBuilder(
                              valueListenable: isChecked,
                              builder: (context, bool value, child) {
                                return Checkbox(
                                    activeColor: CustomTheme.appTheme,
                                    shape: const CircleBorder(),
                                    value: value,
                                    onChanged: (checked) {
                                      log('Is Checked $checked');
                                      if (checked != null) {
                                        isChecked.value = checked;
                                      }
                                    });
                              }),
                        ],
                      ),
                      Text(
                        nullCheck(list: value.feedBackLang)
                            ? '${value.feedBackLang[2].name} '
                            :'Final Settlement amount to be sent to the following bank account within 3-5 working days after handling over keys and all scheduled deduction.',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            fontSize: 14),
                      ),
                      ValueListenableBuilder(
                          valueListenable: isChecked,

                          builder: (context, bool checkedValue, child) {
                            return Visibility(
                              visible: isChecked.value == false,
                              replacement: SizedBox(
                                height: 0,
                              ),
                              child: Column(
                                children: [
                                  _textInput(
                                    controller: _nameController,
                                    hint: nullCheck(list: value.feedBackLang)
                                        ? '${value.feedBackLang[3].name} '
                                        :'Enter Account Holder Name Here',
                                    focusNode: _nameScope,
                                  ),
                                  _textInput(
                                    controller: _banknameController,
                                    hint: nullCheck(list: value.feedBackLang)
                                        ? '${value.feedBackLang[4].name} '
                                        :'Enter Bank Name Here',
                                    focusNode: _bankNameScope,
                                  ),
                                  _textInput(
                                      controller: _banknumberController,
                                      hint: nullCheck(list: value.feedBackLang)
                                          ? '${value.feedBackLang[5].name} '
                                          :'Enter Account Number Here',
                                      focusNode: _accountNumberScope),
                                  _textInput(
                                    controller: _bankIfscController,
                                    hint: nullCheck(list: value.feedBackLang)
                                        ? '${value.feedBackLang[6].name} '
                                        :'Enter IFSC Code Here',
                                    focusNode: _ifscScope,
                                  ),
                                  SizedBox(height: 20,),
                                  value.myBankDetailsModel.data?.bankdetails !=null? Container(


                                    width: double.infinity,
                                    child: Neumorphic(
                                      style: const NeumorphicStyle(
                                        depth: -2,
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          Padding(
                                            padding:  EdgeInsets.only(left: 15, right: 15,top: 15),
                                            child: const Text("Bank Details",

                                            ),
                                          ),
                                          Padding(
                                            padding:  EdgeInsets.only(left: 15, right: 15,bottom: 15,top: 5),

                                            child: Text("${value.myBankDetailsModel.data?.bankdetails}"),
                                          )
                                        ],
                                      ),
                                    ),
                                  ):Container()
                                ],
                              ),
                            );
                          }),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        nullCheck(list: value.feedBackLang)
                            ? '${value.feedBackLang[7].name} '
                            :'How was your exprience with RentMyStay ? ',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 14),
                      ),
                      SizedBox(
                        height: _mainHeight * 0.01,
                      ),
                      Container(
                        height: _mainHeight * 0.05,
                        width: _mainWidth,
                        child: RatingBar.builder(
                          // initialRating: 4,
                          itemCount: 5,
                          glow: false,
                          maxRating: 10.0,
                          itemSize: _mainHeight * 0.045,
                          itemPadding: EdgeInsets.only(
                              left: _mainWidth * 0.04,
                              right: _mainWidth * 0.04),
                          itemBuilder: (context, index) {
                            switch (index) {
                              case 0:
                                return Icon(
                                  Icons.sentiment_very_dissatisfied,
                                  color: CustomTheme.appTheme.withAlpha(50),
                                );
                              case 1:
                                return Icon(
                                  Icons.sentiment_dissatisfied,
                                  color: CustomTheme.appTheme.withAlpha(100),
                                );
                              case 2:
                                return Icon(
                                  Icons.sentiment_neutral,
                                  color: CustomTheme.appTheme.withAlpha(150),
                                );
                              case 3:
                                return Icon(
                                  Icons.sentiment_satisfied,
                                  color: CustomTheme.appTheme.withAlpha(200),
                                );
                              case 4:
                                return Icon(
                                  Icons.sentiment_very_satisfied,
                                  color: CustomTheme.appTheme,
                                );
                              default:
                                return Container();
                            }
                          },
                          onRatingUpdate: (double rating) {
                            rmsRating = rating*1;
                          },
                        ),
                      ),
                      SizedBox(
                        height: _mainHeight * 0.01,
                      ),
                      Text(
                        nullCheck(list: value.feedBackLang)
                            ? '${value.feedBackLang[13].name} '
                            :'How likely are you to recommend RentMyStay to your friends ?',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 14),
                      ),
                      SizedBox(
                        height: _mainHeight * 0.01,
                      ),
                      Container(
                        height: _mainHeight * 0.05,
                        width: _mainWidth,
                        child: RatingBar.builder(
                          //initialRating: 4,
                          itemCount: 5,
                          glow: false,
                          maxRating: 10.0,
                          itemSize: _mainHeight * 0.045,
                          itemPadding: EdgeInsets.only(
                              left: _mainWidth * 0.04,
                              right: _mainWidth * 0.04),
                          itemBuilder: (context, index) {
                            switch (index) {
                              case 0:
                                return Icon(
                                  Icons.sentiment_very_dissatisfied,
                                  color: CustomTheme.appTheme.withAlpha(50),
                                );
                              case 1:
                                return Icon(
                                  Icons.sentiment_dissatisfied,
                                  color: CustomTheme.appTheme.withAlpha(100),
                                );
                              case 2:
                                return Icon(
                                  Icons.sentiment_neutral,
                                  color: CustomTheme.appTheme.withAlpha(150),
                                );
                              case 3:
                                return Icon(
                                  Icons.sentiment_satisfied,
                                  color: CustomTheme.appTheme.withAlpha(200),
                                );
                              case 4:
                                return Icon(
                                  Icons.sentiment_very_satisfied,
                                  color: CustomTheme.appTheme,
                                );
                              default:
                                return Container();
                            }
                          },
                          onRatingUpdate: (double rating) {
                            //buildingRating = rating * 1;
                            friendRecommendRating = rating * 1;
                          },
                        ),
                      ),
                      SizedBox(
                        height: _mainHeight * 0.01,
                      ),
                      /*Text(
                        nullCheck(list: value.feedBackLang)
                            ? '${value.feedBackLang[9].name} '
                            : 'Would You Recommend our service to a friend / Colleague ?',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 14),
                      ),
                      Container(
                          padding: EdgeInsets.only(
                              left: _mainWidth * 0.04,
                              right: _mainWidth * 0.04,
                              top: _mainHeight * 0.01,
                              bottom: _mainHeight * 0.01),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ValueListenableBuilder(
                                  valueListenable: shouldRecommendFriend,
                                  builder: (context, bool yesValue, child) {
                                    return InkWell(
                                      onTap: () {
                                        shouldRecommendFriend.value = true;
                                      },
                                      child: Container(
                                        color: Colors.white,
                                        child: Row(
                                          children: [
                                            yesValue
                                                ? Icon(Icons.thumb_up,
                                                size: _mainHeight * 0.03,
                                                color: CustomTheme.myFavColor)
                                                : Icon(
                                                Icons.thumb_up_alt_outlined,
                                                size: _mainHeight * 0.03,
                                                color: CustomTheme.myFavColor),
                                            SizedBox(width: _mainWidth * 0.02),
                                            Text('YES',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: CustomTheme.myFavColor,
                                                    fontWeight:
                                                    FontWeight.w600)),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                ValueListenableBuilder(
                                  valueListenable: shouldRecommendFriend,
                                  builder: (context, bool noValue, child) {
                                    return InkWell(
                                      onTap: () {
                                        shouldRecommendFriend.value = false;
                                      },
                                      child: Container(
                                        color: Colors.white,
                                        child: Row(children: [
                                          noValue == false
                                              ? Icon(Icons.thumb_down,
                                              size: _mainHeight * 0.03,
                                              color: CustomTheme.black)
                                              : Icon(Icons.thumb_down_outlined,
                                              size: _mainHeight * 0.03,
                                              color: CustomTheme.black),
                                          SizedBox(width: _mainWidth * 0.02),
                                          Text(
                                            'NO',
                                            style: TextStyle(
                                                color: CustomTheme.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18),
                                          ),
                                        ]),
                                      ),
                                    );
                                  },
                                ),
                              ])),*/
                      Text(nullCheck(list: value.feedBackLang)
                          ? '${value.feedBackLang[10].name} '
                          :'Any Suggestion (Optional) ?'),
                      _textInput(
                          controller: _suggestionController,
                          hint: nullCheck(list: value.feedBackLang)
                              ? '${value.feedBackLang[11].name} '
                              :'Enter Your Suggestion here'),
                      SizedBox(
                        height: 10,
                      ),
                    ]),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        height: _mainHeight * 0.06,
        padding: EdgeInsets.only(
            left: _mainWidth * 0.04,
            right: _mainWidth * 0.04,
            bottom: _mainWidth * 0.02),
        child: ElevatedButton(
          onPressed: () async {
            if (isChecked.value == false) {
              if (_nameController.text.isEmpty) {
                FocusScope.of(context).requestFocus(_nameScope);
                RMSWidgets.showSnackbar(
                    context: context,
                    message: 'Name is not Valid.',
                    color: Colors.red);
                return;
              } else if (_banknameController.text.isEmpty) {
                FocusScope.of(context).requestFocus(_bankNameScope);
                RMSWidgets.showSnackbar(
                    context: context,
                    message: 'Bank Name is not Valid.',
                    color: Colors.red);
                return;
              } else if (_banknumberController.text.isEmpty) {
                FocusScope.of(context).requestFocus(_accountNumberScope);
                RMSWidgets.showSnackbar(
                    context: context,
                    message: 'Bank Account Number is not Valid.',
                    color: Colors.red);
                return;
              } else if (_bankIfscController.text.isEmpty) {
                FocusScope.of(context).requestFocus(_ifscScope);
                RMSWidgets.showSnackbar(
                    context: context,
                    message: 'Bank IFSC Code is not Valid.',
                    color: Colors.red);
                return;
              } else if (rmsRating==0.0) {
                // FocusScope.of(context).requestFocus(_ifscScope);
                RMSWidgets.showSnackbar(
                    context: context,
                    message: 'Please rate your experience with RentMyStay.',
                    color: Colors.red);
                return;
              } else if (friendRecommendRating==0.0) {
               // FocusScope.of(context).requestFocus(_ifscScope);
                RMSWidgets.showSnackbar(
                    context: context,
                    message: 'Please rate your recommendation of rentmystay to your friends.',
                    color: Colors.red);
                return;
              } else {
                RMSWidgets.showLoaderDialog(
                    context: context, message: 'Loading');
                String bankDetails =
                    '${_nameController.text} ${_banknameController.text} ${_banknumberController.text} ${_bankIfscController.text}';
                int response = await _viewModel.submitFeedbackAndBankDetails(
                    context: context,
                    bookingId: widget.bookingId,
                    bank_name: _banknameController.text.toString(),
                    account_number: _banknumberController.text.toString(),
                    account_name: _nameController.text.toString(),
                    ifsc_code: _bankIfscController.text.toString(),
                    email: widget.email,
                    ratings: rmsRating.toString(),
                   //buildingRatings: buildingRating.toString(),
                    friendRecommendRatings: friendRecommendRating.toString(),
                    suggestions: _suggestionController.text,
                    source : "android",
                    /*friendRecommendation:
                    shouldRecommendFriend.value ? 'Yes' : 'No'*/);
                if (response == 200) {
                  RMSWidgets.showSnackbar(
                      context: context,
                      message: 'Details Updated Successfully.',
                      color: CustomTheme.myFavColor);
                } else {
                  RMSWidgets.showSnackbar(
                      context: context,
                      message: 'Something Went Wrong.',
                      color: CustomTheme.appThemeContrast);
                }
                Navigator.of(context).pop();
              }
            } else {
              RMSWidgets.showLoaderDialog(context: context, message: 'Loading');
              int response = await _viewModel.submitFeedbackAndBankDetails(
                context: context,
                bookingId: widget.bookingId,
                email: widget.email,
                ratings: rmsRating.toString(),
                bank_name: _banknameController.text.toString(),
                account_number: _banknumberController.text.toString(),
                account_name: _nameController.text.toString(),
                ifsc_code: _bankIfscController.text.toString(),
                //buildingRatings: buildingRating.toString(),
                friendRecommendRatings: friendRecommendRating.toString(),
                suggestions: _suggestionController.text,
                source: 'android',
                /*friendRecommendation:
                shouldRecommendFriend.value ? 'Yes' : 'No',*/ );
              log(response.toString());
              if (response == 200) {
                RMSWidgets.showSnackbar(
                    context: context,
                    message: 'Details Updated Successfully.',
                    color: CustomTheme.myFavColor);
              } else {
                RMSWidgets.showSnackbar(
                    context: context,
                    message: 'Something Went Wrong.',
                    color: CustomTheme.appThemeContrast);
              }
              Navigator.of(context).pop();
            }
          },
          child: Text(
            nullCheck(list: context.watch<MyStayViewModel>().feedBackLang)
                ? '${context.watch<MyStayViewModel>().feedBackLang[12].name}'
                :'Submit Feedback',
            style: TextStyle(
                fontFamily: fontFamily,
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16),
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                CustomTheme.appThemeContrast,
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              )),
        ),
      ),
    ):RMSWidgets.networkErrorPage(context: context);
  }

  Widget _textInput({
    required TextEditingController controller,
    required String hint,
    FocusNode? focusNode,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: -2,
          color: Colors.white,
        ),
        child: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
            ),
          ),
        ),
      ),
    );
  }
}
