class BookingAmountsResponseModel {
  String? maxAllowMsg;
  String? msg2;
  dynamic nights;
  dynamic dailyRent;
  String? msg1;
  String? msg;
  String? avlDate;
  String? avlDateApp;
  String? userMsg;
  dynamic couponDiscount;
  dynamic refferalDiscount;
  dynamic totalAmount;
  dynamic totalTaxes;
  String? message;
  dynamic totalAfterDiscount;
  dynamic deposit;
  dynamic serviceCharges;
  dynamic taxesCharges;
  dynamic totalAmountAfterTax;
  dynamic amountPayable;
  dynamic amountRemaining;
  dynamic tax;
  dynamic refferalCode;
  String? status;

  BookingAmountsResponseModel(
      {this.maxAllowMsg,
        this.msg2,
        this.nights,
        this.dailyRent,
        this.msg1,
        this.msg,
        this.avlDate,
        this.avlDateApp,
        this.userMsg,
        this.couponDiscount,
        this.refferalDiscount,
        this.totalAmount,
        this.totalTaxes,
        this.message,
        this.totalAfterDiscount,
        this.deposit,
        this.serviceCharges,
        this.taxesCharges,
        this.totalAmountAfterTax,
        this.amountPayable,
        this.amountRemaining,
        this.tax,
        this.refferalCode,
        this.status});

  BookingAmountsResponseModel.fromJson(Map<String, dynamic> json) {
    maxAllowMsg = json['max_allow_msg'];
    msg2 = json['msg2'];
    nights = json['nights'];
    dailyRent = json['daily_rent'];
    msg1 = json['msg1'];
    msg = json['msg'];
    avlDate = json['avl_date'];
    avlDateApp = json['avl_date_app'];
    userMsg = json['user_msg'];
    couponDiscount = json['coupon_discount'];
    refferalDiscount = json['refferal_discount'];
    totalAmount = json['total_amount'];
    totalTaxes = json['total_taxes'];
    message = json['message'];
    totalAfterDiscount = json['total_after_discount'];
    deposit = json['deposit'];
    serviceCharges = json['service_charges'];
    taxesCharges = json['taxes_charges'];
    totalAmountAfterTax = json['total_amount_after_tax'];
    amountPayable = json['amount_payable'];
    amountRemaining = json['amount_remaining'];
    tax = json['tax'];
    refferalCode = json['refferal_code'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['max_allow_msg'] = this.maxAllowMsg;
    data['msg2'] = this.msg2;
    data['nights'] = this.nights;
    data['daily_rent'] = this.dailyRent;
    data['msg1'] = this.msg1;
    data['msg'] = this.msg;
    data['avl_date'] = this.avlDate;
    data['avl_date_app'] = this.avlDateApp;
    data['user_msg'] = this.userMsg;
    data['coupon_discount'] = this.couponDiscount;
    data['refferal_discount'] = this.refferalDiscount;
    data['total_amount'] = this.totalAmount;
    data['total_taxes'] = this.totalTaxes;
    data['message'] = this.message;
    data['total_after_discount'] = this.totalAfterDiscount;
    data['deposit'] = this.deposit;
    data['service_charges'] = this.serviceCharges;
    data['taxes_charges'] = this.taxesCharges;
    data['total_amount_after_tax'] = this.totalAmountAfterTax;
    data['amount_payable'] = this.amountPayable;
    data['amount_remaining'] = this.amountRemaining;
    data['tax'] = this.tax;
    data['refferal_code'] = this.refferalCode;
    data['status'] = this.status;
    return data;
  }
}