class NewProperty {
  String? thumbnailUrl;
  String? title;
  String? description;
  String? propertySize;
  double? price;
  int? rooms;
  String? streetLocation;
  String? videoUrl;
  String? emergencyEmail;
  String? emergencyContact;
  List<String>? images;
  String? location;
  String? type;

  NewProperty(
      {this.thumbnailUrl,
      this.title,
      this.description,
      this.propertySize,
      this.price = 0,
      this.streetLocation,
      this.videoUrl,
      this.emergencyEmail,
      this.emergencyContact,
      this.images,
      this.location,
        this.rooms = 0,
      this.type});
}
