// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BtnFollowUser extends StatelessWidget {
  const BtnFollowUser({super.key});

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final searchBloc = BlocProvider.of<SearchBloc>(context);

    return Tooltip(
      message: 'Seguir Usuario', // Descripción emergente del botón
      child: GestureDetector(
        onTap: () {
          searchBloc.add(const ToggloUpdateTypeMapEvent());
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300), // Duración de la animación
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              FontAwesomeIcons.layerGroup, // Ícono original del botón
              color: Colors.grey[800],
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
