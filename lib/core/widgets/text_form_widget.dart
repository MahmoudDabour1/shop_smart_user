import 'package:flutter/material.dart';

class CustomTextFormWidget extends StatefulWidget {
  const CustomTextFormWidget({
    super.key,
    required this.function,
    required this.controller,
    required this.onTap,
  });

  final Function function;
  final TextEditingController controller;
  final Function onTap;

  @override
  State<CustomTextFormWidget> createState() => _CustomTextFormWidgetState();
}

class _CustomTextFormWidgetState extends State<CustomTextFormWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onChanged: (value) {
        widget.function();
      },
      onSubmitted: (value) {
        widget.function();
      },
      decoration: InputDecoration(
        filled: true,
        hintText: "Search",
        prefixIcon: const Icon(Icons.search),
        suffixIcon: GestureDetector(
          onTap: () {
            widget.onTap();
          },
          child: widget.controller.text.isEmpty
              ? const SizedBox.shrink()
              : const Icon(
                  Icons.clear,
                  color: Colors.red,
                ),
        ),
      ),
    );
  }
}
