import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/constants/appbar_constants.dart';

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
      style: ElevatedButton.styleFrom(
        backgroundColor: AppBarConstants.backgroundColor,
        padding:const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 3.0,
        shadowColor: Colors.blue.withOpacity(0.5),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
      child:  Text(
        text,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
