class CrowdfundFavourite {
  String? id;
  String? ownById;
  String? crowdFundId;
  CrowdFund? crowdFund;

  CrowdfundFavourite({this.id, this.ownById, this.crowdFundId, this.crowdFund});

  CrowdfundFavourite.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ownById = json['ownById'];
    crowdFundId = json['crowdFundId'];
    crowdFund = json['crowdFund'] != null
        ? new CrowdFund.fromJson(json['crowdFund'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ownById'] = this.ownById;
    data['crowdFundId'] = this.crowdFundId;
    if (this.crowdFund != null) {
      data['crowdFund'] = this.crowdFund!.toJson();
    }
    return data;
  }
}

class CrowdFund {
  String? id;
  String? thumbnail;
  String? title;
  String? description;
  int? rooms;
  String? size;
  dynamic? floor;
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

  CrowdFund(
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
        this.updatedAt});

  CrowdFund.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
