import 'package:flutter/material.dart';
import 'package:ludofantasy/screens/account_page.dart';
import 'package:ludofantasy/screens/home_page.dart';
import 'package:ludofantasy/screens/redeem_page.dart';
import 'package:ludofantasy/screens/signup_page.dart';
import 'package:ludofantasy/screens/splash_screen_page.dart';
import 'package:ludofantasy/screens/welcome_screen.dart';
import 'package:ludofantasy/services/firebase_auth_services.dart';
import 'package:provider/provider.dart';
import 'auth_widget_builder.dart';

class ConfigPage extends StatefulWidget {
  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {

  @override
  Widget build(BuildContext context) {
    return Provider<FirebaseAuthServices>(
      create: (_) => FirebaseAuthServices(),
      child: AuthWidgetBuilder(builder: (context, userSnapshot) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                brightness: Brightness.dark,
                primarySwatch: Colors.indigo,
                primaryColor: Colors.deepPurpleAccent),
            routes: {
              "/home": (context) => HomePage(),
              HomePage.routeName: (context) => HomePage(),
              "/accountScreen": (context) => AccountScreen(),
              "/signUp": (context) => SignUpPage(
                    authFormType: AuthFormType.SignUp,
                  ),
              "/signIn": (context) => SignUpPage(
                    authFormType: AuthFormType.SignIn,
                  ),
              "/firstView": (context) => FirstView(),
              AccountScreen.routeName: (context) => AccountScreen(),
              RedeemScreen.routeName: (context) => RedeemScreen(),
//              ProfilePage.routeName: (context) => ProfilePage(),
//              AddressPage.routeName: (context) => AddressPage(),
            },
            home: SplashScreenPage(userSnapshot: userSnapshot)

            //AuthWidget(userSnapshot: userSnapshot),
            );
      }),
    );
  }
}
