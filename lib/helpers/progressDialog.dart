import 'package:flutter/material.dart';

void progressDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    child: Center(
      child: Card(
        color: Colors.black38,
        child: Container(
          height: 80,
          width: 80,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    ),
  );
}