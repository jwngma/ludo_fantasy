import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:ludofantasy/services/firebase_auth_services.dart';
import 'package:ludofantasy/services/firestore_services.dart';
import 'package:ludofantasy/wallet/PaymentScreen.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AddMoney extends StatefulWidget {
  const AddMoney({Key key}) : super(key: key);

  @override
  _AddMoneyState createState() => _AddMoneyState();
}

class _AddMoneyState extends State<AddMoney> {
  int amount;

  TextEditingController _amountController = TextEditingController();

  FirestoreServices fireStoreServices = FirestoreServices();
  FirebaseAuthServices authServices = FirebaseAuthServices();

  @override
  void initState() {
    _getBalance();
    super.initState();
  }

  _getBalance() async {
    int amountt = await fireStoreServices.getAmount();
    setState(() {
      amount = amountt;
    });
  }

  @override
  Widget build(BuildContext context) {
    ProgressDialog progressDialog =
        ProgressDialog(context, isDismissible: false);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                                child: Text(
                              "Available Balance:",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            )),
                            SizedBox(
                              width: 10,
                            ),
                            Center(
                              child: Text(
                                amount == 0 ? "0" : "Rs- ${amount}",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            )
                          ],
                        ),
                      ),
                      Text(
                        amount == 0 ? "Wait For Few Seconds To get loaded" : "",
                        style: TextStyle(color: Colors.white, fontSize: 8),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Enter The Amount"),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.red),
                  child: FlatButton(
                    onPressed: () {
                      if (_amountController.text.toString() != null &&
                          _amountController.text.toString() != "") {

                        if (int.parse(_amountController.text.toString()) >=
                            10) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return PaymentScreen(
                                    amount:
                                    int.parse(_amountController.text.toString()));
                              }));
                        }else{
                          showToast("Minimum Amount that can be added is Rs 10", context: context);
                        }

                      } else  {
                        showToast("Enter Your Amount", context: context);
                      }
                    },
                    child: Text(
                      "Add Money",
                      style: TextStyle(color: Colors.white),
                    ),
                  )),

              /*     */
              SizedBox(
                height: 10,
              ),
              Text(
                "We Support payments only using Upi, If You do not have upi apps like Paytm, google Pay, phonepe etc, Please install first",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
