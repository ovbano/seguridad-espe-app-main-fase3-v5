import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String ruta;
  final String text;
  final String text2;

  const Labels(
      {super.key, required this.ruta, required this.text, required this.text2});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(text, style: const TextStyle(color: Colors.black54)),
        TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, ruta);
          },
          child: Text(text2,
              style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0), fontSize: 18)),
        ),
      ],
      
    );
  }
}