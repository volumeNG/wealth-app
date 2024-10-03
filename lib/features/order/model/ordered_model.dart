import 'package:wealth/features/flipping/models/FlippingModel.dart';

import '../../crowd_funding/models/Property.dart';

class OrderedModel {
  String? id;
  bool? isPaid;
  int? amount;
  dynamic propertyId;
  String? crowdFundId;
  dynamic flippingId;
  String? refName;
  dynamic bankName;
  dynamic bankAccountNumber;
  dynamic paymentReceiptUrl;
  String? paystackId;
  String? paystackUrl;
  dynamic wealthBankId;
  String? orderById;
  String? createdAt;
  String? updatedAt;
  String? status;
  String? paymentType;
  Property? crowdFund;
  FlippingModel? flipping;
  Property? property;
  dynamic wealthBank;
  OrderBy? orderBy;

  OrderedModel(
      {this.id,
      this.isPaid,
      this.amount,
      this.propertyId,
      this.crowdFundId,
      this.flippingId,
      this.refName,
      this.bankName,
      this.bankAccountNumber,
      this.paymentReceiptUrl,
      this.paystackId,
      this.paystackUrl,
      this.wealthBankId,
      this.orderById,
      this.createdAt,
      this.updatedAt,
      this.status,
      this.paymentType,
      this.crowdFund,
      this.flipping,
      this.property,
      this.wealthBank,
      this.orderBy});

  OrderedModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isPaid = json['isPaid'];
    amount = json['amount'];
    propertyId = json['propertyId'];
    crowdFundId = json['crowdFundId'];
    flippingId = json['flippingId'];
    refName = json['refName'];
    bankName = json['bankName'];
    bankAccountNumber = json['bankAccountNumber'];
    paymentReceiptUrl = json['paymentReceiptUrl'];
    paystackId = json['paystackId'];
    paystackUrl = json['paystackUrl'];
    wealthBankId = json['wealthBankId'];
    orderById = json['orderById'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    status = json['status'];
    paymentType = json['paymentType'];
    crowdFund =
        json['crowdFund'] != null ? Property.fromJson(json['crowdFund']) : null;
    flipping = json['flipping'] != null
        ? FlippingModel.fromJson(json['flipping'])
        : null;
    property =
        json['property'] != null ? Property.fromJson(json['property']) : null;
    wealthBank = json['wealthBank'];
    orderBy =
        json['orderBy'] != null ? new OrderBy.fromJson(json['orderBy']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['isPaid'] = this.isPaid;
    data['amount'] = this.amount;
    data['propertyId'] = this.propertyId;
    data['crowdFundId'] = this.crowdFundId;
    data['flippingId'] = this.flippingId;
    data['refName'] = this.refName;
    data['bankName'] = this.bankName;
    data['bankAccountNumber'] = this.bankAccountNumber;
    data['paymentReceiptUrl'] = this.paymentReceiptUrl;
    data['paystackId'] = this.paystackId;
    data['paystackUrl'] = this.paystackUrl;
    data['wealthBankId'] = this.wealthBankId;
    data['orderById'] = this.orderById;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['status'] = this.status;
    data['paymentType'] = this.paymentType;
    if (this.crowdFund != null) {
      data['crowdFund'] = this.crowdFund!.toJson();
    }
    data['flipping'] = this.flipping;
    data['property'] = this.property;
    data['wealthBank'] = this.wealthBank;
    if (this.orderBy != null) {
      data['orderBy'] = this.orderBy!.toJson();
    }
    return data;
  }
}

class Location {
  String? id;
  String? name;
  String? imgUrl;
  String? createdAt;
  String? updatedAt;

  Location({this.id, this.name, this.imgUrl, this.createdAt, this.updatedAt});

  Location.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    imgUrl = json['imgUrl'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['imgUrl'] = this.imgUrl;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class OrderBy {
  String? email;
  String? id;
  String? name;
  String? profileImg;

  OrderBy({this.email, this.id, this.name, this.profileImg});

  OrderBy.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    id = json['id'];
    name = json['name'];
    profileImg = json['profileImg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['id'] = this.id;
    data['name'] = this.name;
    data['profileImg'] = this.profileImg;
    return data;
  }
}
