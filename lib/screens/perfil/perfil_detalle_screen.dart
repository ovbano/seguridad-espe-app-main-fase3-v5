// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/global/environment.dart';
import 'package:flutter_maps_adv/models/publication.dart';
import 'package:flutter_maps_adv/screens/screens.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timeago/timeago.dart' as timeago;

class PerfilDetalleScreen extends StatelessWidget {
  static const String perfilDetalleroute = 'perfilDetalle';
  const PerfilDetalleScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final publicationBloc = BlocProvider.of<PublicationBloc>(context);
    publicationBloc.getPublicacionesUsuario();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(
                        context); // Acción al presionar el botón de regresar
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const Text(
                  'Perfil',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 50),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<PublicationBloc, PublicationState>(
              builder: (context, state) {
                return Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: _PerfilCicle(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, EditPerfilScreen.editPerfilroute);
                        },
                        icon: const Icon(Icons.edit, size: 20),
                        label: const Text('Editar perfil'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 10),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today),
                          const SizedBox(width: 15),
                          Text(
                            'Miembro desde ${timeago.format(DateTime.parse(authBloc.state.usuario!.createdAt), locale: 'es')}',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Divider(color: Colors.black26),
                    const Text(
                      'Mis Reportes',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(color: Colors.black26),
                    state.publicacionesUsuario.isEmpty
                        ? const Center(child: Text('No hay reportes'))
                        : Flexible(
                            child: _ListNews(
                              publicaciones: state.publicacionesUsuario,
                              firstController: ScrollController(),
                              size: MediaQuery.of(context).size,
                              publicationBloc: publicationBloc,
                              usuarioBloc: authBloc,
                              state: state,
                            ),
                          ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PerfilCicle extends StatelessWidget {
  const _PerfilCicle();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            state.usuario!.img == null
                ? const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/no-image.png'),
                  )
                : state.usuario!.google
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(state.usuario!.img!),
                      )
                    : CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                            '${Environment.apiUrl}/uploads/usuario/usuarios/${state.usuario!.uid}'),
                  ),
            const SizedBox(width: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.usuario!.nombre,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    state.usuario!.email,
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ListNews extends StatelessWidget {
  const _ListNews({
    required this.publicaciones,
    required ScrollController firstController,
    required this.size,
    required PublicationBloc publicationBloc,
    required this.usuarioBloc,
    required this.state,
  })  : _firstController = firstController,
        _publicationBloc = publicationBloc;

  final List<Publicacion> publicaciones;
  final ScrollController _firstController;
  final Size size;
  final PublicationBloc _publicationBloc;
  final AuthBloc usuarioBloc;
  final PublicationState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: publicaciones.length,
            controller: _firstController,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, i) => Card(
              margin: const EdgeInsets.all(8),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: CircleAvatar(
                                  backgroundColor: Color(int.parse(
                                      "0xFF${publicaciones[i].color}")),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: publicaciones[i]
                                            .imgAlerta
                                            .endsWith('.png')
                                        ? Image.asset(
                                            'assets/alertas/${publicaciones[i].imgAlerta}',
                                            color: Colors.white,
                                          )
                                        : SvgPicture.asset(
                                            'assets/alertas/${publicaciones[i].imgAlerta}',
                                            // ignore: deprecated_member_use
                                            color: Colors.white,
                                          ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.50,
                                    child: Text(
                                      publicaciones[i].titulo,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.50,
                                    child: Text(
                                      timeago.format(
                                        DateTime.parse(
                                            publicaciones[i].createdAt!),
                                        locale: 'es',
                                      ),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 62, right: 5),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(bottom: 3),
                                child: Text(publicaciones[i].contenido),
                              ),
                              publicaciones[i].imagenes != null &&
                                      publicaciones[i].imagenes!.isNotEmpty
                                  ? Container(
                                      width: double.infinity,
                                      height: size.height * 0.35,
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(9.0),
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(9.0),
                                        ),
                                        child: Image.network(
                                          "${Environment.apiUrl}/uploads/publicaciones/${publicaciones[i].uid!}?imagenIndex=${publicaciones[i].imagenes!.first}",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : Container(),
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.only(top: 10),
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    _publicationBloc.add(PublicacionSelectEvent(
                                        publicaciones[i]));
                                    Navigator.pushNamed(
                                        context, DetalleScreen.detalleroute,
                                        arguments: {
                                          'publicacion': publicaciones[i],
                                        });
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        '${publicaciones[i].ciudad} - ${publicaciones[i].barrio}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      _publicationBloc
                          .add(PublicacionSelectEvent(publicaciones[i]));

                      Navigator.pushNamed(context, DetalleScreen.detalleroute,
                          arguments: {
                            'publicacion': publicaciones[i],
                            'likes': publicaciones[i].likes!.length.toString(),
                          });
                    },
                  ),
                ],
              ),
            ),
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 1);
            },
          ),
        ),
        if (state.isLoading)
          const LinearProgressIndicator(
            backgroundColor: Color(0x001f5545),
          ),
      ],
    );
  }
}
