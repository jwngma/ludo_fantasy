class Transactions {
  String id;
  String txnId;
  String status;
  String responseCode;
  String referenceId;
  String approvalNo;
  String title;
  String amount;
  String type;
  String time;

  Transactions(
      {this.id,
      this.txnId,
      this.status,
      this.responseCode,
      this.referenceId,
      this.approvalNo,
      this.title,
      this.amount,
      this.type,
      this.time});

  Transactions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    txnId = json['txnId'];
    status = json['status'];
    responseCode = json['responseCode'];
    referenceId = json['referenceId'];
    approvalNo = json['approvalNo'];
    title = json['title'];
    amount = json['amount'];
    type = json['type'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['txnId'] = this.txnId;
    data['status'] = this.status;
    data['responseCode'] = this.responseCode;
    data['referenceId'] = this.referenceId;
    data['approvalNo'] = this.approvalNo;
    data['title'] = this.title;
    data['amount'] = this.amount;
    data['type'] = this.type;
    data['time'] = this.time;
    return data;
  }
}
