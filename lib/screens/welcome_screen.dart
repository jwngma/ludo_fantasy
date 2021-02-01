import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:ludofantasy/screens/signup_page.dart';
import 'package:ludofantasy/utils/Constants.dart';
import 'package:ludofantasy/widget/custom_dialog.dart';
import 'package:flutter/material.dart';


class FirstView extends StatelessWidget {
  static const String routeName= "/FirstView";
  final primaryColor = const Color(0xFF75A2EA);

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Confirm Exit"),
                content: Text("Are you sure you want to exit?"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("YES"),
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                  ),
                  FlatButton(
                    child: Text("NO"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      },
      child: Scaffold(
        body: Container(
          color: Colors.black,
          width: _width,
          height: _height,
          child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: _height * .10,
                      ),
                      Text(
                        "Welcome",
                        style: TextStyle(fontSize: 40, color: Colors.white),
                      ),
                      SizedBox(
                        height: _height * .10,
                      ),
                      AutoSizeText(
                       Constants.app_name,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 40, color: Colors.white),
                      ),
                      SizedBox(
                        height: _height * .15,
                      ),
                      RaisedButton(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 16),
                            child: Text(
                              "Get Started",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                          onPressed: () {

                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return SignUpPage(authFormType: AuthFormType.SignIn,);
                            }));
                            showDialog(
                                context: context,
                                builder: (context) => CustomDialog(
                                  title: "Would to Like to Create a Free Account ?",
                                  description:
                                  "With an Account, your data will be Securely saved, allowing you to access from any device",
                                  primaryButtonText: "Create My Account",
                                  primaryButtonRoute: "/signUp",
                                  secondaryButtonText: "",
                                  secondaryButtonRoute: "/signUp",
                                ));
                          }),
                      SizedBox(
                        height: _height * .05,
                      ),
                      FlatButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, "/signIn");
                          },
                          child: Text(
                            "Sign In",
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ))
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
