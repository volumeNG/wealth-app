class RecentlyFunded {
  String? id;
  String? thumbnail;
  String? title;
  String? description;
  dynamic rooms;
  String? size;
  dynamic floor;
  int? targetFund;
  int? fundRaised;
  String? streetLocation;
  String? videoUrl;
  String? type;
  List<String>? images;
  String? locationId;
  String? status;
  String? createdAt;
  String? updatedAt;
  Location? location;
  List<Orders>? orders;

  RecentlyFunded(
      {this.id,
      this.thumbnail,
      this.title,
      this.description,
      this.rooms,
      this.size,
      this.floor,
      this.targetFund,
      this.fundRaised,
      this.streetLocation,
      this.videoUrl,
      this.type,
      this.images,
      this.locationId,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.location,
      this.orders});

  RecentlyFunded.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    thumbnail = json['thumbnail'];
    title = json['title'];
    description = json['description'];
    rooms = json['rooms'];
    size = json['size'];
    floor = json['floor'];
    targetFund = json['targetFund'];
    fundRaised = json['fundRaised'];
    streetLocation = json['streetLocation'];
    videoUrl = json['videoUrl'];
    type = json['type'];
    images = json['images'].cast<String>();
    locationId = json['locationId'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
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
    data['targetFund'] = this.targetFund;
    data['fundRaised'] = this.fundRaised;
    data['streetLocation'] = this.streetLocation;
    data['videoUrl'] = this.videoUrl;
    data['type'] = this.type;
    data['images'] = this.images;
    data['locationId'] = this.locationId;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    if (this.orders != null) {
      data['Orders'] = this.orders!.map((v) => v.toJson()).toList();
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
