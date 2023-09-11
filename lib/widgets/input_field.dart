import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class InputField extends StatefulWidget {
  final TextEditingController inputController;
  final String textLabel;
  final Widget suffixWidget;
  final MaskTextInputFormatter? formatter;
  final bool isRequired;
  final bool showDatePicker;
  final bool obscure;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;

  const InputField({
    Key? key,
    required this.inputController,
    required this.textLabel,
    required this.suffixWidget,
    this.formatter,
    this.isRequired = false,
    this.showDatePicker = false,
    this.obscure = false,
    this.onTap,
    this.validator,
  }) : super(key: key);

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.inputController,
      onTap: widget.onTap,
      inputFormatters:
          widget.formatter != null ? [widget.formatter!] : [],
      keyboardType: widget.formatter != null ? TextInputType.number : null,
      obscureText: widget.obscure,
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: widget.textLabel,
        suffixIcon: widget.suffixWidget,
        filled: true,
        fillColor: Colors.grey.withOpacity(0.1),
        errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.red)),
        errorStyle: const TextStyle(height: 0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
    );
  }
}
