import 'package:flutter/material.dart';

class DropDownField extends StatefulWidget {
  final String? labelText;
  final List<String> items;
  final String? value;
  final ValueChanged<String?>? onChanged;

  const DropDownField({
    Key? key,
    required this.items,
    this.labelText,
    this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  _DropDownFieldState createState() => _DropDownFieldState();
}

class _DropDownFieldState extends State<DropDownField> {
  late String? _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: _selectedItem,
      decoration: InputDecoration(
        labelText: widget.labelText,
        filled: true,
        fillColor: Colors.grey.withOpacity(0.1),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
      items: widget.items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (widget.items.contains(newValue)) {
          // verifica se o novo valor selecionado está presente na lista de itens
          setState(() {
            _selectedItem = newValue;
          });
          if (widget.onChanged != null) {
            widget.onChanged!(newValue);
          }
        }
      },
    );
  }
}