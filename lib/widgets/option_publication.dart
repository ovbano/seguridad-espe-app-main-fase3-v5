// ignore_for_file: library_private_types_in_public_api, unused_local_variable, avoid_print, unnecessary_null_comparison, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/models/publication.dart';
import 'package:flutter_maps_adv/screens/news_detalle.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class OptionNews extends StatefulWidget {
  const OptionNews({
    super.key,
    required this.publicaciones,
    required this.state,
    required this.usuarioBloc,
    required this.i,
    required this.likes,
  });

  final List<Publicacion> publicaciones;
  final PublicationState state;
  final AuthBloc usuarioBloc;
  final int i;
  final List<String> likes;
  

  @override
  _OptionNewsState createState() => _OptionNewsState();
}

class _OptionNewsState extends State<OptionNews> {
  PublicationBloc publicationBloc = PublicationBloc();
  AuthBloc usuarioBloc = AuthBloc();
  bool showReactionsMenu = false; // Estado para mostrar el menú de reacciones
  IconData selectedReaction = FontAwesomeIcons.solidThumbsUp; // Reacción seleccionada
  Color? selectedColor = Colors.blue; // Color de la reacción seleccionada

  @override
  void initState() {
    super.initState();
    // Verificar si el usuario actual ya ha dado like en la publicación
    final currentUserUid = widget.usuarioBloc.state.usuario!.uid;
    publicationBloc = BlocProvider.of<PublicationBloc>(context);
    usuarioBloc = BlocProvider.of<AuthBloc>(context);
  }

  void _toggleReactionsMenu() {
    setState(() {
      showReactionsMenu = !showReactionsMenu;
    });
  }

  void _selectReaction(IconData reactionIcon, Color color) {
    setState(() {
      selectedReaction = reactionIcon;
      selectedColor = color;
      showReactionsMenu = false; // Cerrar el menú de reacciones después de seleccionar una
    });
    _handleReaction(reactionIcon);
  }

  void _handleReaction(IconData reactionIcon) {
    // Aquí puedes manejar la lógica para guardar la reacción en la base de datos
    // y cambiar el icono según la reacción seleccionada
  }

  void _handleLike() {
    setState(() {
      if (widget.likes.contains(usuarioBloc.state.usuario!.uid)) {
        widget.likes.remove(usuarioBloc.state.usuario!.uid);
      } else {
        widget.likes.add(usuarioBloc.state.usuario!.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int likesCount = widget.state.publicaciones[widget.i].likes!.length;

    return Stack(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    _handleLike(); // Llamar al método de manejo del like
                    _handleReaction(selectedReaction); // Llamar al método de manejo de la reacción
                  },
                  onLongPress: _toggleReactionsMenu, // Mostrar menú de reacciones
                  child: Row(
                    children: [
                      Container(
                        width: 30.0,
                        height: 50.0,
                        margin: const EdgeInsets.only(left: 28),
                        child: selectedReaction != null
                            ? Icon(
                                selectedReaction,
                                color: selectedColor, // Usar el color seleccionado
                                size: 18.0, // Tamaño del icono reducido
                              )
                            : Container(),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        likesCount.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.zero,
                        width: 30.0,
                        height: 35.0,
                        child: const Icon(
                          FontAwesomeIcons.comment,
                          color: Colors.grey,
                          size: 18.0, // Tamaño del icono reducido
                        ),
                      ),
                      Text(
                        widget.state.publicaciones[widget.i].comentarios == null
                            ? '0'
                            : widget.state.publicaciones[widget.i].countComentarios
                                .toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    publicationBloc
                        .add(PublicacionSelectEvent(widget.publicaciones[widget.i]));
                    Navigator.of(context)
                        .push(_createRoute(widget.publicaciones[widget.i]));
                  },
                ),
              ],
            ),
          ],
        ),
        // Menú de reacciones
        if (showReactionsMenu)
          Positioned(
            top: 8,
            left: 5,
            child: Container(
              width: 350.0, // Redimensionar el ancho del contenedor del menú
              height: 35.0,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.solidThumbsUp,
                      size: 18.0, // Tamaño del icono reducido
                    ),
                    color: selectedReaction == FontAwesomeIcons.solidThumbsUp
                        ? Colors.blue // Usar color azul si es la reacción seleccionada
                        : Colors.grey,
                    onPressed: () {
                      _selectReaction(FontAwesomeIcons.solidThumbsUp, Colors.blue);
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.solidThumbsDown,
                      size: 18.0, // Tamaño del icono reducido
                    ),
                    color: selectedReaction == FontAwesomeIcons.solidThumbsDown
                        ? Colors.red // Usar color rojo si es la reacción seleccionada
                        : Colors.grey,
                    onPressed: () {
                      _selectReaction(FontAwesomeIcons.solidThumbsDown, Colors.red);
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.solidHeart,
                      size: 18.0, // Tamaño del icono reducido
                    ),
                    color: selectedReaction == FontAwesomeIcons.solidHeart
                        ? Colors.pink // Usar color rosa si es la reacción seleccionada
                        : Colors.grey,
                    onPressed: () {
                      _selectReaction(FontAwesomeIcons.solidHeart, Colors.pink);
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.solidLaughBeam,
                      size: 18.0, // Tamaño del icono reducido
                    ),
                    color: selectedReaction == FontAwesomeIcons.solidLaughBeam
                        ? Colors.amber // Usar color ámbar si es la reacción seleccionada
                        : Colors.grey,
                    onPressed: () {
                      _selectReaction(FontAwesomeIcons.solidLaughBeam, Colors.amber);
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.solidSurprise,
                      size: 18.0, // Tamaño del icono reducido
                    ),
                    color: selectedReaction == FontAwesomeIcons.solidSurprise
                        ? Colors.orange // Usar color naranja si es la reacción seleccionada
                        : Colors.grey,
                    onPressed: () {
                      _selectReaction(FontAwesomeIcons.solidSurprise, Colors.orange);
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.solidSadTear,
                      size: 18.0, // Tamaño del icono reducido
                    ),
                    color: selectedReaction == FontAwesomeIcons.solidSadTear
                        ? Colors.blueGrey // Usar color gris azulado si es la reacción seleccionada
                        : Colors.grey,
                    onPressed: () {
                      _selectReaction(FontAwesomeIcons.solidSadTear, Colors.blueGrey);
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.solidAngry,
                      size: 18.0, // Tamaño del icono reducido
                    ),
                    color: selectedReaction == FontAwesomeIcons.solidAngry
                        ? Colors.red // Usar color rojo si es la reacción seleccionada
                        : Colors.grey,
                    onPressed: () {
                      _selectReaction(FontAwesomeIcons.solidAngry, Colors.red);
                    },
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}




Route _createRoute(Publicacion publicacion) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const DetalleScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
