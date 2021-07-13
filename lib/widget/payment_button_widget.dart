import 'package:flutter/material.dart';

Widget paymentAccept(
    {required bool visible,
    required String title,
    required String imagePath,
    required Color color,
    Function? onTap,
    String subTitle = ''}) {
  return Visibility(
    visible: visible,
    child: GestureDetector(
      onTap: () {
        if (onTap != null) onTap();
      },
      child: Container(
        height: 85,
        constraints: BoxConstraints(maxWidth: 160, minWidth: 160),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: color,
            image: DecorationImage(
              image: Image.asset(imagePath).image,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subTitle,
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
            Text(
              title,
              style: TextStyle(color: Colors.black87),
            )
          ],
        ),
      ),
    ),
  );
}
