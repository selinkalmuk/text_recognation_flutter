import 'package:flutter/material.dart';

class MyIconButton extends StatelessWidget {
  final String buttonText;
  final IconData buttonIcon;
  // ignore: prefer_typing_uninitialized_variables
  final void Function()? buttonTapped;

  MyIconButton(
      {required this.buttonText, required this.buttonIcon, this.buttonTapped});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.0,
      child: ElevatedButton(
          onPressed: buttonTapped,
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(buttonIcon),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(buttonText),
              ),
            ],
          )),
    );
  }
}
