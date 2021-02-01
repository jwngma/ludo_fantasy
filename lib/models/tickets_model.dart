class TicketModel {
  int randomNumber;
  int drawNumber;
  String hash;
  String name;
  String time;


  TicketModel(
      {this.randomNumber,
        this.drawNumber,
        this.name,
        this.time,
        this.hash});

  TicketModel.fromJson(Map<String, dynamic> json) {
    randomNumber = json['randomNumber'];
    drawNumber = json['drawNumber'];
    time = json['time'];
    name = json['name'];
    hash = json['hash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['randomNumber'] = this.randomNumber;
    data['drawNumber'] = this.drawNumber;
    data['name'] = this.name;
    data['time'] = this.time;
    data['hash'] = this.hash;

    return data;
  }
}
