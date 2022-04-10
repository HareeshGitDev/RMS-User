class InvoiceDetailsModel {
  String? msg;
  List<Data>? data;

  InvoiceDetailsModel({this.msg, this.data});

  InvoiceDetailsModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['msg'] = msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? bookingId;
  String? invoiceId;
  String? transactionType;
  String? durationPeriod;
  String? amount;
  String? amountRecieved;
  int? pendingBalance;
  String? fromDate;
  String? tillDate;
  String? status;
  int? refferalDiscount;

  Data(
      {this.bookingId,
        this.invoiceId,
        this.transactionType,
        this.durationPeriod,
        this.amount,
        this.amountRecieved,
        this.pendingBalance,
        this.fromDate,
        this.tillDate,
        this.status,
        this.refferalDiscount});

  Data.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    invoiceId = json['invoice_id'];
    transactionType = json['Transaction_Type'];
    durationPeriod = json['duration_period'];
    amount = json['amount'];
    amountRecieved = json['amount_recieved'];
    pendingBalance = json['pending_balance'];
    fromDate = json['from_date'];
    tillDate = json['till_date'];
    status = json['status'];
    refferalDiscount = json['refferal_discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['booking_id'] = bookingId;
    data['invoice_id'] = invoiceId;
    data['Transaction_Type'] = transactionType;
    data['duration_period'] = durationPeriod;
    data['amount'] = amount;
    data['amount_recieved'] = amountRecieved;
    data['pending_balance'] = pendingBalance;
    data['from_date'] = fromDate;
    data['till_date'] = tillDate;
    data['status'] = status;
    data['refferal_discount'] = refferalDiscount;
    return data;
  }
}