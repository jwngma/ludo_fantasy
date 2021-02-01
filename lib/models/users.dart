class Users {
  String uid;
  String name;
  int amount;
  String email;
  String status;
  String phone_number;
  String profile_photo;
  int matchPlayed;

  Users({this.uid,
    this.name,
    this.email,
    this.status,
    this.amount,
    this.matchPlayed,
    this.phone_number,
    this.profile_photo});

  Map toMap(Users users) {
    var data = Map<String, dynamic>();
    data['uid'] = users.uid;
    data['name'] = users.name;
    data['phone_number'] = users.phone_number;
    data['email'] = users.email;
    data['status'] = users.status;
    data['amount'] = users.amount;
    data['matchPlayed'] = users.matchPlayed;
    data['profile_photo'] = users.profile_photo;

    return data;
  }

  Users.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.name = mapData['name'];
    this.email = mapData['email'];
    this.phone_number = mapData['phone_number'];
    this.status = mapData['status'];
    this.amount = mapData['amount'];
    this.matchPlayed = mapData['matchPlayed'];
    this.profile_photo = mapData['profile_photo'];
  }
}
