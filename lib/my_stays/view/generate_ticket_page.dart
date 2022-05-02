import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:RentMyStay_user/theme/app_theme.dart';
import 'package:RentMyStay_user/utils/service/bottom_navigation_provider.dart';
import 'package:RentMyStay_user/utils/service/capture_photos_page.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

import '../../utils/service/navigation_service.dart';
import '../viewmodel/mystay_viewmodel.dart';

class GenerateTicketPage extends StatefulWidget {
  final String bookingId;
  final String propertyId;
  final String address;

  const GenerateTicketPage(
      {Key? key,
      required this.bookingId,
      required this.propertyId,
      required this.address})
      : super(key: key);

  @override
  _GenerateTicketPageState createState() => _GenerateTicketPageState();
}

class _GenerateTicketPageState extends State<GenerateTicketPage> {
  var _mainHeight;
  var _mainWidth;
  String issueType = 'Select Issue';
  final _descriptionController = TextEditingController();

  late MyStayViewModel _viewModel;

  String? image;

  List<String> get getIssueList => [
        'Pest Control',
        'Cable Issue',
        'Cable Recharge',
        'Duplicate Key',
        'Electrical Issue',
        'Electronics Issue',
        'Furniture Issue',
        'Gas Cylinder Refill',
        'Lift/Power Backup',
        'Painting Issue',
        'Plumbing Issue',
        'Water Issue',
        'Other...'
      ];

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
  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return _connectionStatus?Scaffold(
      appBar: AppBar(
        title: Text(
          'Raise Ticket',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: CustomTheme.appTheme,
        titleSpacing: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Container(
          height: _mainHeight,
          width: _mainWidth,
          //padding: EdgeInsets.only(left: 15, right: 15, top: 15),
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Text(
                    'Kindly report your issue by selecting the category and description',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                        fontSize: 16),
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  width: _mainWidth,
                  child: GestureDetector(
                    onTap: () async {
                      String value = await showIssueList(
                          context: context, issueList: getIssueList);
                      setState(() {
                        issueType = value;
                      });
                    },
                    child: Neumorphic(
                      style: NeumorphicStyle(depth: -2, color: Colors.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: _mainWidth * 0.035,
                          ),
                          Icon(Icons.error_outline,
                              color: Colors.grey, size: 20),
                          Container(
                            height: 40,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                              issueType,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: _mainHeight * 0.045,
                  padding: EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white,
                  ),
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      depth: -2,
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54),
                        hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey),
                        hintText: "Enter the description...",
                        prefixIcon: Icon(Icons.email_outlined,
                            color: Colors.grey, size: 20),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding: EdgeInsets.only(left: 15, top: 2, bottom: 2),
                  color: CustomTheme.appTheme,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Add Images of Your Issue',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: CustomTheme.appTheme),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: TextButton.icon(
                          onPressed: () async {
                            final String? model =
                                await CapturePhotoPage.captureImageByGallery(
                              context: context,
                              function: (imagePath) async {},
                            );
                            if (model != null) {
                              setState(() {
                                image=model;
                              });
                              log(model);
                            }
                          },
                          icon: Icon(
                            Icons.folder_open,
                            color: CustomTheme.appThemeContrast,
                          ),
                          label: Container(
                            width: _mainWidth * 0.29,
                            child: Wrap(
                              children: [
                                Text(
                                  "Select from Gallery",
                                  style: TextStyle(
                                      color: CustomTheme.appThemeContrast,
                                      fontFamily: "Nunito",
                                      fontSize: 14,
                                      height: 1.1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: CustomTheme.appTheme),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: TextButton.icon(
                          onPressed: () async {
                            final String? model =
                                await CapturePhotoPage.captureImageByCamera(
                              context: context,
                              function: (imagePath) async {},
                            );
                            if (model != null) {
                              setState(() {
                                image=model;
                              });
                              log(model);
                            }
                          },
                          icon: Icon(
                            Icons.camera_alt_outlined,
                            color: CustomTheme.appThemeContrast,
                          ),
                          label: Container(
                            width: _mainWidth * 0.29,
                            child: Text(
                              "Click Photo",
                              style: TextStyle(
                                color: CustomTheme.appThemeContrast,
                                fontFamily: "Nunito",
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Visibility(
                  visible: image != null,
                  replacement: Container(),
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    height: _mainHeight * 0.2,
                    width: _mainWidth,
                    child:Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            image != null? File(image.toString()):File(''),
                            fit: BoxFit.cover,
                            width: _mainWidth * 0.4,
                          ),
                        ),
                        Positioned(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => image=null),
                            child: CircleAvatar(
                              child: Icon(
                                Icons.clear,
                                color: CustomTheme.appTheme,
                                size: 16,
                              ),
                              backgroundColor:
                              CustomTheme.white.withAlpha(250),
                              radius: 12,
                            ),
                          ),
                          left: 0,
                        )
                      ],
                    )/* ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(
                                imageList[index],
                                fit: BoxFit.cover,
                                width: _mainWidth * 0.4,
                              ),
                            ),
                            Positioned(
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => imageList.removeAt(index)),
                                child: CircleAvatar(
                                  child: Icon(
                                    Icons.clear,
                                    color: CustomTheme.appTheme,
                                    size: 16,
                                  ),
                                  backgroundColor:
                                      CustomTheme.white.withAlpha(250),
                                  radius: 12,
                                ),
                              ),
                              right: 0,
                            )
                          ],
                        );
                      },
                      itemCount: imageList.length,
                      separatorBuilder: (context, index) => SizedBox(
                        width: 10,
                      ),
                    ),*/
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: _mainWidth,
        margin: EdgeInsets.only(bottom: 20, left: 15, right: 15),
        height: 40,
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(CustomTheme.appTheme),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              )),
          onPressed: () async {
            if (issueType == 'Select Issue') {
              return;
            }
            RMSWidgets.showLoaderDialog(context: context, message: 'Loading');
            int response = await _viewModel.generateTicket(
                bookingId: widget.bookingId,
                requirements: issueType,
                propertyId: widget.propertyId,
                description: _descriptionController.text,
                address: widget.address,
                imagePath: image);
            Navigator.of(context).pop();
            if(response==200){
              RMSWidgets.showSnackbar(context: context, message: 'Ticket has been created Successfully', color: CustomTheme.myFavColor);
              Provider.of<BottomNavigationProvider>(context,listen: false).shiftBottom(index: 0);
              Navigator.of(context,).pushNamedAndRemoveUntil(AppRoutes.dashboardPage, (route) => false);
            }
          },
          child: Center(child: Text("Submit Ticket")),
        ),
      ),
    ):RMSWidgets.networkErrorPage(context: context);
  }

  Future<dynamic> showIssueList(
      {required BuildContext context, required List<String> issueList}) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        builder: (context) {
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return Container(
                padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                height: _mainHeight * 0.6,
                child: Column(
                  children: [
                    Container(
                      height: 30,
                      width: _mainWidth,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Select Issue Type',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                fontSize: 16),
                          ),
                          GestureDetector(
                              onTap: () => Navigator.of(context).pop(issueType),
                              child: Icon(
                                Icons.close,
                                color: Colors.black,
                              )),
                        ],
                      ),
                    ),
                    Divider(color: CustomTheme.appTheme),
                    Container(
                      height: _mainHeight * 0.50,
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            var data = issueList[index];
                            return GestureDetector(
                              onTap: () => Navigator.of(context).pop(data),
                              child: Container(
                                  height: 35,
                                  //color: Colors.amber,
                                  width: _mainWidth,
                                  child: Text(
                                    data,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54,
                                        fontSize: 16),
                                  )),
                            );
                          },
                          separatorBuilder: (context, index) => SizedBox(
                                height: 1,
                              ),
                          itemCount: issueList.length),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}
