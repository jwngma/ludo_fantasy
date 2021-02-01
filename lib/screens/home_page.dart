import 'package:bubbled_navigation_bar/bubbled_navigation_bar.dart';
import 'package:flutter/services.dart';
import 'package:ludofantasy/games/live/LiveEventsPage.dart';
import 'package:ludofantasy/games/my_contest/MyContestPage.dart';
import 'package:ludofantasy/games/result/ResultPage.dart';
import 'package:ludofantasy/games/upcoming/Dashboard.dart';
import 'package:ludofantasy/screens/about_us.dart';
import 'package:ludofantasy/screens/policy_page.dart';
import 'package:ludofantasy/screens/redeem_page.dart';
import 'package:ludofantasy/services/firebase_auth_services.dart';
import 'package:ludofantasy/utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ludofantasy/wallet/SuccesfulPurchase.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'account_page.dart';
import 'chat_room/chatrooms_page.dart';
import 'notification_page.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "HomePage";
  final titles = ['Dashboard', 'Live', 'My Contests', "Results"]; //'Events',
  final colors = [
    Colors.red,
    Colors.purple,
    Colors.green,
    Colors.orange,
  ];
  final icons = [
    FontAwesomeIcons.home,
    FontAwesomeIcons.diceOne,
    FontAwesomeIcons.ticketAlt,
    FontAwesomeIcons.rProject
  ];

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // var facebookAdsServices = FacebookAdsServices();
  GlobalKey _bottomNavigationKey = GlobalKey();
  PageController _pageController;
  MenuPositionController _menuPositionController;
  bool userPageDragging = false;

  showInterstitialAds() {
    //  facebookAdsServices.showInterstitialAd();
  }

  Future<void> _signOut(BuildContext context) async {
    ProgressDialog progressDialog =
        ProgressDialog(context, isDismissible: false);
    await progressDialog.show();
    try {
      final auth = Provider.of<FirebaseAuthServices>(context, listen: false);
      GoogleSignIn _googleSignIn = GoogleSignIn();

      if (_googleSignIn != null) {
        print("Google is called");
        await auth.signOutWhenGoogle();
        progressDialog.hide();
      } else {
        print("Auth is Called");
        await auth.signOut();
        progressDialog.hide();
      }
      Constants.prefs.clear();
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _menuPositionController = MenuPositionController(initPosition: 0);

    _pageController =
        PageController(initialPage: 0, keepPage: false, viewportFraction: 1.0);
    _pageController.addListener(handlePageChange);

    super.initState();
  }

  @override
  void dispose() {
    // _menuPositionController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void handlePageChange() {
    _menuPositionController.absolutePosition = _pageController.page;
  }

  final List<Widget> _screens = [
    // new HomeScreen(),
    new DashboardPage(),
    new LiveEventsScreen(),
    new MyContestsScreen(),
    new ResultsScreen()
  ];
  String app_bar_title = "Ludo fantasy";

  void checkUserDragging(ScrollNotification scrollNotification) {
    if (scrollNotification is UserScrollNotification &&
        scrollNotification.direction != ScrollDirection.idle) {
      userPageDragging = true;
    } else if (scrollNotification is ScrollEndNotification) {
      userPageDragging = false;
    }
    if (userPageDragging) {
      _menuPositionController.findNearestTarget(_pageController.page);
    }
  }

  @override
  Widget build(BuildContext context) {
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
        appBar: AppBar(
          elevation: 0,
          title: Text(Constants.app_name),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.chat,
                  color: Colors.yellow,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ChatRoomsPage();
                  }));
                }),
            IconButton(
                icon: Icon(
                  Icons.notifications,
                  color: Colors.yellow,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return NotificationPage();
                  }));
                }),
            SizedBox(
              width: 10,
            )
          ],
        ),
        // bod
        //
        // y: FaceBookAds(),

        bottomNavigationBar: SafeArea(
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: BubbledNavigationBar(
              controller: _menuPositionController,
              initialIndex: 1,
              itemMargin: EdgeInsets.symmetric(horizontal: 8),
              defaultBubbleColor: Colors.red,
              backgroundColor: Colors.grey[800],
              onTap: (index) {
                print(index.toString());
                _pageController.animateToPage(index,
                    curve: Curves.easeInOutQuad,
                    duration: Duration(milliseconds: 200));
              },
              items: widget.titles.map((title) {
                var index = widget.titles.indexOf(title);
                var color = widget.colors[index];
                return BubbledNavigationBarItem(
                  icon: getIcon(index, color),
                  activeIcon: getIcon(index, Colors.white),
                  bubbleColor: color,
                  title: Text(
                    title,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        body: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            checkUserDragging(scrollNotification);
          },
          child: PageView(
            controller: _pageController,
            children: _screens,
            onPageChanged: (page) {
              print(page);
              setState(() {
                switch (page) {
                  case 0:
                    app_bar_title = "Ludo Fantasy";
                    break;
                  case 1:
                    app_bar_title = "Live";
                    break;
                  case 2:
                    app_bar_title = "My Contest";
                    break;
                  default:
                    app_bar_title = "Results";
                    break;
                }
              });
            },
          ),
        ),

        //HomeScreen(),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(
                  Constants.app_name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                accountEmail: Text(
                  "Play more Earn more",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
                currentAccountPicture: new CircleAvatar(
                  child: Icon(Icons.account_box),
                  backgroundColor: Colors.greenAccent,
                ),
              ),
              ListTile(
                title: Text("Home"),
                leading: Icon(Icons.home),
                onTap: () {
                  Navigator.of(context).pop();
                  showInterstitialAds();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return HomePage();
                  }));
                },
              ),
              Divider(
                height: 1,
                color: Colors.indigo,
              ),
              ListTile(
                title: Text("Settings"),
                leading: Icon(Icons.account_circle),
                onTap: () {
                  Navigator.of(context).pop();
                  showInterstitialAds();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AccountScreen();
                  }));
                },
              ),
              Divider(
                height: 1,
                color: Colors.indigo,
              ),
              ListTile(
                title: Text("Redeem"),
                leading: Icon(Icons.account_balance_wallet),
                onTap: () {
                  Navigator.of(context).pop();
                  showInterstitialAds();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return RedeemScreen();
                  }));
                },
              ),
              Divider(
                height: 1,
                color: Colors.indigo,
              ),
              ListTile(
                title: Text("About us"),
                leading: Icon(Icons.info),
                onTap: () {
                  Navigator.of(context).pop();
                  showInterstitialAds();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AboutUsScreen();
                  }));
                },
              ),
              Divider(
                height: 1,
                color: Colors.indigo,
              ),
              ListTile(
                title: Text("Policies"),
                leading: Icon(Icons.security),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PolicyPage();
                  }));
                },
              ),
              Divider(
                height: 1,
                color: Colors.indigo,
              ),
              Divider(
                height: 1,
                color: Colors.indigo,
              ),
              ListTile(
                title: Text("Help"),
                leading: Icon(Icons.help),
                onTap: () {
                  Navigator.of(context).pop();
                  showInterstitialAds();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SuccesfulPurchase(amount: 10, transactionId: "hdgfhdgfh",desc: "You have siccessfuly done it",done: true,);
                  }));
                },
              ),
              Divider(
                height: 1,
                color: Colors.indigo,
              ),
              Divider(
                height: 1,
                color: Colors.indigo,
              ),
              ListTile(
                title: Text("Share App"),
                leading: Icon(Icons.share),
                onTap: () {
                  Navigator.of(context).pop();
                  Share.share(Constants.share_link);
                },
              ),
              Divider(
                height: 1,
                color: Colors.indigo,
              ),
              ListTile(
                title: Text("Logout"),
                leading: Icon(FontAwesomeIcons.signOutAlt),
                onTap: () {
                  Navigator.of(context).pop();
                  _signOut(context);
                },
              ),
              Divider(
                height: 1,
                color: Colors.indigo,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding getIcon(int index, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Icon(widget.icons[index], size: 30, color: color),
    );
  }
}
