class MessageBox {
  String? id;
  String? chatGroupId;
  String? text;
  dynamic? image;
  String? replyId;
  String? sendById;
  String? createdAt;
  String? updatedAt;
  Reply? reply;
  SendBy? sendBy;

  MessageBox(
      {this.id,
      this.chatGroupId,
      this.text,
      this.image,
      this.replyId,
      this.sendById,
      this.createdAt,
      this.updatedAt,
      this.reply,
      this.sendBy});

  MessageBox.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chatGroupId = json['chatGroupId'];
    text = json['text'];
    image = json['image'];
    replyId = json['replyId'];
    sendById = json['sendById'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    reply = json['reply'] != null ? new Reply.fromJson(json['reply']) : null;
    sendBy =
        json['sendBy'] != null ? new SendBy.fromJson(json['sendBy']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['chatGroupId'] = this.chatGroupId;
    data['text'] = this.text;
    data['image'] = this.image;
    data['replyId'] = this.replyId;
    data['sendById'] = this.sendById;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.reply != null) {
      data['reply'] = this.reply!.toJson();
    }
    if (this.sendBy != null) {
      data['sendBy'] = this.sendBy!.toJson();
    }
    return data;
  }
}

class Reply {
  String? id;
  String? chatGroupId;
  String? text;
  dynamic? image;
  dynamic? replyId;
  String? sendById;
  String? createdAt;
  String? updatedAt;
  SendBy? sendBy;

  Reply(
      {this.id,
      this.chatGroupId,
      this.text,
      this.image,
      this.replyId,
      this.sendById,
      this.createdAt,
      this.updatedAt,
      this.sendBy});

  Reply.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chatGroupId = json['chatGroupId'];
    text = json['text'];
    image = json['image'];
    replyId = json['replyId'];
    sendById = json['sendById'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    sendBy =
        json['sendBy'] != null ? new SendBy.fromJson(json['sendBy']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['chatGroupId'] = this.chatGroupId;
    data['text'] = this.text;
    data['image'] = this.image;
    data['replyId'] = this.replyId;
    data['sendById'] = this.sendById;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.sendBy != null) {
      data['sendBy'] = this.sendBy!.toJson();
    }
    return data;
  }
}

class SendBy {
  String? email;
  String? id;
  String? name;
  String? role;
  dynamic? isChampion;
  String? profileImg;

  SendBy(
      {this.email,
      this.id,
      this.name,
      this.role,
      this.isChampion,
      this.profileImg});

  SendBy.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    id = json['id'];
    name = json['name'];
    role = json['role'];
    isChampion = json['isChampion'];
    profileImg = json['profileImg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['id'] = this.id;
    data['name'] = this.name;
    data['role'] = this.role;
    data['isChampion'] = this.isChampion;
    data['profileImg'] = this.profileImg;
    return data;
  }
}
