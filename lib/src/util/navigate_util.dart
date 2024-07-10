import 'package:flutter/material.dart';

class Navigate {
  static navigateToRoute({required context, required widget}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );
  }
}