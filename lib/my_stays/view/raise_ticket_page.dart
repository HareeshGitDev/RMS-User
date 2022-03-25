import 'dart:io';

import 'package:RentMyStay_user/theme/app_theme.dart';
import 'package:RentMyStay_user/utils/service/capture_photos_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

import '../viewmodel/mystay_viewmodel.dart';

class RaiseTicketPage extends StatefulWidget {
  const RaiseTicketPage({Key? key}) : super(key: key);

  @override
  _RaiseTicketPageState createState() => _RaiseTicketPageState();
}

class _RaiseTicketPageState extends State<RaiseTicketPage> {
  var _mainHeight;
  var _mainWidth;
  String issueType = 'Select Issue';
  final _descriptionController = TextEditingController();

  late MyStayViewModel _viewModel;

  List<File> imageList = [];

  List<String> get getIssueList => [
        'Select Issue',
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

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<MyStayViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
      body: Container(
        height: _mainHeight,
        width: _mainWidth,
        padding: EdgeInsets.only(left: 15, right: 15, top: 15),
        color: Colors.white,
        child: Column(
          children: [
            Text(
              'Kindly report your issue by selecting the category and description',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  fontSize: 16),
              textAlign: TextAlign.start,
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                String value = await showIssueList(
                    context: context, issueList: getIssueList);
                setState(() {
                  issueType = value;
                });
              },
              child: Container(
                height: 40,
                width: _mainWidth,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(issueType),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: _mainHeight * 0.045,
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
                    hintText: "Enter the description...",
                    prefixIcon: Icon(Icons.email_outlined,
                        color: Colors.grey, size: 20),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Add Images of Your Issue',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 16),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
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
                          imageList.add(File(model));
                        });
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
                          imageList.add(File(model));
                        });
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
            SizedBox(
              height: 30,
            ),
            Visibility(
              visible: imageList.isNotEmpty,
              replacement: Container(),
              child: Container(
                height: _mainHeight * 0.2,
                width: _mainWidth,
                child: ListView.separated(
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
                              backgroundColor: CustomTheme.white.withAlpha(250),
                              radius: 15,
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
                ),
              ),
            )
          ],
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
            //
          },
          child: Center(child: Text("Submit Ticket")),
        ),
      ),
    );
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
                padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                height: _mainHeight * 0.6,
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      width: _mainWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Issue Type'),
                          IconButton(
                              onPressed: () =>
                                  Navigator.of(context).pop(issueType),
                              icon: Icon(Icons.close)),
                        ],
                      ),
                    ),
                    Container(
                      height: _mainHeight * 0.50,
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            var data = issueList[index];
                            return GestureDetector(
                              onTap: () => Navigator.of(context).pop(data),
                              child: Container(
                                  color: Colors.amber,
                                  height: 50,
                                  width: _mainWidth,
                                  child: Text(data)),
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
