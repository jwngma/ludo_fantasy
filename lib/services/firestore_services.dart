import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:ludofantasy/models/address_model.dart';
import 'package:ludofantasy/models/appStatus.dart';
import 'package:ludofantasy/models/eventModel.dart';
import 'package:ludofantasy/models/transactions.dart';
import 'package:ludofantasy/models/users.dart';
import 'package:ludofantasy/utils/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirestoreServices {
  Firestore _db = Firestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<List<DocumentSnapshot>> getEvents(String status,) async {
    List<DocumentSnapshot> _list = [];
    Query query = _db
        .collection(Constants.events)
        .where('status', isEqualTo: status)
        .orderBy("time", descending: false)
        .limit(30);
    QuerySnapshot querySnapshot = await query.getDocuments();
    _list = querySnapshot.documents;

    return _list;
  }

  Future<bool> getUserAlreadyparticipated(int gameId) async {
    final FirebaseUser user = await auth.currentUser();
    List<dynamic> usersList = [];
    bool participated = false;
    print("Game Id $gameId");
    await _db
        .collection(Constants.events)
        .document("ludo${gameId}")
        .get()
        .then((DocumentSnapshot) => DocumentSnapshot.data['participants'])
        .then((value) {
      usersList = value;
      if (usersList != null) {
        if (usersList.contains(user.uid)) {
          print("User Already Participated");
          participated = true;
        } else {
          print("Have to aprticipated");
          participated = false;
        }
      } else {
        print("No Paticipants yet");
        participated = false;
      }
    });

    return participated;
  }

  //participate user
  Future<bool> participateLudoEvent(EventModel eventModel, String ludoName,
      int entryFee, BuildContext context) async {
    final FirebaseUser user = await auth.currentUser();
    var respectsQuery = await _db
        .collection(Constants.events)
        .document("ludo${eventModel.gameId}")
        .collection("participants");
    var querySnapshot = await respectsQuery.getDocuments();
    var total_participated = querySnapshot.documents.length;
    print("Total" + total_participated.toString());

    print("Total Slots ${eventModel.totalPlayer}");

    if (total_participated <= eventModel.totalPlayer) {
      var userMap = Map<String, dynamic>();
      userMap['name'] = user.displayName;
      userMap['ludoName'] = ludoName;
      userMap['uid'] = user.uid;

      //decr amount from wallet
      await _db.collection(Constants.Users).document(user.uid).updateData({
        "amount": FieldValue.increment(-entryFee),
        "matchPlayed": FieldValue.increment(1),
      }).then((value) async {
        // add to db to Participation array for show in drawer
        await _db
            .collection(Constants.events)
            .document("${Constants.ludo}${eventModel.gameId}")
            .updateData({
          "participants": FieldValue.arrayUnion([user.uid]),
          "totalParticipated": FieldValue.increment(1),
        }).then((value) async {
          //participate
          await _db
              .collection(Constants.events)
              .document("${Constants.ludo}${eventModel.gameId}")
              .collection("participants")
              .document(user.uid)
              .setData(userMap);
        });
      }).catchError((error) {
        _showError(context, error);
      });

      return true;
    } else {
      showToast(
          "We have Reched The Max Limit, Please participate in the next Event",
          context: context,
          backgroundColor: Colors.green,
          duration: Duration(seconds: 5),
          position: StyledToastPosition(align: Alignment.center, offset: 20.0));

      return false;
    }
  }

  //get Ludo name
  Future getLudoName() async {
    final FirebaseUser user = await auth.currentUser();
    return await _db
        .collection(Constants.Users)
        .document(user.uid)
        .get()
        .then((DocumentSnapshot) => DocumentSnapshot.data['ludoName']);
  }

  //drawer my particapition
  Future getMyParticipationsEvents() async {
    return await _db
        .collection("Participations")
        .where('participants', arrayContains: Constants.prefs.getString("uid"))
        .orderBy("time", descending: true)
        .snapshots();
  }

  //drawer my particapition
  Future<List<DocumentSnapshot>> getMyContest(String status) async {
    final FirebaseUser user = await auth.currentUser();

    List<DocumentSnapshot> _list = [];

    Query query = _db
        .collection(Constants.events)
        .where('participants', arrayContains: user.uid)
        .where('status', isEqualTo: status)
        .orderBy("time", descending: true);
    QuerySnapshot querySnapshot = await query.getDocuments();
    _list = querySnapshot.documents;

    return _list;
  }

  // getting Notifications
  getNotifications() async {
    return await _db
        .collection("Notifications")
        .orderBy("time", descending: false)
        .snapshots();
  }

  Future<List<DocumentSnapshot>> getparticipatedusers(String gameId) async {
    List<DocumentSnapshot> _list = [];
    Query query = _db
        .collection(Constants.events)
        .document("ludo$gameId")
        .collection(Constants.participants);
    QuerySnapshot querySnapshot = await query.getDocuments();
    _list = querySnapshot.documents;

    return _list;
  }

  // getting the partipated user from the Eg Solo/ gameID/Paticipants
  getWinnerfortheEndedmatches(String gameType, String gameId) async {
    return await _db
        .collection(gameType)
        .document(gameId)
        .collection("winners")
        .snapshots();
  }

  // getting Group Message
  getGroupMessage() async {
    return await _db
        .collection("ludofantasyChat")
        .orderBy("time", descending: false)
        .snapshots();
  }

  // add group messge
  Future<void> addGroupMessage(String message, String name, String uid) async {
    var groupMap = Map<String, dynamic>();
    groupMap['message'] = message;
    groupMap['time'] = DateTime.now().toIso8601String();
    groupMap['name'] = name;
    groupMap['uid'] = uid;
    await _db.collection("ludofantasyChat").document().setData(groupMap);
  }

  Future<List<DocumentSnapshot>> getResults() async {
    List<DocumentSnapshot> _list = [];
    Query query =
    _db.collection("Events").orderBy("drawNumber", descending: true);
    QuerySnapshot querySnapshot = await query.getDocuments();
    _list = querySnapshot.documents;
    return _list;
  }

  Future<List<DocumentSnapshot>> getParticipationsTickets() async {
    final FirebaseUser user = await auth.currentUser();
    List<DocumentSnapshot> _list = [];
    Query query = _db
        .collection(Constants.Users)
        .document(user.uid)
        .collection("participations")
        .orderBy("drawNumber", descending: true);
    QuerySnapshot querySnapshot = await query.getDocuments();
    _list = querySnapshot.documents;
    return _list;
  }

  Future<List<DocumentSnapshot>> getWinners(String gameId) async {
    List<DocumentSnapshot> _list = [];
    Query query = _db
        .collection(Constants.events)
        .document("ludo$gameId")
        .collection(Constants.winner);

    QuerySnapshot querySnapshot = await query.getDocuments();
    _list = querySnapshot.documents;
    return _list;
  }

  // getting transaction done by the user
  getTransactions() async {
    final FirebaseUser user = await auth.currentUser();
    return await _db
        .collection(Constants.Users)
        .document(user.uid)
        .collection("transactions")
        .snapshots();
  }

  Future<List<DocumentSnapshot>> getTransactionss() async {
    final FirebaseUser user = await auth.currentUser();
    List<DocumentSnapshot> _list = [];
    Query query = _db
        .collection(Constants.Users)
        .document(user.uid)
        .collection("transactions")
        .orderBy("time", descending: false);

    QuerySnapshot querySnapshot = await query.getDocuments();
    _list = querySnapshot.documents;
    print(_list);
    return _list;
  }

  Future getAmount() async {
    final FirebaseUser user = await auth.currentUser();
    print("Get Points is called");
    return await _db
        .collection(Constants.Users)
        .document(user.uid)
        .get()
        .then((DocumentSnapshot) => DocumentSnapshot.data["amount"]);
  }

  Future getClicks(FirebaseUser currentUser) async {
    print("Get Clicks is called");
    return await _db
        .collection(Constants.Users)
        .document(currentUser.uid)
        .get()
        .then((DocumentSnapshot) => DocumentSnapshot.data["clicks"]);
    // .then((DocumentSnapshot) => DocumentSnapshot.data['clicks']);
  }

  Future getName() async {
    final FirebaseUser user = await auth.currentUser();

    return await user.displayName;
  }

  Future<bool> checkIfClaimer() async {
    final FirebaseUser user = await auth.currentUser();
    String date = await _db
        .collection(Constants.Users)
        .document(user.uid)
        .get()
        .then((DocumentSnapshot) =>
        DocumentSnapshot.data["claim_date"].toString());
    //    DocumentSnapshot['claim_date'].toString());

    if (date == DateTime
        .now()
        .day
        .toString()) {
      return true;
    } else {
      return false;
    }
  }

  Future<Users> getUserprofile() async {
    final FirebaseUser user = await auth.currentUser();
    return await _db
        .collection(Constants.Users)
        .document(user.uid)
        .get()
    //.then((DocumentSnapshot) => Users.fromMap(DocumentSnapshot.data()));
        .then((DocumentSnapshot) => Users.fromMap(DocumentSnapshot.data));
  }

  Future<AppStatus> getAppStatus() async {
    return await _db
        .collection("AppStatus")
        .document("app_status")
        .get()
    //.then((DocumentSnapshot) => AppStatus.fromMap(DocumentSnapshot.data()));
        .then((DocumentSnapshot) => AppStatus.fromMap(DocumentSnapshot.data));
  }

  Future<AddressModel> getUserAddress() async {
    final FirebaseUser user = await auth.currentUser();
    return await _db.collection(Constants.Users).document(user.uid).get().then(
      //(DocumentSnapshot) => AddressModel.fromJson(DocumentSnapshot.data()));
            (DocumentSnapshot) => AddressModel.fromJson(DocumentSnapshot.data));
  }

  Future<void> addTransactions(BuildContext context,
      String txnId,
      int amount,) async {
    //update to user Database
    final FirebaseUser user = await auth.currentUser();
    var transMap = Map<String, dynamic>();
    transMap["txnId"] = txnId;
    transMap["status"] = "TXN_SUCCESS";
    transMap["type"] = "DEPOSIT";
    transMap["amount"] = amount;
    transMap['time'] = DateTime.now().toIso8601String();
    await _db
        .collection(Constants.Users)
        .document(user.uid)
        .collection("transactions")
        .document()
        .setData(transMap)
        .then((value) async {
      await _db.collection(Constants.Users).document(user.uid).updateData({
        "amount": FieldValue.increment(amount),
      }).then((value) {
        print("Transaction Record and Participation Records Saved");
      });
    });
  }

  // Failed Tranaction
  Future<void> addFailedTransactions(BuildContext context,
      String txnId,) async {
    final FirebaseUser user = await auth.currentUser();
    var transMap = Map<String, dynamic>();
    transMap["txnId"] = txnId;
    transMap["status"] = "TXN_FAILURE";
    transMap["type"] = "DEPOSIT";
    transMap["amount"] = 10;
    transMap['time'] = DateTime.now().toIso8601String();

    await _db
        .collection(Constants.Users)
        .document(user.uid)
        .collection("transactions")
        .document()
        .setData(transMap)
        .then((value) async {
      print("Transaction Updated");
    }).catchError((error) {
      _showError(context);
    });
  }

  //Withdraw
  Future<void> addWithdrawRequest(BuildContext context, String method,
      int amount, String wallet_address, int clicks) async {
    final FirebaseUser user = await auth.currentUser();
    //update to user Database

    await _db.collection(Constants.Users).document(user.uid).updateData({
      "amount": FieldValue.increment(-amount),
    }).then((val) async {
      //save the transactions in Withdraw Request
      var withdrawMap = Map<String, dynamic>();
      withdrawMap["amount"] = amount;
      withdrawMap["date"] = DateTime.now().toIso8601String();
      withdrawMap["method"] = method;
      withdrawMap["status"] = "pending";
      withdrawMap["wallet_address"] = wallet_address;
      withdrawMap["uid"] = user.uid;
      withdrawMap["version"] = '1';
      String docId = user.uid + "${DateTime.now().toIso8601String()}";
      await _db
          .collection("WithdrawRequest")
          .document(docId)
          .setData(withdrawMap)
          .then((value) async {
        await _db
            .collection(Constants.Users)
            .document(user.uid)
            .collection("transactions")
            .document(docId)
            .setData(withdrawMap)
            .then((value) {})
            .then((val) {
          print("Withdraw Request have been added");
        });
      }).catchError((error) {
        _showError(context);
      });
      ;
    });
  }

  //Update Profile
  Future<void> updateUserProfile(BuildContext context, Users user) async {
    final FirebaseUser users = await auth.currentUser();
    //update to user Database
    var userMap = Map<String, dynamic>();
    userMap['name'] = user.name;
    userMap['phone_number'] = user.phone_number;

    await _db
        .collection(Constants.Users)
        .document(users.uid)
        .updateData(userMap)
        .then((val) {
      print("User profile Updated");
    }).catchError((error) {
      _showError(context);
    });
    ;
  }

  //Update Profile
  Future<void> updateAddress(BuildContext context,
      AddressModel addressModel) async {
    final FirebaseUser user = await auth.currentUser();
    //update Adrress to user Database

    var addressMap = Map<String, dynamic>();
    addressMap['paytm_wallet'] = addressModel.paytm_wallet;
    addressMap['googlepay_wallet'] = addressModel.googlepay_wallet;

    await _db
        .collection(Constants.Users)
        .document(user.uid)
        .updateData(addressMap)
        .then((val) {
      print("User Address Updated");
    }).catchError((error) {
      _showError(context);
    });
    ;
  }

  Future<void> participate(String eventId) async {
    final FirebaseUser user = await auth.currentUser();
    await _db.collection("WeeklyEvent").document(eventId).updateData({
      "participants": FieldValue.arrayUnion([user.uid])
    });
  }
}

_showDoneMessage(BuildContext context,) {
  showToast("You have Paticipated Successfully",
      context: context,
      backgroundColor: Colors.green,
      duration: Duration(seconds: 5),
      position: StyledToastPosition(align: Alignment.center, offset: 20.0));
}

_showError(BuildContext context, [Error error]) {
  showToast("Error Occured, Please Try Again",
      context: context,
      backgroundColor: Colors.green,
      duration: Duration(seconds: 5),
      position: StyledToastPosition(align: Alignment.center, offset: 20.0));
}
