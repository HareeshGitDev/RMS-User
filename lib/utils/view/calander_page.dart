import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../theme/custom_theme.dart';
import '../color.dart';

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
        backgroundColor: CustomTheme.peach,
      ),
      body: Container(
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
        endRangeSelectionColor: CustomTheme.peach,
        startRangeSelectionColor: CustomTheme.peach,
        confirmText: 'SELECT',
        onCancel: () => Navigator.pop(context),
        onSubmit: (dynamic data) {
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
        },
        initialSelectedRange: initialDatesRange,
        todayHighlightColor: myFavColor,
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
