import 'package:auto_size_text/auto_size_text.dart';
import 'package:ludofantasy/screens/address_page.dart';
import 'package:ludofantasy/screens/home_page.dart';
import 'package:ludofantasy/services/firebase_auth_services.dart';
import 'package:ludofantasy/services/firestore_services.dart';
import 'package:ludofantasy/utils/Constants.dart';
import 'package:ludofantasy/widget/message_dialog_with_ok.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:ludofantasy/models/address_model.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class WithdrawMoney extends StatefulWidget {
  @override
  _WithdrawMoneyState createState() => _WithdrawMoneyState();
}

class _WithdrawMoneyState extends State<WithdrawMoney> {
  int amount;
  String withdrawal_address = "";
  TextEditingController _withdrawal_addressController = TextEditingController();
  FirebaseAuthServices authServices = FirebaseAuthServices();
  FirestoreServices _fireStoreServices = FirestoreServices();

  int selected_location = 0;
  bool walletSelected = false;
  List<String> withdrawalServices = Constants.withdrawalServices;

  String paytm_wallet, googlepay_wallet, _warning;
  bool isLoginPressed = false;
  AddressModel addressModel;

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    _getPoints();
  }

  _getPoints() async {
    var firestoreServices =
        Provider.of<FirestoreServices>(context, listen: false);
    int pointts =
        await firestoreServices.getAmount();
    setState(() {
      amount = pointts;
    });
  }

  showEmptyWalletDialog(String message) {
    showDialog(
        context: context,
        builder: (context) => CustomDialogWithOk(
              title: "Empty Wallet",
              description: "Your have Not Added Your $message Address Yet",
              primaryButtonText: "Ok",
              primaryButtonRoute: AddressPage.routeName,
            ));
  }

  getTheWithdrawalAddress(ProgressDialog progressDialog, int value) async {
    switch (value) {
      case 0:
        //Paytm
        await progressDialog.show();
        addressModel = await _fireStoreServices.getUserAddress().then((value) {
          progressDialog.hide();

          if (value.paytm_wallet == "") {
            setState(() {
              showEmptyWalletDialog("Paytm");
              _withdrawal_addressController.text =
                  "Please Save Your Address First";
            });
            return;
          } else {
            setState(() {
              walletSelected = true;
              _withdrawal_addressController.text = value.paytm_wallet;
              withdrawal_address = _withdrawal_addressController.text;
            });
            return;
          }
        });

        break;
      case 1:
        //Google pay
        await progressDialog.show();
        addressModel = await _fireStoreServices.getUserAddress().then((value) {
          progressDialog.hide();

          if (value.googlepay_wallet == "") {
            setState(() {
              showEmptyWalletDialog("Google pay)");
              _withdrawal_addressController.text =
                  "Please Save Your Address First";
            });
            return;
          } else {
            setState(() {
              walletSelected = true;
              _withdrawal_addressController.text = value.googlepay_wallet;
              withdrawal_address = _withdrawal_addressController.text;
            });
            return;
          }
        });

        break;
    }
  }

  showToasts(String message) {
    showToast(message,
        context: context,
        backgroundColor: Colors.green,
        duration: Duration(seconds: 5),
        position: StyledToastPosition(align: Alignment.center, offset: 20.0));
  }

  @override
  Widget build(BuildContext context) {
    ProgressDialog progressDialog =
        ProgressDialog(context, isDismissible: false);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
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
                              "Available Amount:\n in wallet",textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            )),
                            SizedBox(
                              width: 10,
                            ),
                            Center(
                              child: Text(
                                amount == 0 ? "0" : "$amount",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            )
                          ],
                        ),
                      ),
                      Text(
                        amount == 0
                            ? "Wait For Few Seconds To get loaded"
                            : "Loaded",
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Flexible(
                      child: AutoSizeText(
                        "Note- Add Your Withdrawal Address, before withdrawal",
                        maxLines: 2,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return AddressPage();
                        }));
                      },
                      child: Container(
                        color: Colors.red,
                        child: Text("Here"),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  color: Colors.grey[700],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      AutoSizeText(
                        "Select the Wallet service",
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                      Container(
                        color: Colors.grey[600],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PopupMenuButton(
                            color: Colors.grey,
                            child: Row(
                              children: <Widget>[
                                Text(
                                  withdrawalServices[selected_location],
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                  size: 30,
                                )
                              ],
                            ),
                            onSelected: (int value) {
                              setState(() {
                                selected_location = value;
                                getTheWithdrawalAddress(progressDialog, value);
                              });
                            },
                            itemBuilder: (BuildContext context) {
                              return <PopupMenuItem<int>>[
                                PopupMenuItem(
                                  child: Text(
                                    withdrawalServices[0],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                  value: 0,
                                ),
                                PopupMenuItem(
                                  child: Text(
                                    withdrawalServices[1],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                  value: 1,
                                ),
                              ];
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                    child: TextFormField(
                  style: TextStyle(fontSize: 14),
                  controller: _withdrawal_addressController,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: "Wallet Address",
                    labelStyle: TextStyle(fontSize: 15),
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      borderSide: new BorderSide(),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  onSaved: (String value) => withdrawal_address = value,
                )),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue),
                  child: FlatButton(
                    onPressed: () async {
                      ProgressDialog pr =
                          ProgressDialog(context, isDismissible: false);
                      int pointts = await _fireStoreServices
                          .getAmount();
                      int clicks = await _fireStoreServices
                          .getClicks(await authServices.getCurrentUser());
                      if (pointts >= 1000) {
                        if (walletSelected == true) {
                          if (withdrawal_address != "") {
                            await pr.show();
                            _fireStoreServices
                                .addWithdrawRequest(
                                    context,
                                    withdrawalServices[selected_location],
                                    pointts,
                                    withdrawal_address,
                                    clicks)
                                .then((val) {
                              pr.hide();
                              setState(() {
                                pointts = 0;
                              });
                              showDialog(
                                  context: context,
                                  builder: (context) => CustomDialogWithOk(
                                        title: "Withdrawal request",
                                        description:
                                            "Your withdrawal will be processed within 48 Hours",
                                        primaryButtonText: "Ok",
                                        primaryButtonRoute: HomePage.routeName,
                                      ));
                            });
                          } else {
                            showToasts("We should send you to the Address");
                          }
                        } else {
                          showToasts("Please Select Your Wallet Address First");
                        }
                      } else {
                        showToasts(
                            "You have Low Balance in your wallet, Min Withdraw point is 1000");
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Withdraw",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Note- You Will receive your payment within 48 hours if you use Paytm For Withdrawal",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Note- It may take more than one week for withdrawal, if you request in wallet other than paytm and google pay",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
