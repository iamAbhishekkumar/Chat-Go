import 'package:flutter/material.dart';

class ErrorOccured extends StatelessWidget {
  final String error;

  const ErrorOccured({Key key, this.error}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        error,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
