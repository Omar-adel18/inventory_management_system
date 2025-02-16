import 'package:flutter/material.dart';

class BuildTextField extends StatelessWidget {
  const BuildTextField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
    this.validator,
    this.keyboardType = TextInputType.text,
    FocusNode? focusNode,
  });

  final String label;
  final String initialValue;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0, left: 16.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        controller: TextEditingController(text: initialValue),
        onChanged: onChanged,
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }
}
