class RefundSplitUpModel {
  String? msg;
  Data? data;

  RefundSplitUpModel({this.msg, this.data});

  RefundSplitUpModel.fromJson(Map<String, dynamic> json) {
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
  dynamic depositReceived;
  dynamic depositRefund;
  List<Adjustments>? adjustments;

  Data({this.depositReceived, this.depositRefund, this.adjustments});

  Data.fromJson(Map<String, dynamic> json) {
    depositReceived = json['deposit_received'];
    depositRefund = json['deposit_refund'];
    if (json['adjustments'] != null) {
      adjustments = <Adjustments>[];
      json['adjustments'].forEach((v) {
        adjustments!.add(new Adjustments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deposit_received'] = this.depositReceived;
    data['deposit_refund'] = this.depositRefund;
    if (this.adjustments != null) {
      data['adjustments'] = this.adjustments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Adjustments {
  String? invoiceId;
  String? transactionType;
  String? fromDate;
  String? tillDate;
  String? status;
  String? payable;
  String? paid;
  String? adjustedInDeposit;

  Adjustments(
      {this.invoiceId,
        this.transactionType,
        this.fromDate,
        this.tillDate,
        this.status,
        this.payable,
        this.paid,
        this.adjustedInDeposit});

  Adjustments.fromJson(Map<String, dynamic> json) {
    invoiceId = json['invoice_id'];
    transactionType = json['transaction_type'];
    fromDate = json['from_date'];
    tillDate = json['till_date'];
    status = json['status'];
    payable = json['payable'];
    paid = json['paid'];
    adjustedInDeposit = json['adjusted_in_deposit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['invoice_id'] = this.invoiceId;
    data['transaction_type'] = this.transactionType;
    data['from_date'] = this.fromDate;
    data['till_date'] = this.tillDate;
    data['status'] = this.status;
    data['payable'] = this.payable;
    data['paid'] = this.paid;
    data['adjusted_in_deposit'] = this.adjustedInDeposit;
    return data;
  }
}