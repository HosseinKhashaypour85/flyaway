class HomeRowTicketModel {
  HomeRowTicketModel({
      this.items, 
      this.page, 
      this.perPage, 
      this.totalItems, 
      this.totalPages,});

  HomeRowTicketModel.fromJson(dynamic json) {
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items?.add(Items.fromJson(v));
      });
    }
    page = json['page'];
    perPage = json['perPage'];
    totalItems = json['totalItems'];
    totalPages = json['totalPages'];
  }
  List<Items>? items;
  int? page;
  int? perPage;
  int? totalItems;
  int? totalPages;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (items != null) {
      map['items'] = items?.map((v) => v.toJson()).toList();
    }
    map['page'] = page;
    map['perPage'] = perPage;
    map['totalItems'] = totalItems;
    map['totalPages'] = totalPages;
    return map;
  }

}

class Items {
  Items({
      this.collectionId, 
      this.collectionName, 
      this.id, 
      this.imageUrl, 
      this.ticketTitle,});

  Items.fromJson(dynamic json) {
    collectionId = json['collectionId'];
    collectionName = json['collectionName'];
    id = json['id'];
    imageUrl = json['image_url'];
    ticketTitle = json['ticket_title'];
  }
  String? collectionId;
  String? collectionName;
  String? id;
  String? imageUrl;
  String? ticketTitle;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['collectionId'] = collectionId;
    map['collectionName'] = collectionName;
    map['id'] = id;
    map['image_url'] = imageUrl;
    map['ticket_title'] = ticketTitle;
    return map;
  }

}