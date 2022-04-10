class InvoicePaymentModel {
  String? msg;
  Data? data;

  InvoicePaymentModel({this.msg, this.data});

  InvoicePaymentModel.fromJson(Map<String, dynamic> json) {
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
  String? key;
  int? amount;
  String? currency;
  String? name;
  String? image;
  String? description;
  String? orderId;
  Prefill? prefill;
  Notes? notes;
  Theme? theme;
  String? callbackUrl;
  String? callbackApi;

  Data(
      {this.key,
        this.amount,
        this.currency,
        this.name,
        this.image,
        this.orderId,
        this.prefill,
        this.notes,
        this.theme,
        this.description,
        this.callbackUrl,
        this.callbackApi});

  Data.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    amount = json['amount'];
    currency = json['currency'];
    name = json['name'];
    image = json['image'];
    description = json['description'];
    orderId = json['order_id'];
    prefill =
    json['prefill'] != null ? new Prefill.fromJson(json['prefill']) : null;
    notes = json['notes'] != null ? new Notes.fromJson(json['notes']) : null;
    theme = json['theme'] != null ? new Theme.fromJson(json['theme']) : null;
    callbackUrl = json['callback_url'];
    callbackApi = json['callback_api'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['amount'] = this.amount;
    data['currency'] = this.currency;
    data['description'] = this.description;
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
    data['callback_url'] = this.callbackUrl;
    data['callback_api'] = this.callbackApi;
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
  dynamic merchantOrderId;

  Notes({this.merchantOrderId});

  Notes.fromJson(Map<String, dynamic> json) {
    merchantOrderId = json['merchant_order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
