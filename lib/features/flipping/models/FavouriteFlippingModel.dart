class FavouriteFlippingModel {
  String? id;
  String? thumbnail;
  String? title;
  String? description;
  dynamic rooms;
  String? size;
  dynamic floor;
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

  FavouriteFlippingModel(
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
      this.emergencyEmail});

  FavouriteFlippingModel.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
