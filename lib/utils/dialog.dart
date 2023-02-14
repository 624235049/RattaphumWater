import 'package:flutter/material.dart';
import 'package:rattaphumwater/pages/admin/widget/big_text.dart';

Future<void> normalDialog(BuildContext context, String message) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: BigText( text: message),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
                onPressed: () => Navigator.pop(context),
                child: BigText(
                  text: 'OK',
                )),
          ],
        )
      ],
    ),
  );
}


Future<void> normalDialog2(
    BuildContext context, String title, String message) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: Container(
        width: 150,
        child: ListTile(
          leading: Image.asset('assets/images/order_ss.jpg'),
          title: Text(
            title,
            style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold),
          ),
          subtitle: Text(message),
        ),
      ),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.red),
                )),
          ],
        )
      ],
    ),
  );
}