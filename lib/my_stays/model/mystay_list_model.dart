class MyStayListModel {
  String? msg;
  Data? data;

  MyStayListModel({this.msg, this.data});

  MyStayListModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Result>? result;

  Data({this.result});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String? bookingId;
  String? bookingStatus;
  String? userId;
  String? propId;
  String? bookingDatetime;
  String? numGuests;
  String? nights;
  String? checkInStatus;
  String? checkOutStatus;
  String? earlyCout;
  String? travelFromDate;
  String? travelToDate;
  String? orderStatus;
  String? orderId;
  String? advanceAmount;
  String? amount;
  String? adminConfirmed;
  String? title;
  String? uiAddress;
  String? firstname;
  String? address;
  String? picture;
  String? unit;
  String? unit_type;
  String? picThumbnail;

  Result(
      {this.bookingId,
        this.bookingStatus,
        this.userId,
        this.propId,
        this.unit,
        this.unit_type,
        this.bookingDatetime,
        this.numGuests,
        this.nights,
        this.checkInStatus,
        this.checkOutStatus,
        this.earlyCout,
        this.travelFromDate,
        this.travelToDate,
        this.orderStatus,
        this.orderId,
        this.advanceAmount,
        this.amount,
        this.adminConfirmed,
        this.title,
        this.uiAddress,
        this.firstname,
        this.address,
        this.picture,
        this.picThumbnail});

  Result.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    bookingStatus = json['booking_status'];
    userId = json['user_id'];
    propId = json['prop_id'];
    unit_type = json['unit_type'];
    unit = json['unit'];
    bookingDatetime = json['booking_datetime'];
    numGuests = json['num_guests'];
    nights = json['nights'];
    checkInStatus = json['check_in_status'];
    checkOutStatus = json['check_out_status'];
    earlyCout = json['early_cout'];
    travelFromDate = json['travel_from_date'];
    travelToDate = json['travel_to_date'];
    orderStatus = json['order_status'];
    orderId = json['order_id'];
    advanceAmount = json['advance_amount'];
    amount = json['amount'];
    adminConfirmed = json['admin_confirmed'];
    title = json['title'];
    uiAddress = json['ui_address'];
    firstname = json['firstname'];
    address = json['address'];
    picture = json['picture'];
    picThumbnail = json['pic_thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['booking_status'] = this.bookingStatus;
    data['user_id'] = this.userId;
    data['prop_id'] = this.propId;
    data['unit_type'] = this.unit_type;
    data['unit'] = this.unit;
    data['booking_datetime'] = this.bookingDatetime;
    data['num_guests'] = this.numGuests;
    data['nights'] = this.nights;
    data['check_in_status'] = this.checkInStatus;
    data['check_out_status'] = this.checkOutStatus;
    data['early_cout'] = this.earlyCout;
    data['travel_from_date'] = this.travelFromDate;
    data['travel_to_date'] = this.travelToDate;
    data['order_status'] = this.orderStatus;
    data['order_id'] = this.orderId;
    data['advance_amount'] = this.advanceAmount;
    data['amount'] = this.amount;
    data['admin_confirmed'] = this.adminConfirmed;
    data['title'] = this.title;
    data['ui_address'] = this.uiAddress;
    data['firstname'] = this.firstname;
    data['address'] = this.address;
    data['picture'] = this.picture;
    data['pic_thumbnail'] = this.picThumbnail;
    return data;
  }
}