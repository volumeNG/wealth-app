class UsdRate {
  int? statusCode;
  bool? success;
  String? message;
  Data? data;

  UsdRate({this.statusCode, this.success, this.message, this.data});

  UsdRate.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? dollarRate;

  Data({this.dollarRate});

  Data.fromJson(Map<String, dynamic> json) {
    dollarRate = json['dollarRate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dollarRate'] = this.dollarRate;
    return data;
  }
}
