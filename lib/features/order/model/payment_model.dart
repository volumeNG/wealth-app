class PaymnetModel {
  String? id;
  bool? isPaid;
  int? amount;
  dynamic? propertyId;
  String? crowdFundId;
  dynamic? flippingId;
  String? refName;
  dynamic? bankName;
  dynamic? bankAccountNumber;
  dynamic? paymentReceiptUrl;
  String? paystackId;
  String? paystackUrl;
  dynamic? wealthBankId;
  String? orderById;
  String? createdAt;
  String? updatedAt;
  String? status;
  String? paymentType;

  PaymnetModel(
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
      this.paymentType});

  PaymnetModel.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
