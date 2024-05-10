// ignore_for_file: use_build_context_synchronously, duplicate_ignore, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/blocs/room/room_bloc.dart';
import 'package:flutter_maps_adv/helpers/mostrar_alerta.dart';
import 'package:flutter_maps_adv/screens/screens.dart';
import 'package:flutter_maps_adv/widgets/boton_login.dart';
import 'package:flutter_maps_adv/widgets/custom_input.dart';
import 'package:flutter_maps_adv/widgets/labels_login.dart';
import 'package:flutter_maps_adv/widgets/logo_login.dart';

class LoginScreen extends StatelessWidget {
  static const String loginroute = 'login';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(106, 162, 142, 1),
                  Color.fromRGBO(2, 79, 49, 1),
                ],
              ),
            ),
            child: const Center(
              child: Text(
                "INICIO DE SESIÓN",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                margin: const EdgeInsets.all(30),
                height: MediaQuery.of(context).size.height * 0.86,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Logo(text: ""),
                    _From(),
                    Labels(
                      ruta: 'register',
                      text: "¿No tienes cuenta?",
                      text2: "Crea una",
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _From extends StatefulWidget {
  const _From();

  @override
  State<_From> createState() => __FromState();
}

class __FromState extends State<_From> {
  //provider

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final roomBloc = BlocProvider.of<RoomBloc>(context);
    final publicationBloc = BlocProvider.of<PublicationBloc>(context);
    return Column(children: [
      CustonInput(
        icon: Icons.mail_outline,
        placeholder: "Email",
        keyboardType: TextInputType.emailAddress,
        textController: emailController,
      ),
      CustonInput(
        icon: Icons.lock_outline,
        placeholder: "Password",
        textController: passwordController,
        isPassword: true,
      ),
      BotonForm(
        text: "Ingrese",
        onPressed: () async {
          FocusScope.of(context).unfocus();
          if (emailController.text.isNotEmpty &&
              passwordController.text.isNotEmpty) {
            final result = await authBloc.login(
                emailController.text, passwordController.text);
            if (result) {
              await roomBloc.salasInitEvent();
              await publicationBloc.getAllPublicaciones();
              Navigator.pushReplacementNamed(
                  context, LoadingLoginScreen.loadingroute);
            } else {
              // ignore: use_build_context_synchronously
              mostrarAlerta(context, "Login incorrecto",
                  "Revise sus credenciales nuevamente");
            }
          } else {
            // Si los campos están vacíos, muestra una alerta o realiza alguna otra acción apropiada.
            mostrarAlerta(context, "Campos vacíos",
                "Por favor, complete todos los campos");
          }
        },
      ),
      //----or----
      const SizedBox(height: 10),
      const Text("O continue con"),
      const SizedBox(height: 10),
      BotonForm(
        text: "Google",
        onPressed: () async {
          try {
            FocusScope.of(context).unfocus();
            final result = await authBloc.signInWithGoogle();
            if (result) {
              // ignore: use_build_context_synchronously
              Navigator.pushReplacementNamed(
                  context, LoadingLoginScreen.loadingroute);
            }
          } catch (e) {
            print(e);
          }
        },
      ),
      //cerrar sesion
    ]);
  }
}