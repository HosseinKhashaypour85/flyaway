class HomeShowCommentsModel {
  HomeShowCommentsModel({
      this.comments,});

  HomeShowCommentsModel.fromJson(dynamic json) {
    if (json['comments'] != null) {
      comments = [];
      json['comments'].forEach((v) {
        comments?.add(Comments.fromJson(v));
      });
    }
  }
  List<Comments>? comments;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (comments != null) {
      map['comments'] = comments?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Comments {
  Comments({
      this.id, 
      this.userName, 
      this.rating, 
      this.comment, 
      this.createdAt,});

  Comments.fromJson(dynamic json) {
    id = json['id'];
    userName = json['user_name'];
    rating = json['rating'];
    comment = json['comment'];
    createdAt = json['created_at'];
  }
  int? id;
  String? userName;
  int? rating;
  String? comment;
  String? createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_name'] = userName;
    map['rating'] = rating;
    map['comment'] = comment;
    map['created_at'] = createdAt;
    return map;
  }

}