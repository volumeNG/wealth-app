class ChatGroup {
  String? id;
  String? thumbnail;
  String? name;
  String? type;
  String? createdAt;
  String? updatedAt;

  ChatGroup(
      {this.id,
        this.thumbnail,
        this.name,
        this.type,
        this.createdAt,
        this.updatedAt});

  ChatGroup.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    thumbnail = json['thumbnail'];
    name = json['name'];
    type = json['type'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['thumbnail'] = this.thumbnail;
    data['name'] = this.name;
    data['type'] = this.type;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
