import 'package:flutter/material.dart';

class SharedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const SharedButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFC5A364),
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 3.0,
        shadowColor: Colors.blue.withOpacity(0.5),
        textStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
