class BookingAmountRequestModel {
  String? propId;
  String? fromDate;
  String? toDate;
  String? token;
  String? couponCode;
  String? numOfGuests;
  String? email;
  String? name;
  String? paymentGateway;
  String? phone;
  String? depositAmount;

  BookingAmountRequestModel(
      {this.propId,
      this.token,
      this.couponCode,
      this.fromDate,
      this.numOfGuests,
      this.toDate,
      this.phone,
      this.email,
      this.name,
      this.depositAmount,
      this.paymentGateway = 'razorpay'});
}
