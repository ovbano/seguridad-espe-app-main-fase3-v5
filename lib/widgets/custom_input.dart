import 'package:flutter/material.dart';

class CustonInput extends StatefulWidget {
  final IconData icon;
  final String placeholder;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final bool isPassword;
  final bool obscurePassword;
  final Widget? suffixIcon;

  const CustonInput({
    Key? key,
    required this.icon,
    required this.placeholder,
    required this.textController,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.obscurePassword = true,
    this.suffixIcon,
  }) : super(key: key);

  @override
  _CustonInputState createState() => _CustonInputState();
}

class _CustonInputState extends State<CustonInput> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFF1F5545),
                offset: Offset(0.5, 1.8),
                blurRadius: 5,
              )
            ],
          ),
          child: TextField(
            textCapitalization: TextCapitalization.sentences,
            controller: widget.textController,
            autocorrect: false,
            maxLength: 50,
            obscureText: widget.isPassword ? _obscurePassword : false,
            keyboardType: widget.keyboardType,
            decoration: InputDecoration(
              prefixIcon: Icon(widget.icon, color: const Color.fromARGB(255, 0, 0, 0)),
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    )
                  : widget.suffixIcon,
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(3.4)),
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(3.4)),
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              hintText: widget.placeholder,
              counterText: '',
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}
