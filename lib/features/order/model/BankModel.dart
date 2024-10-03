// class BankModel {
//   String? id;
//   String? name;
//   String? accountNumber;
//   String? accountName;
//   String? createdAt;
//   String? updatedAt;
//   String? typeOfBank;
//   String? logoOfBank;
//
//   BankModel(
//       {this.id,
//         this.name,
//         this.accountNumber,
//         this.accountName,
//         this.createdAt,
//         this.updatedAt,
//         this.typeOfBank,
//         this.logoOfBank});
//
//   BankModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     accountNumber = json['accountNumber'];
//     accountName = json['accountName'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     typeOfBank = json['typeOfBank'];
//     logoOfBank = json['logoOfBank'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['accountNumber'] = this.accountNumber;
//     data['accountName'] = this.accountName;
//     data['createdAt'] = this.createdAt;
//     data['updatedAt'] = this.updatedAt;
//     data['typeOfBank'] = this.typeOfBank;
//     data['logoOfBank'] = this.logoOfBank;
//     return data;
//   }
// }


class BankModel {
  String? id;
  String? name;
  String? accountNumber;
  String? accountName;
  String? createdAt;
  String? updatedAt;
  String? bankAddress;
  String? shortCode;
  String? swiftCode;
  String? beneficiaryPhoneNumber;
  String? address;
  String? typeOfBank;
  String? logoOfBank;

  BankModel(
      {this.id,
        this.name,
        this.accountNumber,
        this.accountName,
        this.createdAt,
        this.updatedAt,
        this.bankAddress,
        this.shortCode,
        this.swiftCode,
        this.beneficiaryPhoneNumber,
        this.address,
        this.typeOfBank,
        this.logoOfBank});

  BankModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    accountNumber = json['accountNumber'];
    accountName = json['accountName'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    bankAddress = json['bankAddress'];
    shortCode = json['shortCode'];
    swiftCode = json['swiftCode'];
    beneficiaryPhoneNumber = json['beneficiaryPhoneNumber'];
    address = json['address'];
    typeOfBank = json['typeOfBank'];
    logoOfBank = json['logoOfBank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['accountNumber'] = this.accountNumber;
    data['accountName'] = this.accountName;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['bankAddress'] = this.bankAddress;
    data['shortCode'] = this.shortCode;
    data['swiftCode'] = this.swiftCode;
    data['beneficiaryPhoneNumber'] = this.beneficiaryPhoneNumber;
    data['address'] = this.address;
    data['typeOfBank'] = this.typeOfBank;
    data['logoOfBank'] = this.logoOfBank;
    return data;
  }
}
