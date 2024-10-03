class FAQ {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? question;
  String? ans;

  FAQ({this.id, this.createdAt, this.updatedAt, this.question, this.ans});

  FAQ.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    question = json['question'];
    ans = json['ans'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['question'] = this.question;
    data['ans'] = this.ans;
    return data;
  }
}
