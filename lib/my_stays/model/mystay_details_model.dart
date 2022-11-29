class MyStayDetailsModel {
  String? msg;
  Data? data;

  MyStayDetailsModel({this.msg, this.data});

  MyStayDetailsModel.fromJson(Map<String, dynamic> json) {
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
  String? bookingId;
  String? userId;
  String? check_in_feedback;
  String? propId;
  String? bookingStatus;
  String? travelFromDate;
  String? travelToDate;
  String? earlyCout;
  String? extensionReq;
  String? earlyCoutMarkBy;
  String? earlyCoutTimeMark;
  String? afterDiscMonthRent;
  String? numGuests;
  String? nights;
  String? period;
  String? totalAmount;
  String? amountPaid;
  String? advanceAmount;
  String? paidAdvancedAmount;
  String? bookingDatetime;
  String? contactEmail;
  String? travellerContactNum;
  String? travellerName;
  String? checkInStatus;
  String? checkInMarkBy;
  String? checkInTimeMark;
  String? cinUserTimeMark;
  String? cinUserMarkBy;
  String? coutUserTimeMark;
  String? coutUserMarkBy;
  String? checkOutStatus;
  String? checkOutMarkBy;
  String? checkOutTimeMark;
  String? extendStatus;
  String? extendStatusTimeMark;
  String? furnishedType;
  String? type;
  String? unit;
  String? picThumbnail;
  String? title;
  String? addressDisplay;
  String? glat;
  String? glng;
  String? edit_agmt;
  dynamic agreementStatus;
  String? agreementLink;
  String? approve;
  String? service_agreement_link;

  String? pendingAmount;

  Data(
      {this.bookingId,
        this.approve,
        this.edit_agmt,
        this.service_agreement_link,
        this.userId,
        this.check_in_feedback,
        this.propId,
        this.bookingStatus,
        this.travelFromDate,
        this.travelToDate,
        this.earlyCout,
        this.extensionReq,
        this.earlyCoutMarkBy,
        this.earlyCoutTimeMark,
        this.afterDiscMonthRent,
        this.numGuests,
        this.nights,
        this.period,
        this.unit,
        this.totalAmount,
        this.amountPaid,
        this.advanceAmount,
        this.paidAdvancedAmount,
        this.bookingDatetime,
        this.contactEmail,
        this.travellerContactNum,
        this.travellerName,
        this.checkInStatus,
        this.checkInMarkBy,
        this.checkInTimeMark,
        this.cinUserTimeMark,
        this.cinUserMarkBy,
        this.coutUserTimeMark,
        this.coutUserMarkBy,
        this.checkOutStatus,
        this.checkOutMarkBy,
        this.checkOutTimeMark,
        this.extendStatus,
        this.extendStatusTimeMark,
        this.furnishedType,
        this.type,
        this.picThumbnail,
        this.title,
        this.addressDisplay,
        this.glat,
        this.glng,
        this.agreementStatus,
        this.agreementLink,
        this.pendingAmount});

  Data.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    userId = json['user_id'];
    check_in_feedback = json['check_in_feedback'];
    propId = json['prop_id'];
    approve = json['approve'];
    unit = json['unit'];
    edit_agmt = json['edit_agmt'];
    bookingStatus = json['booking_status'];
    travelFromDate = json['travel_from_date'];
    travelToDate = json['travel_to_date'];
    earlyCout = json['early_cout'];
    extensionReq = json['extension_req'];
    earlyCoutMarkBy = json['early_cout_mark_by'];
    earlyCoutTimeMark = json['early_cout_time_mark'];
    afterDiscMonthRent = json['after_disc_month_rent'];
    numGuests = json['num_guests'];
    nights = json['nights'];
    period = json['period'];
    totalAmount = json['total_amount'];
    amountPaid = json['amount_paid'];
    advanceAmount = json['advance_amount'];
    paidAdvancedAmount = json['paid_advanced_amount'];
    bookingDatetime = json['booking_datetime'];
    contactEmail = json['contact_email'];
    travellerContactNum = json['traveller_contact_num'];
    travellerName = json['traveller_name'];
    checkInStatus = json['check_in_status'];
    checkInMarkBy = json['check_in_mark_by'];
    checkInTimeMark = json['check_in_time_mark'];
    cinUserTimeMark = json['cin_user_time_mark'];
    cinUserMarkBy = json['cin_user_mark_by'];
    coutUserTimeMark = json['cout_user_time_mark'];
    coutUserMarkBy = json['cout_user_mark_by'];
    checkOutStatus = json['check_out_status'];
    checkOutMarkBy = json['check_out_mark_by'];
    checkOutTimeMark = json['check_out_time_mark'];
    extendStatus = json['extend_status'];
    extendStatusTimeMark = json['extend_status_time_mark'];
    furnishedType = json['furnished_type'];
    type = json['type'];
    picThumbnail = json['pic_thumbnail'];
    title = json['title'];
    addressDisplay = json['address_display'];
    glat = json['glat'];
    glng = json['glng'];
    agreementStatus = json['agreement_status'];
    agreementLink = json['agreement_link'];
    service_agreement_link = json['service_agreement_link'];
    pendingAmount = json['pending_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['user_id'] = this.userId;
    data['check_in_feedback'] = this.check_in_feedback;
    data['prop_id'] = this.propId;
    data['unit'] = this.unit;
    data['approve'] = this.approve;
    data['edit_agmt'] = this.edit_agmt;
    data['booking_status'] = this.bookingStatus;
    data['travel_from_date'] = this.travelFromDate;
    data['travel_to_date'] = this.travelToDate;
    data['early_cout'] = this.earlyCout;
    data['extension_req'] = this.extensionReq;
    data['early_cout_mark_by'] = this.earlyCoutMarkBy;
    data['early_cout_time_mark'] = this.earlyCoutTimeMark;
    data['after_disc_month_rent'] = this.afterDiscMonthRent;
    data['num_guests'] = this.numGuests;
    data['nights'] = this.nights;
    data['period'] = this.period;
    data['total_amount'] = this.totalAmount;
    data['amount_paid'] = this.amountPaid;
    data['advance_amount'] = this.advanceAmount;
    data['paid_advanced_amount'] = this.paidAdvancedAmount;
    data['booking_datetime'] = this.bookingDatetime;
    data['contact_email'] = this.contactEmail;
    data['traveller_contact_num'] = this.travellerContactNum;
    data['traveller_name'] = this.travellerName;
    data['check_in_status'] = this.checkInStatus;
    data['check_in_mark_by'] = this.checkInMarkBy;
    data['check_in_time_mark'] = this.checkInTimeMark;
    data['cin_user_time_mark'] = this.cinUserTimeMark;
    data['cin_user_mark_by'] = this.cinUserMarkBy;
    data['cout_user_time_mark'] = this.coutUserTimeMark;
    data['cout_user_mark_by'] = this.coutUserMarkBy;
    data['check_out_status'] = this.checkOutStatus;
    data['check_out_mark_by'] = this.checkOutMarkBy;
    data['check_out_time_mark'] = this.checkOutTimeMark;
    data['extend_status'] = this.extendStatus;
    data['extend_status_time_mark'] = this.extendStatusTimeMark;
    data['furnished_type'] = this.furnishedType;
    data['type'] = this.type;
    data['pic_thumbnail'] = this.picThumbnail;
    data['title'] = this.title;
    data['address_display'] = this.addressDisplay;
    data['glat'] = this.glat;
    data['glng'] = this.glng;
    data['agreement_status'] = this.agreementStatus;
    data['agreement_link'] = this.agreementLink;
    data['service_agreement_link'] = this.service_agreement_link;
    data['pending_amount'] = this.pendingAmount;
    return data;
  }
}
