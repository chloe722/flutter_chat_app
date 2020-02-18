import 'package:flash_chat/constants.dart';
import 'package:flash_chat/strings.dart';
import 'package:flash_chat/widgets/round_button.dart';
import 'package:flutter/material.dart';

class InfoEditingCard extends StatelessWidget {
  InfoEditingCard({this.content, this.onTap, this.icon});

  final String content;
  final Function(String) onTap;
  final IconData icon;
  TextEditingController _controller;
  String _content;

  @override
  Widget build(BuildContext context) {
    _controller = TextEditingController(text: content);
    return Stack(
      alignment: Alignment.topCenter,
      overflow: Overflow.visible,
      children: <Widget>[
        Card(
          elevation: 8.0,
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 32.0, right: 32.0, bottom: 16.0, top: 32.0),
                child: TextFormField(
                  controller: _controller,
                  maxLines: 1,
                  onChanged: (value) => _content = value,
                  decoration: kEditingTextFormFieldDecoration,
                ),
              ),
              RoundButton(
                  color: kOliverdrib,
                  label: kSave,
                  onPressed: () => onTap(_content))
            ],
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height / 4,
          child: Card(
            elevation: 8.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0)),
            child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: Icon(icon,
                    size: 48.0, color: kBrown)),
          ),
        ),
      ],
    );
  }
}
