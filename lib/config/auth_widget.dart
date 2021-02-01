
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ludofantasy/screens/home_page.dart';
import 'package:ludofantasy/screens/welcome_screen.dart';
import 'package:ludofantasy/services/firebase_auth_services.dart';

class AuthWidget extends StatelessWidget {
  final AsyncSnapshot<User> userSnapshot;

   AuthWidget({Key key, @required this.userSnapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (userSnapshot.connectionState == ConnectionState.active) {
      return userSnapshot.hasData ? HomePage() : FirstView();
    }
    return Scaffold(
        body: Center(
      child: CircularProgressIndicator(),
    ));
  }
}
