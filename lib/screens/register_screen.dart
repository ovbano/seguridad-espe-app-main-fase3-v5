import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';
import 'package:flutter_maps_adv/helpers/mostrar_alerta.dart';
import 'package:flutter_maps_adv/screens/screens.dart';
import 'package:flutter_maps_adv/widgets/boton_login.dart';
import 'package:flutter_maps_adv/widgets/custom_input.dart';
import 'package:flutter_maps_adv/widgets/labels_login.dart';
import 'package:flutter_maps_adv/widgets/logo_login.dart';

class RegisterScreen extends StatelessWidget {
  static const String registerroute = 'register';

  const RegisterScreen({super.key});

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
                "REGISTRO",
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Logo(text: ""),
                    _From(),
                    Labels(
                      ruta: 'login',
                      text: "¿Ya tienes cuenta?",
                      text2: "Ingresa",
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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nomController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authServiceBloc = BlocProvider.of<AuthBloc>(context);

    return Column(children: [
      //Nombre
      CustonInput(
        icon: Icons.perm_identity,
        placeholder: "Nombres",
        keyboardType: TextInputType.text,
        textController: nomController,
      ),

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
        obscurePassword: _obscurePassword,
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),

      BotonForm(
        text: "Crear cuenta",
        onPressed: authServiceBloc.isLoggedInTrue
            ? () {}
            : () async {
                FocusScope.of(context).unfocus();

                String nombre = nomController.text.trim();
                String email = emailController.text.trim();
                String password = passwordController.text.trim();

                if (nombre.isEmpty || email.isEmpty || password.isEmpty) {
                  // Mostrar alerta indicando que los campos son obligatorios
                  mostrarAlerta(context, 'Campos vacíos',
                      'Todos los campos son obligatorios');
                  return;
                }

                if (!isValidEmail(email)) {
                  // Mostrar alerta indicando que el formato del correo electrónico es incorrecto
                  mostrarAlerta(context, 'Correo electrónico inválido',
                      'Ingrese un correo electrónico válido');
                  return;
                }

                if (password.length < 6) {
                  // Mostrar alerta indicando que la contraseña debe tener al menos 6 caracteres
                  mostrarAlerta(context, 'Contraseña inválida',
                      'La contraseña debe tener al menos 6 caracteres');
                  return;
                }

                if (!containsNumber(password)) {
                  // Mostrar alerta indicando que la contraseña debe contener al menos un número
                  mostrarAlerta(context, 'Contraseña inválida',
                      'La contraseña debe contener al menos un número');
                  return;
                }

                if (!containsUppercaseLetter(password)) {
                  // Mostrar alerta indicando que la contraseña debe contener al menos una letra en mayúscula
                  mostrarAlerta(context, 'Contraseña inválida',
                      'La contraseña debe contener al menos una letra en mayúscula');
                  return;
                }

                final resulta =
                    await authServiceBloc.register(nombre, email, password);

                if (!resulta) {
                  // Mostrar alerta indicando que el correo electrónico ya está en uso
                  // ignore: use_build_context_synchronously
                  mostrarAlerta(context, 'Correo electrónico en uso',
                      'El correo electrónico ya está en uso');
                  return;
                }

                if (authServiceBloc.isLoggedInTrue) {
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacementNamed(
                      context, LoadingLoginScreen.loadingroute);
                } else {
                  // ignore: use_build_context_synchronously
                  mostrarAlerta(context, 'Registro incorrecto',
                      'Revise sus credenciales nuevamente');
                }
              },
      )
    ]);
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');

    return emailRegex.hasMatch(email);
  }

  bool containsNumber(String password) {
    return password.contains(RegExp(r'\d'));
  }

  bool containsUppercaseLetter(String password) {
    return password.contains(RegExp(r'[A-Z]'));
  }
}