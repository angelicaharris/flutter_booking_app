import 'package:flutter/material.dart';

/// A Custom Dialog that displays a single question & list of answers.
class MultiSelectDialog extends StatelessWidget {
  /// List to display the answer.
  final List<String> answers;

  /// Widget to display the question.
  final Widget question;

  /// List to hold the selected answer
  /// i.e. ['a'] or ['a','b'] or ['a','b','c'] etc.
  final List<String> selectedItems = [];

  /// Map that holds selected option with a boolean value
  /// i.e. { 'a' : false}.
  static Map<String, bool>? _mappedItem;

  MultiSelectDialog({required this.answers, required this.question});

  /// Function that converts the list answer to a map.
  Map<String, bool> initMap() {
    return _mappedItem = Map.fromIterable(answers,
        key: (k) => k.toString(),
        value: (v) {
          if (v != true && v != false)
            return false;
          else
            return v as bool;
        });
  }

  @override
  Widget build(BuildContext context) {
    if (_mappedItem == null) {
      initMap();
    }
    return SimpleDialog(
      title: question,
      children: [
        ..._mappedItem!.keys.map((String key) {
          return StatefulBuilder(
            builder: (_, StateSetter setState) => CheckboxListTile(
                title: Text(key), // Displays the option
                value: _mappedItem![key], // Displays checked or unchecked value
                controlAffinity: ListTileControlAffinity.platform,
                onChanged: (value) =>
                    setState(() => _mappedItem![key] = value!)),
          );
        }).toList(),
        Align(
            alignment: Alignment.center,
            child: ElevatedButton(
                style: ButtonStyle(visualDensity: VisualDensity.comfortable),
                child: Text('Submit'),
                onPressed: () {
                  // Clear the list
                  selectedItems.clear();

                  // Traverse each map entry
                  _mappedItem!.forEach((key, value) {
                    if (value == true) {
                      selectedItems.add(key);
                    }
                  });

                  // Close the Dialog & return selectedItems
                  Navigator.pop(context, selectedItems);
                }))
      ],
    );
  }
}
