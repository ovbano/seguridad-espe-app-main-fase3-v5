// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/blocs/notification/notification_bloc.dart';
import 'package:flutter_maps_adv/blocs/room/room_bloc.dart';
import 'package:flutter_maps_adv/screens/home_screen.dart';
import 'package:flutter_maps_adv/screens/information_family_screen.dart';
import 'package:flutter_maps_adv/screens/information_screen.dart';
import 'package:flutter_maps_adv/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingLoginScreen extends StatelessWidget {
  static const String loadingroute = 'loadingLogin';

  const LoadingLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F5545),
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 1, // Ajusta la altura según sea necesario
                ),
                Container(
                  alignment:
                      Alignment.center, // Centra la imagen en el contenedor
                  child: Image.asset(
                    'assets/HD_Logo.png', // Ruta de tu imagen PNG
                    width:
                        400, // Ajusta el tamaño del logo según tus necesidades
                  ),
                ),
                const SizedBox(
                  height: 1,
                ), // Espacio entre la imagen y el texto
                const Text(
                  'Community',
                  style: TextStyle(
                    fontFamily: 'CustomFont',
                    color: Colors.white,
                    fontSize:
                        24, // Tamaño de fuente ajustado según tus necesidades
                    fontWeight: FontWeight.bold, // Texto en negrita
                  ),
                ),
                const Text(
                  'Safe',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize:
                        24, // Tamaño de fuente ajustado según tus necesidades
                    fontWeight: FontWeight.bold, // Texto en negrita
                  ),
                ),
                const SizedBox(
                  height: 10, // Espacio entre el título y la línea vertical
                ),
                Container(
                  width: 250,
                  height: 2, // Altura de la línea vertical
                  color: const Color.fromARGB(
                      255, 255, 0, 0), // Color de la línea vertical
                ),
                const SizedBox(
                  height: 50,
                ), // Espacio entre la línea vertical y el CircularProgressIndicator
                const SizedBox(
                  height: 110,
                ), // Espacio entre el texto y el CircularProgressIndicator
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                const SizedBox(
                  height: 16,
                ), // Espacio entre el CircularProgressIndicator y el texto "Espere..."
                const Text(
                  'Espere...',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> checkLoginState(BuildContext context) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    // Verificar si es el primer lanzamiento almacenando un valor en SharedPreferences
    bool isFirstLaunch = sharedPreferences.getBool('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      // Si es el primer lanzamiento, enviar al usuario a la pantalla de inicio de sesión
      navigateToReplacement(context, const LoginScreen());

      // Actualizar el valor para indicar que la aplicación ya ha sido lanzada antes
      await sharedPreferences.setBool('isFirstLaunch', false);
    } else {
      // Si no es el primer lanzamiento, continuar con la lógica original
      print("LoadingLoginScreen");
      final authService = BlocProvider.of<AuthBloc>(context, listen: false);
      final roomBloc = BlocProvider.of<RoomBloc>(context, listen: false);
      final publicationBloc =
          BlocProvider.of<PublicationBloc>(context, listen: false);

      final notificationBloc =
          BlocProvider.of<NotificationBloc>(context, listen: false);
      final result = await authService.init();
      BlocProvider.of<NavigatorBloc>(context)
          .add(const NavigatorIndexEvent(index: 0));
      if (result) {
        if (authService.getUsuario()?.telefono == null ||
            authService.getUsuario()?.telefonos == null) {
          await roomBloc.salasInitEvent();
          await publicationBloc.getAllPublicaciones();
          await notificationBloc.loadNotification();
          if (authService.getUsuario()?.telefono == null) {
            navigateToReplacement(context, const InformationScreen());
          } else if (authService.getUsuario()?.telefonos == null) {
            navigateToReplacement(context, const InformationFamily());
          } else {
            navigateToReplacement(context, const HomeScreen());
          }

          // await roomBloc.salasInitEvent();
          // await publicationBloc.getAllPublicaciones();
          // await notificationBloc.loadNotification();
          // navigateToReplacement(context, const InformationScreen());
        } else {
          await roomBloc.salasInitEvent();
          await publicationBloc.getAllPublicaciones();
          await notificationBloc.loadNotification();

          navigateToReplacement(context, const HomeScreen());
        }
      } else {
        await authService.logout();
        navigateToReplacement(context, const LoginScreen());
      }
    }
  }

  void navigateToReplacement(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionDuration: const Duration(milliseconds: 0),
      ),
    );
  }
}
