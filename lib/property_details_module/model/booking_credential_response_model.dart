class BookingCredentialResponseModel {
  String? status;
  Data? data;

  BookingCredentialResponseModel({this.status, this.data});

  BookingCredentialResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? description;
  String? key;
  int? amount;
  String? currency;
  String? name;
  String? image;
  String? orderId;
  Prefill? prefill;
  Notes? notes;
  Theme? theme;
  String? successUrl;
  String? errorUrl;
  String? redirect_api;

  Data(
      {this.description,
        this.key,
        this.amount,
        this.currency,
        this.name,
        this.image,
        this.redirect_api,
        this.orderId,
        this.prefill,
        this.notes,
        this.theme,
        this.successUrl,
        this.errorUrl});

  Data.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    key = json['key'];
    amount = json['amount'];
    currency = json['currency'];
    name = json['name'];
    image = json['image'];
    orderId = json['order_id'];
    redirect_api=json['redirect_api'];
    prefill =
    json['prefill'] != null ? new Prefill.fromJson(json['prefill']) : null;
    notes = json['notes'] != null ? new Notes.fromJson(json['notes']) : null;
    theme = json['theme'] != null ? new Theme.fromJson(json['theme']) : null;
    successUrl = json['success_url'];
    errorUrl = json['error_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['key'] = this.key;
    data['amount'] = this.amount;
   data['redirect_api']=this.redirect_api;
    data['currency'] = this.currency;
    data['name'] = this.name;
    data['image'] = this.image;
    data['order_id'] = this.orderId;
    if (this.prefill != null) {
      data['prefill'] = this.prefill!.toJson();
    }
    if (this.notes != null) {
      data['notes'] = this.notes!.toJson();
    }
    if (this.theme != null) {
      data['theme'] = this.theme!.toJson();
    }
    data['success_url'] = this.successUrl;
    data['error_url'] = this.errorUrl;
    return data;
  }
}

class Prefill {
  String? name;
  String? email;
  String? contact;

  Prefill({this.name, this.email, this.contact});

  Prefill.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    contact = json['contact'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['contact'] = this.contact;
    return data;
  }
}

class Notes {
  bool? address;
  dynamic merchantOrderId;

  Notes({this.address, this.merchantOrderId});

  Notes.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    merchantOrderId = json['merchant_order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['merchant_order_id'] = this.merchantOrderId;
    return data;
  }
}

class Theme {
  String? color;

  Theme({this.color});

  Theme.fromJson(Map<String, dynamic> json) {
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['color'] = this.color;
    return data;
  }
}