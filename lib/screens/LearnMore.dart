import 'package:auto_size_text/auto_size_text.dart';
import 'package:ludofantasy/utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class LearnMorePage extends StatefulWidget {
  @override
  _LearnMorePageState createState() => _LearnMorePageState();
}

class _LearnMorePageState extends State<LearnMorePage> {
  @override
  Widget build(BuildContext context) {

    _launchURL(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        title: Text("Fair Draw"),
        elevation: 0,
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.red, Colors.orange])),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.greenAccent,
                    child: Icon(FontAwesomeIcons.rocket),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "100% Fair Draw",
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: AutoSizeText(
                      "Nothing",
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      await _launchURL(
                          "https://codebeautify.org/hmac-generator");
                    },
                    child: Text("Verify Results"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Note- Use HMAC-SHA512 Algorithm",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
