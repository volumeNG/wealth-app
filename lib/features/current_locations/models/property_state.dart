class PropertyData {
  String? id;
  String? time;
  int? price;
  String? createdAt;
  String? updatedAt;
  String? propertyId;

  PropertyData(
      {this.id,
        this.time,
        this.price,
        this.createdAt,
        this.updatedAt,
        this.propertyId});

  PropertyData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    time = json['time'];
    price = json['price'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    propertyId = json['propertyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['time'] = this.time;
    data['price'] = this.price;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['propertyId'] = this.propertyId;
    return data;
  }
}
