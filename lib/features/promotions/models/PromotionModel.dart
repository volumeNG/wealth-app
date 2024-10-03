class PromotionModel {
  String? id;
  String? date;
  String? title;
  String? streetLocation;
  String? thumbnail;
  String? location;
  String? description;
  List<Interesteds>? interesteds;

  PromotionModel(
      {this.id,
        this.date,
        this.title,
        this.streetLocation,
        this.thumbnail,
        this.location,
        this.description,
        this.interesteds});

  PromotionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    title = json['title'];
    streetLocation = json['streetLocation'];
    description = json['description'];
    thumbnail = json['thumbnail'];
    location = json['location'];
    if (json['interesteds'] != null) {
      interesteds = <Interesteds>[];
      json['interesteds'].forEach((v) {
        interesteds!.add(new Interesteds.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['title'] = this.title;
    data['streetLocation'] = this.streetLocation;
    data['description'] = this.description;
    data['thumbnail'] = this.thumbnail;
    data['location'] = this.location;
    if (this.interesteds != null) {
      data['interesteds'] = this.interesteds!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Interesteds {
  OwnBy? ownBy;

  Interesteds({this.ownBy});

  Interesteds.fromJson(Map<String, dynamic> json) {
    ownBy = json['ownBy'] != null ? new OwnBy.fromJson(json['ownBy']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ownBy != null) {
      data['ownBy'] = this.ownBy!.toJson();
    }
    return data;
  }
}

class OwnBy {
  String? profileImg;
  String? id;

  OwnBy({this.profileImg, this.id});

  OwnBy.fromJson(Map<String, dynamic> json) {
    profileImg = json['profileImg'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profileImg'] = this.profileImg;
    data['id'] = this.id;
    return data;
  }
}
