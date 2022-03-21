class InvoiceDetailsModel {
  String? msg;
  Data? data;

  InvoiceDetailsModel({this.msg, this.data});

  InvoiceDetailsModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['msg'] = msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  double? gatewayCharge;
  List<InvoiceDetails>? invoiceDetails;

  Data({this.gatewayCharge, this.invoiceDetails});

  Data.fromJson(Map<String, dynamic> json) {
    gatewayCharge = json['gateway_charge'];
    if (json['invoice_details'] != null) {
      invoiceDetails = <InvoiceDetails>[];
      json['invoice_details'].forEach((v) {
        invoiceDetails!.add(InvoiceDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['gateway_charge'] = gatewayCharge;
    if (invoiceDetails != null) {
      data['invoice_details'] =
          invoiceDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InvoiceDetails {
  String? invoiceId;
  String? bookingId;
  String? paymentId;
  String? amountStatus;
  String? durationPeriod;
  String? mailStatus;
  String? reminderMail;
  String? amountRecieved;
  String? amount;
  dynamic totalAmount;
  String? disc;
  String? fromDate;
  String? tillDate;
  String? pendingBalance;
  String? paymentMode;
  String? comment;
  String? status;
  String? mailCount;
  String? sendTime;
  String? modify;
  String? transactionType;
  String? createdOn;
  dynamic utrNo;
  int? refferalDiscount;

  InvoiceDetails(
      {this.invoiceId,
        this.bookingId,
        this.paymentId,
        this.amountStatus,
        this.durationPeriod,
        this.mailStatus,
        this.reminderMail,
        this.amountRecieved,
        this.amount,
        this.totalAmount,
        this.disc,
        this.fromDate,
        this.tillDate,
        this.pendingBalance,
        this.paymentMode,
        this.comment,
        this.status,
        this.mailCount,
        this.sendTime,
        this.modify,
        this.transactionType,
        this.createdOn,
        this.utrNo,
        this.refferalDiscount});

  InvoiceDetails.fromJson(Map<String, dynamic> json) {
    invoiceId = json['invoice_id'];
    bookingId = json['booking_id'];
    paymentId = json['payment_id'];
    amountStatus = json['amount_status'];
    durationPeriod = json['duration_period'];
    mailStatus = json['mail_status'];
    reminderMail = json['reminder_mail'];
    amountRecieved = json['amount_recieved'];
    amount = json['amount'];
    totalAmount = json['total_amount'];
    disc = json['disc'];
    fromDate = json['from_date'];
    tillDate = json['till_date'];
    pendingBalance = json['pending_balance'];
    paymentMode = json['payment_mode'];
    comment = json['comment'];
    status = json['status'];
    mailCount = json['mail_count'];
    sendTime = json['send_time'];
    modify = json['modify'];
    transactionType = json['Transaction_Type'];
    createdOn = json['Created_on'];
    utrNo = json['utr_no'];
    refferalDiscount = json['refferal_discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['invoice_id'] = invoiceId;
    data['booking_id'] = bookingId;
    data['payment_id'] = paymentId;
    data['amount_status'] = amountStatus;
    data['duration_period'] = durationPeriod;
    data['mail_status'] = mailStatus;
    data['reminder_mail'] = reminderMail;
    data['amount_recieved'] = amountRecieved;
    data['amount'] = amount;
    data['total_amount'] = totalAmount;
    data['disc'] = disc;
    data['from_date'] = fromDate;
    data['till_date'] = tillDate;
    data['pending_balance'] = pendingBalance;
    data['payment_mode'] = paymentMode;
    data['comment'] = comment;
    data['status'] = status;
    data['mail_count'] = mailCount;
    data['send_time'] = sendTime;
    data['modify'] = modify;
    data['Transaction_Type'] = transactionType;
    data['Created_on'] = createdOn;
    data['utr_no'] = utrNo;
    data['refferal_discount'] = refferalDiscount;
    return data;
  }
}