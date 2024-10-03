class Profile {
  String? id;
  String? name;
  String? email;
  String? phoneNumber;
  dynamic? dateOfBirth;
  dynamic? location;
  dynamic? gender;
  String? createdAt;
  String? updatedAt;
  String? role;
  String? profileImg;
  bool? isVerified;
  dynamic? isBlocked;
  bool? isChampion;
  String? status;
  dynamic? deviceNotificationToken;
  dynamic? txId;
  bool? isPaid;
  bool? shouldSendNotification;

  Profile(
      {this.id,
      this.name,
      this.email,
      this.phoneNumber,
      this.dateOfBirth,
      this.location,
      this.gender,
      this.createdAt,
      this.updatedAt,
      this.role,
      this.profileImg,
      this.isVerified,
      this.isBlocked,
      this.isChampion,
      this.status,
      this.deviceNotificationToken,
      this.txId,
      this.isPaid,
      this.shouldSendNotification});

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    dateOfBirth = json['dateOfBirth'];
    location = json['location'];
    gender = json['gender'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    role = json['role'];
    profileImg = json['profileImg'];
    isVerified = json['isVerified'];
    isBlocked = json['isBlocked'];
    isChampion = json['isChampion'];
    status = json['status'];
    deviceNotificationToken = json['deviceNotificationToken'];
    txId = json['txId'];
    isPaid = json['isPaid'];
    shouldSendNotification = json['shouldSendNotification'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    data['dateOfBirth'] = this.dateOfBirth;
    data['location'] = this.location;
    data['gender'] = this.gender;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['role'] = this.role;
    data['profileImg'] = this.profileImg;
    data['isVerified'] = this.isVerified;
    data['isBlocked'] = this.isBlocked;
    data['isChampion'] = this.isChampion;
    data['status'] = this.status;
    data['deviceNotificationToken'] = this.deviceNotificationToken;
    data['txId'] = this.txId;
    data['isPaid'] = this.isPaid;
    data['shouldSendNotification'] = this.shouldSendNotification;
    return data;
  }
}
