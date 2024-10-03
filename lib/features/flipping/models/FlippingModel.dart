class FlippingModel {
  String? id;
  String? thumbnail;
  String? title;
  String? description;
  dynamic? rooms;
  String? size;
  dynamic? floor;
  int? price;
  String? streetLocation;
  String? videoUrl;
  List<String>? images;
  List<String>? docs;
  String? type;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? ownById;
  String? location;
  String? emergencyContact;
  String? emergencyEmail;
  List<Orders>? orders;

  FlippingModel(
      {this.id,
        this.thumbnail,
        this.title,
        this.description,
        this.rooms,
        this.size,
        this.floor,
        this.price,
        this.streetLocation,
        this.videoUrl,
        this.images,
        this.docs,
        this.type,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.ownById,
        this.location,
        this.emergencyContact,
        this.emergencyEmail,
        this.orders});

  FlippingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    thumbnail = json['thumbnail'];
    title = json['title'];
    description = json['description'];
    rooms = json['rooms'];
    size = json['size'];
    floor = json['floor'];
    price = json['price'];
    streetLocation = json['streetLocation'];
    videoUrl = json['videoUrl'];
    images = json['images'].cast<String>();
    docs = json['docs'].cast<String>();
    type = json['type'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    ownById = json['ownById'];
    location = json['location'];
    emergencyContact = json['emergencyContact'];
    emergencyEmail = json['emergencyEmail'];
    if (json['Orders'] != null) {
      orders = <Orders>[];
      json['Orders'].forEach((v) {
        orders!.add(new Orders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['thumbnail'] = this.thumbnail;
    data['title'] = this.title;
    data['description'] = this.description;
    data['rooms'] = this.rooms;
    data['size'] = this.size;
    data['floor'] = this.floor;
    data['price'] = this.price;
    data['streetLocation'] = this.streetLocation;
    data['videoUrl'] = this.videoUrl;
    data['images'] = this.images;
    data['docs'] = this.docs;
    data['type'] = this.type;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['ownById'] = this.ownById;
    data['location'] = this.location;
    data['emergencyContact'] = this.emergencyContact;
    data['emergencyEmail'] = this.emergencyEmail;
    if (this.orders != null) {
      data['Orders'] = this.orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orders {
  OrderBy? orderBy;

  Orders({this.orderBy});

  Orders.fromJson(Map<String, dynamic> json) {
    orderBy =
    json['orderBy'] != null ? new OrderBy.fromJson(json['orderBy']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderBy != null) {
      data['orderBy'] = this.orderBy!.toJson();
    }
    return data;
  }
}

class OrderBy {
  String? email;
  String? id;
  String? profileImg;
  String? name;

  OrderBy({this.email, this.id, this.profileImg, this.name});

  OrderBy.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    id = json['id'];
    profileImg = json['profileImg'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['id'] = this.id;
    data['profileImg'] = this.profileImg;
    data['name'] = this.name;
    return data;
  }
}
