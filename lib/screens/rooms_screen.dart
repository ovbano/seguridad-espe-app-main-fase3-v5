// ignore_for_file: avoid_print, unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/base/userService.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/blocs/room/room_bloc.dart';
import 'package:flutter_maps_adv/helpers/page_route.dart';
import 'package:flutter_maps_adv/models/sales_response.dart';
import 'package:flutter_maps_adv/models/usuario.dart';
import 'package:flutter_maps_adv/screens/chatsales_screen.dart';
import 'package:flutter_maps_adv/screens/code_add_sreen.dart';
import 'package:flutter_maps_adv/screens/code_create_sreen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RoomsScreen extends StatelessWidget {
  static const String salasroute = 'salas';
  const RoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final roonBloc = BlocProvider.of<RoomBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
              // borderRadius: BorderRadius.only(
              //   bottomLeft: Radius.circular(30),
              //   bottomRight: Radius.circular(30),
              // ),
            ),
            child: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              iconTheme: const IconThemeData(color: Colors.white),
              centerTitle: false,
              title: const Text(
                'Grupos',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              actions: const [IconModal()],
            ),
          ),
          Expanded(
            child: BlocBuilder<RoomBloc, RoomState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color.fromRGBO(2, 79, 49, 1),
                    ),
                  );
                }
                if (state.salas.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: SvgPicture.asset(
                            'assets/info/charicons.svg',
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          '!Más seguro en grupo!',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto', // Cambio de fuente
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Crea o únete a un grupo para mantenerte informado sobre lo que reportan tus amigos y familiares.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontFamily: 'Roboto', // Cambio de fuente
                          ),
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                  CreateRoute.createRoute(
                                      CodigoAddGrupoScreen()));
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black87,
                              backgroundColor: Colors.white,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    25), // Bordes redondeados
                                side: const BorderSide(
                                    color:
                                        Color.fromRGBO(2, 79, 49, 1)), // Borde
                              ),
                            ),
                            child: const Text(
                              'Unirse a un grupo',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Roboto', // Cambio de fuente
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                  CreateRoute.createRoute(
                                      const CodigoCreateGrupoScreen()));
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  const Color.fromRGBO(2, 79, 49, 1),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    25), // Bordes redondeados
                              ),
                            ),
                            child: const Text(
                              'Crear un grupo',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Roboto', // Cambio de fuente
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Container(
                  color: Colors.white,
                  child: RefreshIndicator(
                    onRefresh: () async {
                      roonBloc.salasInitEvent();
                    },
                    color: const Color.fromRGBO(2, 79, 49, 1),
                    child: Column(
                      children: [
                        //Si esta cargando un pequeño circulo de carga
                        // if (state.isLoading)
                        //   const Padding(
                        //     padding: EdgeInsets.only(top: 10),
                        //     child: SizedBox(
                        //       height: 3,
                        //       child: LinearProgressIndicator(
                        //         color: Color.fromRGBO(2, 79, 49, 1),
                        //       ),
                        //     ),
                        //   ),
                        Expanded(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 13),
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context,
                                        CodigoCreateGrupoScreen
                                            .codigoGruporoute);
                                  },
                                  child: const Row(
                                    children: [
                                      //icon de add grupo
                                      Icon(
                                        FontAwesomeIcons.plus,
                                        color: Color.fromRGBO(2, 79, 49, 1),
                                        size: 20,
                                      ),

                                      SizedBox(
                                        width: 30,
                                      ),
                                      Text(
                                        'Crear un nuevo grupo',
                                        style: TextStyle(
                                            color: Color.fromRGBO(2, 79, 49, 1),
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: state.salas.length,
                                  itemBuilder: (context, index) {
                                    return SalaListTitle(
                                        sala: state.salas[index]);
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SalaListTitle extends StatelessWidget {
  final Sala sala;

  const SalaListTitle({super.key, required this.sala});

  @override
  Widget build(BuildContext context) {
    final salasService = context.read<RoomBloc>();
    final membersBloc = context.read<MembersBloc>();

    return Row(
      children: [
        Expanded(
          child: ListTile(
            title: Text(sala.nombre),
            trailing:
                sala.mensajesNoLeidos == 0 || sala.mensajesNoLeidos == null
                    ? const SizedBox()
                    : Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.red[500],
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        child: Center(
                          child: Text(
                            sala.mensajesNoLeidos.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
            subtitle: Text('${sala.totalUsuarios} miembros'),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(int.parse(
                        '0xFF${sala.color.substring(0, 2)}DDBB${sala.color.substring(4)}')),
                    Color(int.parse('0xFF${sala.color}')),
                    const Color.fromARGB(255, 230, 116, 226),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(100.0),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Text(
                  sala.nombre.substring(0, 2),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            onTap: () {
              print("sala seleccionada ${sala.nombre}");
              membersBloc.add(ChatInitEvent());
              salasService.add(SalaSelectEvent(sala));
              salasService.add(ResetTotalMensajesNoLeidosEvent(sala.uid));
              Navigator.of(context)
                  .push(CreateRoute.createRoute(const ChatScreen()));
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            // Seleccionar la sala antes de mostrar el modal de miembros
            salasService.add(SalaSelectEvent(sala));
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              builder: (BuildContext context) {
                return UserMembers(uid: sala.uid);
              },
            );
          },
        ),
      ],
    );
  }
}

class IconModal extends StatelessWidget {
  const IconModal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        //boton de los tres puntos
        Icons.more_vert,
        color: Color.fromARGB(255, 255, 255, 255),
      ),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          builder: (BuildContext context) {
            return Container(
              height: 120.0,
              decoration: const BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        FontAwesomeIcons.plus,
                        color: Colors.black,
                      ),
                      title: const Text('Crear un nuevo grupo'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                            context, CodigoCreateGrupoScreen.codigoGruporoute);
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        FontAwesomeIcons.userGroup,
                        color: Colors.black,
                      ),
                      title: const Text('Unir a un grupo'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                            context, CodigoAddGrupoScreen.codigoAddGruporoute);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
