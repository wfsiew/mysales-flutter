import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
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
        suffixIcon: controller.text.isEmpty ? null : IconButton(
          icon: Icon(Icons.clear),
          onPressed: () async {
            await Future.delayed(Duration(milliseconds: 10));
            setState(() {
             controller.text = '';
             widget.onChanged('');
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

class TypeAheadInputField extends StatefulWidget {
  TypeAheadInputField({Key key, this.label, this.ls, this.onChanged}) : super(key: key);

  final String label;
  final List<String> ls;
  final void Function(String) onChanged;

  @override
  _TypeAheadInputFieldState createState() => _TypeAheadInputFieldState();
}

class _TypeAheadInputFieldState extends State<TypeAheadInputField> {

  final TextEditingController controller = TextEditingController();

  _TypeAheadInputFieldState();

  @override
  Widget build(BuildContext context) {
    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: controller,
        decoration: InputDecoration(
          labelText: widget.label,
          suffixIcon: controller.text.isEmpty ? null : IconButton(
            icon: Icon(Icons.clear),
            onPressed: () async {
              await Future.delayed(Duration(milliseconds: 10));
              setState(() {
               controller.text = '';
               widget.onChanged('');
              });
            },
          ),
        ),
        onChanged: (s) {
          widget.onChanged(s);
        },
      ),
      suggestionsCallback: (String s) {
        if (s.isEmpty) {
          return widget.ls;
        }

        var lx = widget.ls.where((x) => x.toLowerCase().contains(s.toLowerCase())).toList();
        return lx;
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      onSuggestionSelected: (suggestion) {
        controller.text = suggestion;
        widget.onChanged(suggestion);
      },
    );
  }
}