import 'package:flutter/material.dart';

class EmptyBagWidget extends StatelessWidget {
  const EmptyBagWidget({
    super.key,
    required this.imagePath,
    required this.text,
    required this.subText,
    required this.buttonText,
    required this.function,
  });

  final String imagePath, text, subText, buttonText;
  final Function function;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Image.asset(
            imagePath,
            width: double.infinity,
            height: size.height * 0.35,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          "Whoops!",
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 40,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 25,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          subText,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 20,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(20),
          ),
          onPressed: () {

           Navigator.canPop(context)?Navigator.pop(context):null;
          },
          child: Text(
            buttonText,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }
}
