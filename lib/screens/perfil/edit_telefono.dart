// ignore_for_file: use_key_in_widget_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';

class EditTelefonoScreen extends StatefulWidget {
  static const String editTelefonoeroute = 'editTelefono';
  const EditTelefonoScreen({Key? key});

  @override
  State<EditTelefonoScreen> createState() => _EditTelefonoScreenState();
}

class _EditTelefonoScreenState extends State<EditTelefonoScreen> {
  bool isValido = false;
  AuthBloc authBloc = AuthBloc();
  bool _isPhoneNumberValid =
      true; // Variable para controlar si el número de teléfono es válido

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
    _textController.text = authBloc.state.usuario!.telefono ?? '';
  }

  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(106, 162, 142, 1),
                  Color.fromRGBO(2, 79, 49, 1),
                ],
              ),
              // borderRadius: BorderRadius.only(
              //   bottomLeft: Radius.circular(30),
              //   bottomRight: Radius.circular(30),
              // ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const Text(
                    'Cambiar Teléfono',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 50),
                  IconButton(
                    onPressed: () async {
                      final phoneNumber = _textController.text.trim();
                      if (isValidPhoneNumber(phoneNumber)) {
                        await authBloc.updateUsuario(
                          authBloc.state.usuario!.nombre,
                          phoneNumber,
                        );
                        Navigator.pop(context);
                      } else {
                        setState(() {
                          _isPhoneNumberValid = false;
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _textController,
                maxLength: 10,
                onChanged: (value) {
                  setState(() {
                    _isPhoneNumberValid = isValidPhoneNumber(value);
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Teléfono',
                  labelStyle: const TextStyle(
                    color: Color.fromARGB(255, 17, 101, 25),
                  ),
                  prefixIcon: Icon(
                    Icons.phone,
                    color: Colors.green[700],
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: _isPhoneNumberValid
                          ? const Color.fromARGB(255, 17, 101, 25)
                          : Colors.red,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isValidPhoneNumber(String phoneNumber) {
    if (phoneNumber.length != 10) {
      return false;
    }

    if (!phoneNumber.startsWith('09')) {
      return false;
    }

    for (int i = 2; i < phoneNumber.length; i++) {
      if (!RegExp(r'[0-9]').hasMatch(phoneNumber[i])) {
        return false;
      }
    }
    return true;
  }
}
