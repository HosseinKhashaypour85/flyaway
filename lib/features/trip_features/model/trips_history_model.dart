class TripsHistoryModel {
  TripsHistoryModel({
      this.tickets,});

  TripsHistoryModel.fromJson(dynamic json) {
    if (json['tickets'] != null) {
      tickets = [];
      json['tickets'].forEach((v) {
        tickets?.add(Tickets.fromJson(v));
      });
    }
  }
  List<Tickets>? tickets;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (tickets != null) {
      map['tickets'] = tickets?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Tickets {
  Tickets({
      this.id, 
      this.buyerEmail, 
      this.origin, 
      this.destination, 
      this.ticketTime, 
      this.amountPaid, 
      this.ticketType, 
      this.passengersAmount,});

  Tickets.fromJson(dynamic json) {
    id = json['id'];
    buyerEmail = json['buyer_email'];
    origin = json['origin'];
    destination = json['destination'];
    ticketTime = json['ticket_time'];
    amountPaid = json['amount_paid'];
    ticketType = json['ticket_type'];
    passengersAmount = json['passengers_amount'];
  }
  int? id;
  String? buyerEmail;
  String? origin;
  String? destination;
  String? ticketTime;
  String? amountPaid;
  String? ticketType;
  int? passengersAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['buyer_email'] = buyerEmail;
    map['origin'] = origin;
    map['destination'] = destination;
    map['ticket_time'] = ticketTime;
    map['amount_paid'] = amountPaid;
    map['ticket_type'] = ticketType;
    map['passengers_amount'] = passengersAmount;
    return map;
  }

}