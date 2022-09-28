class BookingAmountRequestModel {
  String? propId;
  String? fromDate;
  String? toDate;
  String? token;
  String? couponCode;
  String? numOfGuests;
  String? email;
  String? name;
  String? address;
  String? paymentGateway;
  String? phone;
  String? cartId;
  String? depositAmount;
  String? invoiceId;
  String? bookingId;
String? bookingType;
  BookingAmountRequestModel(
      {this.propId,
      this.token,
        this.bookingType,
      this.couponCode,
      this.fromDate,
      this.numOfGuests,
      this.toDate,
      this.phone,
      this.email,
      this.address,
      this.cartId,
      this.name,
      this.depositAmount,
      this.invoiceId,
      this.bookingId,
      this.paymentGateway = 'razorpay'});
}
