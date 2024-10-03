class CurrentFavourite {
  String? id;
  String? ownById;
  String? propertyId;
  Property? property;

  CurrentFavourite({this.id, this.ownById, this.propertyId, this.property});

  CurrentFavourite.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ownById = json['ownById'];
    propertyId = json['propertyId'];
    property = json['property'] != null
        ? new Property.fromJson(json['property'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ownById'] = this.ownById;
    data['propertyId'] = this.propertyId;
    if (this.property != null) {
      data['property'] = this.property!.toJson();
    }
    return data;
  }
}

class Property {
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
  String? locationId;
  String? createdAt;
  String? status;
  String? updatedAt;
  String? type;

  Property(
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
        this.locationId,
        this.createdAt,
        this.status,
        this.updatedAt,
        this.type});

  Property.fromJson(Map<String, dynamic> json) {
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
    locationId = json['locationId'];
    createdAt = json['createdAt'];
    status = json['status'];
    updatedAt = json['updatedAt'];
    type = json['type'];
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
    data['locationId'] = this.locationId;
    data['createdAt'] = this.createdAt;
    data['status'] = this.status;
    data['updatedAt'] = this.updatedAt;
    data['type'] = this.type;
    return data;
  }
}
