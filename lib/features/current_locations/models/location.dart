class CurrentLocationModel {
  String? id;
  String? name;
  String? imgUrl;
  String? createdAt;
  String? updatedAt;
  Count? cCount;

  CurrentLocationModel(
      {this.id,
        this.name,
        this.imgUrl,
        this.createdAt,
        this.updatedAt,
        this.cCount});

  CurrentLocationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    imgUrl = json['imgUrl'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    cCount = json['_count'] != null ? new Count.fromJson(json['_count']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['imgUrl'] = this.imgUrl;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.cCount != null) {
      data['_count'] = this.cCount!.toJson();
    }
    return data;
  }
}

class Count {
  int? property;
  int? crowdFund;

  Count({this.property, this.crowdFund});

  Count.fromJson(Map<String, dynamic> json) {
    property = json['property'];
    crowdFund = json['crowdFund'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['property'] = this.property;
    data['crowdFund'] = this.crowdFund;
    return data;
  }
}
