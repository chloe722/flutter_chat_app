import 'package:flutter/material.dart';

class DecoratedTextField extends StatelessWidget {
  DecoratedTextField({this.name, this.controller});

  final String name;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: TextField(
          controller: controller,
          onChanged: (val) {
            controller.value = TextEditingController.fromValue(TextEditingValue(text: val)).value;
          },
          maxLines: null,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: name,

          ),
        ));
  }
}
