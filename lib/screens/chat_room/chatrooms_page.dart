import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:ludofantasy/models/message_model.dart';
import 'package:ludofantasy/services/firestore_services.dart';
import 'package:ludofantasy/utils/Constants.dart';


import 'chat_bubble.dart';
import 'chat_input.dart';

class ChatRoomsPage extends StatefulWidget {
  @override
  _ChatRoomsPageState createState() => _ChatRoomsPageState();
}

class _ChatRoomsPageState extends State<ChatRoomsPage> {
  var isAudioOnly = true;
  var isAudioMuted = true;
  var isVideoMuted = false;

  Stream stream;
  FirestoreServices fireStoreServices = FirestoreServices();
  bool showLoading = true;

  String _name;

  @override
  void initState() {
    super.initState();
    fireStoreServices.getGroupMessage().then((val) {
      setState(() {
        stream = val;
        showLoading = false;
      });
    });

    getName();
  }

  getName() async {
    _name = await fireStoreServices.getName();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FirestoreServices firestore = FirestoreServices();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          elevation: 1.0,
          centerTitle: true,
          title: Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Ludo Fantasy ChatRoom",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  AutoSizeText(
                    "Share your valueable messages here",
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: Theme.of(context).brightness == Brightness.light
                    ? Constants.lightBGColors
                    : Constants.darkBGColors,
              ),
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.topCenter,
                    padding:
                        const EdgeInsets.only(left: 5.0, right: 5.0, top: 5),
                    child: SingleChildScrollView(
                      reverse: true,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                StreamBuilder(
                                    stream: stream,
                                    builder: (context, snapshots) {
                                      return snapshots.data == null
                                          ? Center(
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator()))
                                          : ListView.builder(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: snapshots
                                                  .data.documents.length,
                                              shrinkWrap: true,
                                              reverse: false,
                                              itemBuilder: (context, index) {
                                                if (index < 0)
                                                  return Text("No Groups");

                                                Message message = Message(
                                                  message: snapshots
                                                      .data
                                                      .documents[index]
                                                      .data["message"],
                                                  time: snapshots
                                                      .data
                                                      .documents[index]
                                                      .data["time"],
                                                  name: snapshots
                                                      .data
                                                      .documents[index]
                                                      .data["name"],
                                                  uid: snapshots
                                                      .data
                                                      .documents[index]
                                                      .data["uid"],
                                                );
                                                return Card(
                                                    elevation: 1,
                                                    color: Colors.transparent,
                                                    child: ChatBubble(
                                                        message: message));
                                              });
                                    })
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: ChatInput(
                    onPressed: (message) {
                      if (_name == null) {
                        firestore.addGroupMessage(message, "Unknown",
                            Constants.prefs.getString(Constants.uid));
                      } else {
                        firestore.addGroupMessage(message, _name,
                            Constants.prefs.getString(Constants.uid));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
