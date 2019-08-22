import 'package:flutter/material.dart';
import 'dart:async';

class InputField extends StatefulWidget {
  InputField({Key key, this.label, this.onChanged}) : super(key: key);

  final String label;
  final void Function(String) onChanged;

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {

  final TextEditingController controller = TextEditingController();

  _InputFieldState();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () async {
            await Future.delayed(Duration(milliseconds: 10));
            setState(() {
             controller.text = ''; 
            });
          },
        ),
      ),
      onChanged: (String s) {
        widget.onChanged(s);
      },
    );
  }
}