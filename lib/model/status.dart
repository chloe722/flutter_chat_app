import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Status {
  Icon icon;
  String content;
  Status({this.icon, this.content});

}


List<Status> statusList = [
  Status(icon: Icon(Icons.face, color: Colors.green), content:'I am avalibale to chat!'),
  Status(icon: Icon(Icons.cancel, color: Colors.red ), content:'Busy'),
  Status(icon: Icon(Icons.help, color: Colors.red ), content:'Need help'),
  Status(icon: Icon(Icons.mood_bad, color: Colors.deepPurple ), content:'I want to talk to someone..'),
  Status(icon: Icon(Icons.phone,color: Colors.red), content:'On the call'),
  Status(icon: Icon(Icons.beach_access,color: Colors.blue ), content:'Enjoying holiday'),
  Status(icon: Icon(Icons.card_travel,color: Colors.deepOrangeAccent), content:'Want to go travel'),
  Status(icon: Icon(Icons.computer,color: Colors.blueGrey), content:'Spending time with computer'),
  Status(icon: Icon(Icons.tv,color: Colors.blue), content:'Watching Netflix / TV / Youtube'),
  Status(icon: Icon(Icons.school,color: Colors.green), content:'At the school'),
  Status(icon: Icon(Icons.book,color: Colors.blue), content:'Reading books'),
];