import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../theme/custom_theme.dart';

class CalenderPage extends StatelessWidget {
  final DateRangePickerNavigationMode _navigationMode =
      DateRangePickerNavigationMode.scroll;
  final PickerDateRange initialDatesRange;

  CalenderPage({required this.initialDatesRange});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Moving/MoveOut Date'),
        titleSpacing: 0,
        backgroundColor: CustomTheme.appTheme,
      ),
      body: Container(
        color: Colors.white,
        child: _getDates(context: context),
      ),
    );
  }

  Widget _getDates({required BuildContext context}) {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
      child: SfDateRangePicker(
        enableMultiView: true,
        enablePastDates: false,
        endRangeSelectionColor: CustomTheme.appTheme,
        startRangeSelectionColor: CustomTheme.appTheme,
        confirmText: 'SELECT',
        onCancel: () => Navigator.pop(context),
        onSubmit: (dynamic data) {
if(data.startDate!.difference(DateTime.now()).inDays<10){
  if (data is PickerDateRange &&
      data.startDate != null &&
      data.endDate != null) {
    Navigator.pop(context, data);
  } else {
    RMSWidgets.showSnackbar(
        context: context,
        message: 'Please Select Valid Date Range',
        color: Colors.red);
  }
}
else{
  RMSWidgets.showSnackbar(
      context: context,
      message: 'Please Select Date within 10 days',
      color: Colors.red);
}
          // if (data is PickerDateRange &&
          //     data.startDate != null &&
          //     data.endDate != null) {
          //   Navigator.pop(context, data);
          // } else {
          //   RMSWidgets.showSnackbar(
          //       context: context,
          //       message: 'Please Select Valid Date Range',
          //       color: Colors.red);
          // }
        },
        initialSelectedRange: initialDatesRange,
        todayHighlightColor: CustomTheme.myFavColor,
        backgroundColor: Colors.white,
        selectionShape: DateRangePickerSelectionShape.rectangle,
        showActionButtons: true,
        headerStyle: DateRangePickerHeaderStyle(

          textStyle: TextStyle(
            fontSize: 18,
            fontFamily: 'hk-grotest',
            fontWeight: FontWeight.w500,
            color: Colors.black54
          ),
          textAlign: TextAlign.center,
        ),
        navigationDirection: DateRangePickerNavigationDirection.vertical,
        selectionMode: DateRangePickerSelectionMode.range,
        monthViewSettings:
            const DateRangePickerMonthViewSettings(enableSwipeSelection: false),
        showNavigationArrow: false,
        navigationMode: _navigationMode,
      ),
    );
  }
}
