import 'package:RentMyStay_user/my_stays/viewmodel/mystay_viewmodel.dart';
import 'package:RentMyStay_user/theme/app_theme.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/service/navigation_service.dart';

class TicketListPage extends StatefulWidget {
  const TicketListPage({Key? key}) : super(key: key);

  @override
  _TicketListPageState createState() => _TicketListPageState();
}

class _TicketListPageState extends State<TicketListPage> {
  var _mainHeight;
  var _mainWidth;
  late MyStayViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<MyStayViewModel>(context, listen: false);
    _viewModel.getTicketList();
  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          'Created Tickets',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: CustomTheme.appTheme,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.pushNamed(context, AppRoutes.myStayListPage, arguments: {
          'fromBottom': false,
        }),
        backgroundColor: CustomTheme.appTheme,
        splashColor: CustomTheme.myFavColor,
        tooltip: 'Create Ticket',
        child: Icon(Icons.add),
      ),
      body: Consumer<MyStayViewModel>(
        builder: (context, value, child) {
          return value.ticketResponseModel != null &&
                  value.ticketResponseModel?.data != null &&
                  value.ticketResponseModel?.data?.length != 0
              ? Container(
                  height: _mainHeight,
                  width: _mainWidth,
                  padding: EdgeInsets.only(
                      left: _mainWidth * 0.03,
                      right: _mainWidth * 0.03,
                      top: _mainHeight * 0.01,
                      bottom: _mainHeight * 0.01),
                  color: Colors.white,
                  child: Column(
                    
                    children: [
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            var data = value.ticketResponseModel?.data?[index];
                            return GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                      context, AppRoutes.ticketDetailsPage,
                                      arguments: data ?? [])
                                  .then((value) async {
                                /* RMSWidgets.showLoaderDialog(
                                    context: context, message: 'Loading');*/
                                await _viewModel.getTicketList();
                                /* Navigator.of(context).pop();*/
                              }),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                    height: _mainHeight * 0.05,
                                    width: _mainWidth,
                                    padding: EdgeInsets.only(
                                      left: _mainWidth * 0.015,
                                      right: _mainWidth * 0.015,
                                    ),
                                    child: Row(

                                      children: [

                                        Text(
                                          '${index + 1}.',
                                          style: TextStyle(
                                              color: CustomTheme.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14),
                                        ),
                                        Spacer(),
                                        Container(
                                          width: _mainWidth * 0.7,
                                          child: Text(
                                            '${data?.description ?? ''}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14),
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          '${data?.status ?? ''}',
                                          style: TextStyle(
                                              color: data?.status?.toLowerCase() ==
                                                      'resolved'
                                                  ? CustomTheme.myFavColor
                                                  : data?.status?.toLowerCase() ==
                                                          'open'
                                                      ? CustomTheme.appTheme
                                                      : CustomTheme.appThemeContrast,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14),
                                        ),
                                      ],
                                    )),
                              ),
                            );
                          },
                          itemCount: value.ticketResponseModel?.data?.length ?? 0,
                          separatorBuilder: (context, index) => SizedBox(
                            height: _mainHeight * 0.008,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : value.ticketResponseModel != null &&
                      value.ticketResponseModel?.data != null &&
                      value.ticketResponseModel?.data?.length == 0
                  ? Center(
                      child: RMSWidgets.noData(
                      context: context,
                      message: 'No Tickets Found.',
                    ))
                  : Center(
                      child: RMSWidgets.getLoader(color: CustomTheme.appTheme));
        },
      ),
    );
  }
}
