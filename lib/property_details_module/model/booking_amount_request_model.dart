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
  String? depositAmount;
  String? invoiceId;
  String? bookingId;

  BookingAmountRequestModel(
      {this.propId,
      this.token,
      this.couponCode,
      this.fromDate,
      this.numOfGuests,
      this.toDate,
      this.phone,
      this.email,
        this.address,
      this.name,
      this.depositAmount,
      this.invoiceId,
        this.bookingId,
      this.paymentGateway = 'razorpay'});
}
