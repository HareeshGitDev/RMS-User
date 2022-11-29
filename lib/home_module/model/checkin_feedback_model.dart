class CheckInStatusFeedbackModel {
  String? msg;
  List<Data>? data;

  CheckInStatusFeedbackModel({this.msg, this.data});

  CheckInStatusFeedbackModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? bookingId;
  String? checkInFeedback;
  String? checkInStatus;
  String? name;
  String? travelFromDate;

  Data(
      {this.bookingId,
        this.checkInFeedback,
        this.checkInStatus,
        this.name,
        this.travelFromDate});

  Data.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    checkInFeedback = json['check_in_feedback'];
    checkInStatus = json['check_in_status'];
    name = json['name'];
    travelFromDate = json['travel_from_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['check_in_feedback'] = this.checkInFeedback;
    data['check_in_status'] = this.checkInStatus;
    data['name'] = this.name;
    data['travel_from_date'] = this.travelFromDate;
    return data;
  }
}
