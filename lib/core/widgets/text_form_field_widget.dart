// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final FocusNode? focusNode;
  void Function(String) function;
  String? Function(String?)? validation;
  final IconData prefixIcon;
  final bool isPassword, isLastInput;
  final TextInputType keyboardType;

  TextFormFieldWidget({
    super.key,
    required this.hintText,
    required this.controller,
    this.focusNode,
    required this.function,
    this.validation,
    required this.prefixIcon,
    this.isPassword = false,
    this.isLastInput = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        textInputAction:
            widget.isLastInput ? TextInputAction.done : TextInputAction.next,
        keyboardType: widget.keyboardType,
        onFieldSubmitted: (value) {
          widget.function(value);
        },
        validator: widget.validation,
        obscureText: widget.isPassword && isHidden,
        obscuringCharacter: '*',
        decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: Icon(
              widget.prefixIcon,
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isHidden = !isHidden;
                      });
                    },
                    icon: Icon(
                      isHidden ? Icons.visibility : Icons.visibility_off,
                    ),
                  )
                : null),
      ),
    );
  }
}
