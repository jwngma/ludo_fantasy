class AppStatus {
  String payment_status;
  String status_message;
  String first_message;
  String second_message;

  AppStatus(this.payment_status, this.status_message, this.first_message,
      this.second_message);

  Map toMap(AppStatus users) {
    var data = Map<String, dynamic>();
    data['payment_status'] = users.payment_status;
    data['status_message'] = users.status_message;
    data['first_message'] = users.first_message;
    data['second_message'] = users.second_message;
    return data;
  }

  AppStatus.fromMap(Map<String, dynamic> mapData) {
    this.payment_status = mapData['payment_status'];
    this.status_message = mapData['status_message'];
    this.first_message = mapData['first_message'];
    this.second_message = mapData['second_message'];
  }
}
