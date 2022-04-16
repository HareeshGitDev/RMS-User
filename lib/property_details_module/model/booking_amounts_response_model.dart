class BookingAmountsResponseModel {
  String? msg;
  Data? data;

  BookingAmountsResponseModel({this.msg, this.data});

  BookingAmountsResponseModel.fromJson(Map<String, dynamic> json) {
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
  int? cartId;
  dynamic rent;
  dynamic deposit;
  dynamic couponDiscount;
  dynamic refferalCode;
  dynamic refferalDiscount;
  dynamic totalAmount;
  dynamic advanceAmount;
  dynamic pendingAmount;
  String? userMsg;
  int? nights;

  Data(
      {this.cartId,
        this.rent,
        this.deposit,
        this.couponDiscount,
        this.refferalCode,
        this.refferalDiscount,
        this.totalAmount,
        this.advanceAmount,
        this.pendingAmount,
        this.nights,
        this.userMsg});

  Data.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    rent = json['rent'];
    deposit = json['deposit'];
    couponDiscount = json['coupon_discount'];
    refferalCode = json['refferal_code'];
    refferalDiscount = json['refferal_discount'];
    totalAmount = json['total_amount'];
    advanceAmount = json['advance_amount'];
    pendingAmount = json['pending_amount'];
    userMsg = json['user_msg'];
    nights = json['nights'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cart_id'] = this.cartId;
    data['rent'] = this.rent;
    data['deposit'] = this.deposit;
    data['coupon_discount'] = this.couponDiscount;
    data['refferal_code'] = this.refferalCode;
    data['refferal_discount'] = this.refferalDiscount;
    data['total_amount'] = this.totalAmount;
    data['advance_amount'] = this.advanceAmount;
    data['pending_amount'] = this.pendingAmount;
    data['user_msg'] = this.userMsg;
    data['nights'] = this.nights;
    return data;
  }
}
