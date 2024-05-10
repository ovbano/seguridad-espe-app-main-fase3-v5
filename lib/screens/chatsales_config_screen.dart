// ignore_for_file: unused_import, unused_element

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/blocs/room/room_bloc.dart';
import 'package:flutter_maps_adv/screens/chatsales_miembros.dart';
import 'package:flutter_maps_adv/screens/rooms_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DetalleSalaScreen extends StatelessWidget {
  static const String detalleSalaroute = 'detalleSala';
  const DetalleSalaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatProvider = BlocProvider.of<RoomBloc>(context);
    final auth = BlocProvider.of<AuthBloc>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
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
            child: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              iconTheme: const IconThemeData(color: Colors.white),
              centerTitle: false,
              title: const Text(
                'Detalle',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              //actions: const [IconModal()],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(int.parse(
                                '0xFF${chatProvider.state.salaSeleccionada.color.substring(0, 2)}DDBB${chatProvider.state.salaSeleccionada.color.substring(4)}')),
                            Color(int.parse(
                                '0xFF${chatProvider.state.salaSeleccionada.color}')),
                            const Color.fromARGB(255, 230, 116, 226),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(16),
                      child: CircleAvatar(
                        radius: size.width * 0.07,
                        backgroundColor: Colors.transparent,
                        child: Text(
                          chatProvider.state.salaSeleccionada.nombre
                              .substring(0, 2)
                              .toUpperCase(),
                          style: const TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 219, 219, 219),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.black87,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Acerca de',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          chatProvider.state.salaSeleccionada.nombre,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Miembros',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Material(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          MienbrosChatScreen.mienbrosChatroute,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color.fromARGB(255, 201, 201, 201),
                              Color.fromARGB(255, 255, 255, 255),
                            ],
                          ),
                          border: Border.all(
                            color: Colors.grey[300]!,
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "Miembros de la sala",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: Colors.black87,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Invitar a nuevos miembros',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: chatProvider.state.salaSeleccionada.codigo,
                        ),
                      );
                      // Agrega aquí una notificación o mensaje para indicar que se ha copiado el código al portapapeles
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              chatProvider.state.salaSeleccionada.codigo,
                              style: const TextStyle(color: Colors.black87),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.content_copy, size: 24),
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(
                                text:
                                    chatProvider.state.salaSeleccionada.codigo,
                              ),
                            );
                            Fluttertoast.showToast(
                              msg: 'Copiado',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.black87,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(height: 1, color: Colors.black26),
                  Padding(
  padding: const EdgeInsets.only(top: 10),
  child: Material(
    borderRadius: BorderRadius.circular(10),
    color: Colors.white,
    child: InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        auth.state.usuario!.uid ==
                chatProvider.state.salaSeleccionada.propietario
            ? _showDialogEliminar(context, chatProvider)
            : _showDialog(context, chatProvider, auth);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.red,
        ),
        child: Center(
          child: Text(
            auth.state.usuario!.uid ==
                    chatProvider.state.salaSeleccionada.propietario
                ? 'Salir y eliminar grupo'
                : 'Salir del grupo',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ),
  ),
),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //showDialog si esta seguro de salir
  void _showDialog(BuildContext context, RoomBloc chatProvider, AuthBloc auth) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Estás seguro de salir?'),
          content: const Text(
            'Si sales del grupo, no podrás ver los mensajes que se envíen en él.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'CANCELAR',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                chatProvider.add(AbandonarSalaEvent(auth.state.usuario!.uid));
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text(
                'SALIR',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          backgroundColor: Colors.white,
          elevation: 4.0,
        );
      },
    );
  }

  //_showDialog si esta seguro de eliminar y salir
  void _showDialogEliminar(BuildContext context, RoomBloc chatProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Estás seguro?'),
          content: const Text(
            'Al salir del grupo, se eliminará el grupo y ningún miembro tendrá acceso. Esta acción es irreversible.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'CANCELAR',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                chatProvider.add(
                    DeleteSalaEvent(chatProvider.state.salaSeleccionada.uid));
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text(
                'SALIR Y ELIMINAR',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          backgroundColor: Colors.white,
          elevation: 4.0,
        );
      },
    );
  }
}
