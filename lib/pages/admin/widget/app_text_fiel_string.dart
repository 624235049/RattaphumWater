
import 'package:flutter/material.dart';

class AppTextFieldString extends StatelessWidget {
  final  String text;
  final String hintText;
  final IconData icon;
  const AppTextFieldString(
      {Key? key,
        required this.text,
        required this.hintText,
        required this.icon})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              blurRadius: 10,
              spreadRadius: 7,
              offset: Offset(1, 10),
              color: Colors.grey.withOpacity(0.2)),
        ],
      ),
      child: TextFormField(
        onChanged: (value) => text,
        initialValue: text,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(
            icon,
            color: Colors.blueAccent,
          ),
          //focus border
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(width: 1.0, color: Colors.white),
          ),
          //enable borders
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(width: 1.0, color: Colors.white)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
