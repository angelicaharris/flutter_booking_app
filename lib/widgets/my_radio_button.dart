import 'package:flutter/material.dart';
import 'package:flutter_booking_app/pages/signup_screen.dart';

enum UserTypeEnum { Student, Tutor }

class MyRadioButton extends StatelessWidget {
  MyRadioButton({
    Key? key,
    required this.title,
    required this.value,
    required this.selectedUserType,
    required this.onChanged,
  }) : super(key: key);

  String title;
  UserTypeEnum value;
  UserTypeEnum? selectedUserType;
  Function(UserTypeEnum?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RadioListTile<UserTypeEnum>(
          title: Text(title),
          value: value,
          groupValue: selectedUserType,
          contentPadding: EdgeInsets.all(0.0),
          tileColor: Colors.deepPurple.shade50,
          dense: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          onChanged: onChanged),
    );
  }
}
