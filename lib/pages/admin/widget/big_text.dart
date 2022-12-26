
import 'package:flutter/material.dart';

class BigText extends StatelessWidget {
  Color? color;
  final String text;
  double size;
  TextOverflow overflow;

  //ประกาศเรียก Constructor ในwidgetของ BigText นำมาเรียกใช้กำหนด Text "" และ สี ขนาด

  BigText(
      {Key? key,
        this.color = const Color(0xFF332d2b),
        required this.text,
        this.size = 0,
        this.overflow = TextOverflow.ellipsis})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: overflow,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
        fontSize: size == 0 ? 20 : size,
      ),
    );
  }
}
